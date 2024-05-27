Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EF017E90E;
	Mon, 27 May 2024 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837088; cv=none; b=YILkblbOmH4dHdEs/309TN7q8U3T+h4H3k5LVfgpQi4NyF2v17B+nwMhspG1up/UifDy9yIsK4bhMk97YMnueS2Bz+EOVdNqaLY0u66SkDsTIqAqxs0h74gJAgl4MfLihzl08oP6cTc5cdnQLyyjYe2baK5U4bsn2UCSBhVklyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837088; c=relaxed/simple;
	bh=Z41lnDo7t6wKuthNYBwcU1IgILOV0B9eHyTjcwoQ8KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QctGWIOpOOK+hmo+ZQKVESOuwjBBya9fhW/cOfyEYSIAyVmJbnugFu/H2ybmz+nBjqMBY96TIagbmRUSxqqdL3edXBxrb3eF7YYdlJ7UDdd5LZWfjTqMoTDQfJXmZsySU1eQZ22pFIBpAAgu+9xeCrxGfEsm816fBMD1ebDSxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=da4/RoZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="da4/RoZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D60C2BBFC;
	Mon, 27 May 2024 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837088;
	bh=Z41lnDo7t6wKuthNYBwcU1IgILOV0B9eHyTjcwoQ8KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=da4/RoZvjK9PauYcB0wL4Cwu3ozjvuI1jux+g5E/cMh1FfCUk+OcBTjguBXUUhAyk
	 kAghRCPRvi9g5CR9RlbnrMNQu9X/YaCHjLdC3DJyDa/cuwAbeWk8Y6CM6jg1L/Yaxg
	 a94+UwgesyoAWIZHabsPmOBVv7mNL4hSynvn37g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 305/427] fbdev: sisfb: hide unused variables
Date: Mon, 27 May 2024 20:55:52 +0200
Message-ID: <20240527185630.535127506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 688cf598665851b9e8cb5083ff1d208ce43d10ff ]

Building with W=1 shows that a couple of variables in this driver are only
used in certain configurations:

drivers/video/fbdev/sis/init301.c:239:28: error: 'SiS_Part2CLVX_6' defined but not used [-Werror=unused-const-variable=]
  239 | static const unsigned char SiS_Part2CLVX_6[] = {   /* 1080i */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:230:28: error: 'SiS_Part2CLVX_5' defined but not used [-Werror=unused-const-variable=]
  230 | static const unsigned char SiS_Part2CLVX_5[] = {   /* 750p */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:211:28: error: 'SiS_Part2CLVX_4' defined but not used [-Werror=unused-const-variable=]
  211 | static const unsigned char SiS_Part2CLVX_4[] = {   /* PAL */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:192:28: error: 'SiS_Part2CLVX_3' defined but not used [-Werror=unused-const-variable=]
  192 | static const unsigned char SiS_Part2CLVX_3[] = {  /* NTSC, 525i, 525p */
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:184:28: error: 'SiS_Part2CLVX_2' defined but not used [-Werror=unused-const-variable=]
  184 | static const unsigned char SiS_Part2CLVX_2[] = {
      |                            ^~~~~~~~~~~~~~~
drivers/video/fbdev/sis/init301.c:176:28: error: 'SiS_Part2CLVX_1' defined but not used [-Werror=unused-const-variable=]
  176 | static const unsigned char SiS_Part2CLVX_1[] = {
      |                            ^~~~~~~~~~~~~~~

This started showing up after the definitions were moved into the
source file from the header, which was not flagged by the compiler.
Move the definition into the appropriate #ifdef block that already
exists next to them.

Fixes: 5908986ef348 ("video: fbdev: sis: avoid mismatched prototypes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/init301.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index a8fb41f1a2580..09329072004f4 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -172,7 +172,7 @@ static const unsigned char SiS_HiTVGroup3_2[] = {
 };
 
 /* 301C / 302ELV extended Part2 TV registers (4 tap scaler) */
-
+#ifdef CONFIG_FB_SIS_315
 static const unsigned char SiS_Part2CLVX_1[] = {
     0x00,0x00,
     0x00,0x20,0x00,0x00,0x7F,0x20,0x02,0x7F,0x7D,0x20,0x04,0x7F,0x7D,0x1F,0x06,0x7E,
@@ -245,7 +245,6 @@ static const unsigned char SiS_Part2CLVX_6[] = {   /* 1080i */
     0xFF,0xFF,
 };
 
-#ifdef CONFIG_FB_SIS_315
 /* 661 et al LCD data structure (2.03.00) */
 static const unsigned char SiS_LCDStruct661[] = {
     /* 1024x768 */
-- 
2.43.0



