Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948D13667B;
	Tue, 14 May 2024 10:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682896; cv=none; b=jxm0CviToG7Wa668JRamSHuFd3d7s7lNVbJM+53VbuTyqC6rOdb8tLiN74Hyb3dR45MNWKLw9HFBD/4mRK1IkAR2IH8l3zpMc3wDa6l6yC6pySTaZtTilm0F34FXZoltE12M4Fy/sefgUaKbj83Ek8Fvh/BrJlu4B+/p4lzBLyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682896; c=relaxed/simple;
	bh=a0HPwUdUl3mjhUl66M5powCC1l9m5c8iH3BNj2It4C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blzqFZX9/x4pBJjaZPr37Tg6wHqxJ0pJ5JdJmUSUlD3S3gdesQUvCQ+NQgDw7hp7C/LYQVEbnQq+W9mtWaI/XItlK9myhnudjlNtCtYnpeNlC8+7uAcB/hs6Y03nxVAJgJeTY9r7ZR2iYQ/snqWEXot+PWF9NZorDHq/cFMZ548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZOZP8ct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZOZP8ct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CA2C2BD10;
	Tue, 14 May 2024 10:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682895;
	bh=a0HPwUdUl3mjhUl66M5powCC1l9m5c8iH3BNj2It4C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZOZP8ct9o/bRngMLX8WmecEh6qhGp03zqPOWlwY6K7kWbmsoLcp45ePGmq/soNyw
	 qCh8hyGcd5r/5L65zv6UFgXgjye8mDFsLZHLr+DLCSz/SERT2jDj8HXh/9W4/oyg61
	 AV2PB1mEjDjax3yws49MFie2sdx6AEtxiJSSJ5Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 129/336] ASoC: codecs: ES8326: modify clock table
Date: Tue, 14 May 2024 12:15:33 +0200
Message-ID: <20240514101043.471999764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 4581468d071b64a2e3c2ae333fff82dc0391a306 ]

