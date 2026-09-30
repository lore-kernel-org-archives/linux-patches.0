Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C83B3BF2;
	Wed, 30 Sep 2026 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793929; cv=none; b=oU0kNS3v2FY9cD/I0UM2bCW6ijJw+82RDGovs+P83eKxxGC7lasCJk49ltkUT72/khfTJXeyEvWcY/BuKZorNA77xqpi9rx/7FSCof/OEQyS0KxvlBCB6vqLzG/NpYobeRGyJNgw02IYPQXz3M+CIgDdFdaGIbFybVL0tlmyZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793929; c=relaxed/simple;
	bh=ac+6R1RJ0Eb2hZUZlp27r7sTTti81ymzj1I1GEzUMUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ExhTnPsbXE2Bo0UzmX2QdHCckBjkM4+x8IUMW7DYBcf9ZU3uJJOIZ472VbMC4piqqno8TLvE+u4ckKLe+A4k9GVKNWurZ2Qm5dRenVnpPRRMaQdNvxfoU7pxajzVwgjuYyUTONfWbbyjokC6if7CmPkhTc/LQIkdJsKnRrlG2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+nBoN6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+nBoN6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821591F000FF;
	Wed, 30 Sep 2026 18:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793927;
	bh=Gq8thSy3go8bmdlXFRnVp4NsxkkEhVqaqolL8y5jZ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+nBoN6dQBobAwnyb4XZ+nqgVY7xuHxaZhzXcGszdDEZFo/CQmyk2hgkaLWKU006L
	 YMWMwMQX8pMDrLlDGXNsIXYWCNhLWKlMz28vM/UvabihWaqu3ooPTrRirxXHVq03Ts
	 vzQ/jgd8u09NjuhbZMaKHrbGfABgFKwj2Qd1mbno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0031/1193] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Wed, 30 Sep 2026 17:11:55 +0200
Message-ID: <20260930152434.982114476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a3f481263d072..f88d751a71b57 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5121,6 +5121,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0



