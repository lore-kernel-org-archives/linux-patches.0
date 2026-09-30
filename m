Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168E8525A7D;
	Wed, 30 Sep 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790626; cv=none; b=g+FIgaZmLTUyOgJICk8LMSiL0hJic6vFrEngn/mMvl8a+6n7fI8lO3OAx8AiA6q7EpeVzGRYGR9ZYhZKoLnoDQMD/w8GbBOgxJ7fm2DL1FNgT2AEx6FgPD6u1FFxYnsKtXhoHEBGw826L+cgNURqRxPP7ZskJwvI9k3e7oxnpv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790626; c=relaxed/simple;
	bh=/8b0aeMylDLHPW/+e39k+lGeZ25/8Eq1Vf63S2+qzmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wtq98JbVVkh0kVqxKMVDhGNjMkvIVdqxZy8DKq4Y9/0FHZR4zFyEBUV934BtnWM2qnzLRvKQls5RQW94vHX8KdZSZJsIXhPLdqr9OT8TgEJfUi56gNR1gHen9M/cE3guhn0SOCP+E7TebZkyz1LI21sFTacsBbDemE2xYBbxHIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWt9ohqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWt9ohqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F67F1F000FF;
	Wed, 30 Sep 2026 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790625;
	bh=Z6NSsZlbI2Kr29mC6OxAI3hAia4yN/osEma2y6KW8M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWt9ohqkisl+RMSATUQCGRn+jhYdvuIK21cr5DLZevEchG3sak8DAtMNEKdbwgC3p
	 qOum+E9xVdm+fWf7rYDvuJka9sUIig0Y1yQYPlI66dzU54iOhwqeQ3pPP4rUgfUmGg
	 NZ21NBivc+nSrXsTnjZFvLYZAYgQFsbQJt/lpMOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/752] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Wed, 30 Sep 2026 17:18:08 +0200
Message-ID: <20260930152358.545513147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4dc2c465bc434..b38b6f89e5cc3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4666,6 +4666,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0



