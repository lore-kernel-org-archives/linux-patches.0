Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD1547075;
	Thu, 17 Sep 2026 17:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667415; cv=none; b=NPJCsZvxnGEFl/00sWzk9b6v9yqIcAFqLeRXsszaXPtFHQs2Gu+bxFMSzK8uVrp8jYdwZOn3ynWewUO8aALESdWfNjQOC3B3c0yObfVw/vPtUW3esmIjGPG4ydrLSvnZXndwiu+mCgfmkhDd9pHQzbUBMrZj26nqsI9T34DcpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667415; c=relaxed/simple;
	bh=cZvWRgZecvAcv9lj0eB88onA8PN5YoodiHACMVX50Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCLfhZg7y+CdYMxMLi4IsjrMxbIRQ1rJFgtEARkbLqmEp55xoDC5Lx4MTl7NnClvh5pnX4YBzsf3ZJ/KuzBj1u1QBK4c+3E8deuATkSQrFPHomNXT3mzZ+6OcHBchXL/67HB0ezmcVskAbu8Hux7I0vM4ZRvH1R8cYT9/08WEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nAJ2IKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nAJ2IKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD191F000FF;
	Thu, 17 Sep 2026 17:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667414;
	bh=hyLH/aQgi3nlhvm74yk0UzsmC3byl+gFQupbAIuY2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nAJ2IKnU1NN5+IR+akwSaMzuV6Ute8L0UF5jrWQI8hQQ3YBcjPk2x4kvOJtUZHo+
	 3BBy0RslSiZh4ypEJOmnEsgHV00LzeRm/Azdgnu+fFLyIXPu9iafP3+QkBzgCC9Xlm
	 DD+YvO4mbIKd9Fw57e7V4FiCycwaOjBbWhJ465sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0048/1102] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Thu, 17 Sep 2026 15:59:51 +0100
Message-ID: <20260917151540.654578878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9794e44977275..93e6e3ed69789 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5260,6 +5260,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0



