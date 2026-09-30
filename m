Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2DE4E0B66;
	Wed, 30 Sep 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784206; cv=none; b=P/umllzxEBZOUKjvpwY34Pc3PhXmPEgEIA2cIpd7c3kpYTa4UYMpbL+Vccxo1YrN8bRTjYp4Fp3MZHpUHp1z/qQXTIp+rzh5wrAJqXgSx+nZzA9/mCchTq6FpSF4JwTrMT2/GMXztMZSnUqs8eEu5pPwweo0FkUFh7d5saqe1EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784206; c=relaxed/simple;
	bh=sejGuCW6NX0NQixCXfy+PKA/9dC/lXA5p9ApaVtt6lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCHHx2BZCnDzL/oN3dx4t4QemSnDhSo76s7XQl1Aguk58iMES+MoRBUMofgghspE97v5guZxW9yquiqArZmAzd5t+/2bqazm79QnjEV+sNle3NAJ4ijNvMPMIzFDQqQ4wboRDagYImi3hQc86siXj9kXVpJq4+YAHjsodCyybCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsCRUqgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsCRUqgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354391F00898;
	Wed, 30 Sep 2026 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784201;
	bh=30m9h/LJmSLO5HVQSgOR/EU5tGWr0+xvze7PKf/8bAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsCRUqgwjjlB5GrpqFfY7dEb/b64UFzgiJGtKsA+K2E0VMNaffHDAY8Ma7NUaDu0m
	 QDSQASA/Puhl5oSSZ1/em7liJqhFKjd1xeFnkQ6N21o6DJjfoVLw4x9PJ9/ZxDI3O4
	 EihdkxOJYYIqxSHj2AtuQmETfC+dWUzI3rb8aUIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/982] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Wed, 30 Sep 2026 17:12:42 +0200
Message-ID: <20260930152417.359954682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 17826d9708a57d27011d0a6efdebb628d6f8299a ]

Commit 9e907d739cc3 ("net: dsa: mv88e6xxx: add POT operation") did not
add the .pot_clear() method to the 6321 switch operations structure.
Add them now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-4-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 783d7035f065e..ac325b3abcae9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5245,6 +5245,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0



