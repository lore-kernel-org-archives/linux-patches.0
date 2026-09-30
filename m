Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882774F93C3;
	Wed, 30 Sep 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782420; cv=none; b=Ow8k37WidneYQamCU9AGKymfvIKu4wy68OrIr/TidK5KwAAVmIkj32fy64EMfFF81bt9cFdi1XZq7qJAykTTR+3OZPh0/mKBDU7w2+QHEfUdjomGADrnDiOzjmBvlA0pPbd4nY6NMlnvcF2ZP/U0aAB7DNnuQ4nBN561R54ih4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782420; c=relaxed/simple;
	bh=WwruGt9sC+jASGvVuoaXgRGVVzVlhwj8BRVDaqGP+P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQNHWRgb4ASQ1r3gBLvQ6W8Ud8MV42EW6NruXbGSGYj1lDG8aQ1cJmJ2oXXc94lMTV/HJU3wWFDWXD/cPMISJ9a3N7HLr7yrROayBiO39KYEb0jIPoXHeZ+SH1mTaS8VnjD94gS/sglQNhyV6vMvGJKmGv3bYNe5Qrdi7OFMlNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aD3YInTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aD3YInTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB5C1F0089F;
	Wed, 30 Sep 2026 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782402;
	bh=qlZA9ZBK00sUp5QJ2e4FHtGYaxgoh0tXwkyvGw6ckvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aD3YInTYAsHyrN71/5NzMYFiIGEm9wcamLtB2taGnzFDQf56QLcomfxif08Mosngl
	 dGVvyUeB7zSIhyNvzSpywljLvWoJ3ZjMV43NrS3yVMZUumwoOuoChzKlFQgp/r2sVn
	 udXsr8kQSOl7ZUd5btCH9HtOvESlYCkGws5UEQew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/595] net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family
Date: Wed, 30 Sep 2026 17:18:30 +0200
Message-ID: <20260930152348.093426030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit e0fdb4157a85056bd256a7aebac4a3a2f580b201 ]

Commit 9e5baf9b3636 ("net: dsa: mv88e6xxx: add RMU disable op") did not
add the .rmu_disable() method for the 6320 family. Add it now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-5-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5f38b5d2da155..3460f50069a7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4170,6 +4170,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
@@ -4212,6 +4213,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
-- 
2.53.0



