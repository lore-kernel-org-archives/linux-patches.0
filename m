Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5DF4E3226;
	Thu, 17 Sep 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661067; cv=none; b=aTXUtr3zOZJfQ0oslLqPyboFZaTTR+7VfIEyfkZdtNKXKQXwDo/Uz2fSqPj1Gd6zBngFXOZG40vZZbMy8hV2o3me2x4W9W58/t8FaJuu23QZ26mWo6NHLaKsgeXgOGlA4SnwS3/N60VqQygkkKtgHyTyJTX3t4RLJlQeL22KEMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661067; c=relaxed/simple;
	bh=WZvhX/7UL36skAGsAXrwqkbVGfOpXUM3uUiUOgCz1wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9Qn1WkSRsvJ7OutLJQeBnZVwCWojYGh1aC/0qpYCLgLMVK+3wnSbddbwo3DuuGC4iRJXx2N9ymarFMGZFTlH+XNQSrwMk4r5tnlT/o9h0CAwWwpeCo/5Dfjbt5WJ29bJgkDSPd0KFA1hdZTnPWlezYfJ/k3lLqWStlj0W+UYeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcVMVo2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcVMVo2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6B01F000FF;
	Thu, 17 Sep 2026 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661065;
	bh=WlmaIARx3huojkYSKECaE456pTYawOooaKKuYdA89eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcVMVo2XVTny9OY8RVrCmtjK3/vdDfzzzuFid81gZEJ5yetrXP9VPkiQmlHneY9kG
	 LN0p9CULr7Kqb2V/ugaCVbv85PQPjxrlPGI1ffLNLBQCZk9CPNIqUs2k99M/27H2hH
	 hodvgnjDv9toXJKkpRuI5pTQ1oR/u8wyKBmRPjbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0070/1250] net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family
Date: Thu, 17 Sep 2026 15:57:45 +0100
Message-ID: <20260917151553.841685330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f324b88450427..7e294f2104b86 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5179,6 +5179,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
@@ -5232,6 +5233,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
+	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.stu_getnext = mv88e6352_g1_stu_getnext,
-- 
2.53.0