We got a digital microphone feature issue. And we fixed it by modifying
the clock table. Also, we changed the marco ES8326_CLK_ON declaration

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://msgid.link/r/20240402062043.20608-3-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 22 +++++++++++-----------
 sound/soc/codecs/es8326.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index fd1af97412bdd..a3dbeebaeb0c9 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -326,9 +326,9 @@ static const struct _coeff_div coeff_div_v3[] = {
 	{125, 48000, 6000000, 0x04, 0x04, 0x1F, 0x2D, 0x8A, 0x0A, 0x27, 0x27},
 
 	{128, 8000, 1024000, 0x60, 0x00, 0x05, 0x75, 0x8A, 0x1B, 0x1F, 0x7F},
-	{128, 16000, 2048000, 0x20, 0x00, 0x31, 0x35, 0x8A, 0x1B, 0x1F, 0x3F},
-	{128, 44100, 5644800, 0xE0, 0x00, 0x01, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
-	{128, 48000, 6144000, 0xE0, 0x00, 0x01, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
+	{128, 16000, 2048000, 0x20, 0x00, 0x31, 0x35, 0x08, 0x19, 0x1F, 0x3F},
+	{128, 44100, 5644800, 0xE0, 0x00, 0x01, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
+	{128, 48000, 6144000, 0xE0, 0x00, 0x01, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
 	{144, 8000, 1152000, 0x20, 0x00, 0x03, 0x35, 0x8A, 0x1B, 0x23, 0x47},
 	{144, 16000, 2304000, 0x20, 0x00, 0x11, 0x35, 0x8A, 0x1B, 0x23, 0x47},
 	{192, 8000, 1536000, 0x60, 0x02, 0x0D, 0x75, 0x8A, 0x1B, 0x1F, 0x7F},
@@ -337,10 +337,10 @@ static const struct _coeff_div coeff_div_v3[] = {
 
 	{200, 48000, 9600000, 0x04, 0x04, 0x0F, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
 	{250, 48000, 12000000, 0x04, 0x04, 0x0F, 0x2D, 0xCA, 0x0A, 0x27, 0x27},
-	{256, 8000, 2048000, 0x60, 0x00, 0x31, 0x35, 0x8A, 0x1B, 0x1F, 0x7F},
-	{256, 16000, 4096000, 0x20, 0x00, 0x01, 0x35, 0x8A, 0x1B, 0x1F, 0x3F},
-	{256, 44100, 11289600, 0xE0, 0x00, 0x30, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
-	{256, 48000, 12288000, 0xE0, 0x00, 0x30, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
+	{256, 8000, 2048000, 0x60, 0x00, 0x31, 0x35, 0x08, 0x19, 0x1F, 0x7F},
+	{256, 16000, 4096000, 0x20, 0x00, 0x01, 0x35, 0x08, 0x19, 0x1F, 0x3F},
+	{256, 44100, 11289600, 0xE0, 0x01, 0x01, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
+	{256, 48000, 12288000, 0xE0, 0x01, 0x01, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
 	{288, 8000, 2304000, 0x20, 0x00, 0x01, 0x35, 0x8A, 0x1B, 0x23, 0x47},
 	{384, 8000, 3072000, 0x60, 0x02, 0x05, 0x75, 0x8A, 0x1B, 0x1F, 0x7F},
 	{384, 16000, 6144000, 0x20, 0x02, 0x03, 0x35, 0x8A, 0x1B, 0x1F, 0x3F},
@@ -349,10 +349,10 @@ static const struct _coeff_div coeff_div_v3[] = {
 
 	{400, 48000, 19200000, 0xE4, 0x04, 0x35, 0x6d, 0xCA, 0x0A, 0x1F, 0x1F},
 	{500, 48000, 24000000, 0xF8, 0x04, 0x3F, 0x6D, 0xCA, 0x0A, 0x1F, 0x1F},
-	{512, 8000, 4096000, 0x60, 0x00, 0x01, 0x35, 0x8A, 0x1B, 0x1F, 0x7F},
-	{512, 16000, 8192000, 0x20, 0x00, 0x30, 0x35, 0x8A, 0x1B, 0x1F, 0x3F},
-	{512, 44100, 22579200, 0xE0, 0x00, 0x00, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
-	{512, 48000, 24576000, 0xE0, 0x00, 0x00, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
+	{512, 8000, 4096000, 0x60, 0x00, 0x01, 0x08, 0x19, 0x1B, 0x1F, 0x7F},
+	{512, 16000, 8192000, 0x20, 0x00, 0x30, 0x35, 0x08, 0x19, 0x1F, 0x3F},
+	{512, 44100, 22579200, 0xE0, 0x00, 0x00, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
+	{512, 48000, 24576000, 0xE0, 0x00, 0x00, 0x2D, 0x48, 0x08, 0x1F, 0x1F},
 	{768, 8000, 6144000, 0x60, 0x02, 0x11, 0x35, 0x8A, 0x1B, 0x1F, 0x7F},
 	{768, 16000, 12288000, 0x20, 0x02, 0x01, 0x35, 0x8A, 0x1B, 0x1F, 0x3F},
 	{768, 32000, 24576000, 0xE0, 0x02, 0x30, 0x2D, 0xCA, 0x0A, 0x1F, 0x1F},
diff --git a/sound/soc/codecs/es8326.h b/sound/soc/codecs/es8326.h
index 4234bbb900c45..dfef808673f4a 100644
--- a/sound/soc/codecs/es8326.h
+++ b/sound/soc/codecs/es8326.h
@@ -101,7 +101,7 @@
 #define ES8326_MUTE (3 << 0)
 
 /* ES8326_CLK_CTL */
-#define ES8326_CLK_ON (0x7e << 0)
+#define ES8326_CLK_ON (0x7f << 0)
 #define ES8326_CLK_OFF (0 << 0)
 
 /* ES8326_CLK_INV */
-- 
2.43.0



