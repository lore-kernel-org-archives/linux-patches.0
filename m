Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65D350843;
	Tue, 26 Aug 2025 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218974; cv=none; b=XF4CZbVUzkZbwsaT66Kliv0xorZEZ3uc+3YKHtGwIyXCZwh44FZKZEfOTLibkwTLvh2ApiHW9njFtqSKsB7wKpu7cZEvMVuwufns5I++NlNU4B/lJSRDYBwFijyyRi1/vmrvl+dDWx8loaHld1o54G+oHLd/eZNYzbzzwQLNDP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218974; c=relaxed/simple;
	bh=AW74IdItf0v2KgngWRAMlDN1Ut4q8cZWI7ba+WCxa7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjXxMyKzThz9o8utoHLj7BYs5bUifHXT/olzDHB5rHSQvA4l5cxisZVi9V9iHQfZDGLRkUpzi58kJt3HKCA841A0z+wjoetI+X481sQsQf+AHGq6qeWPNSalrc3YABDpZYtOXtyi8r5ofn+WGFQicFVcvsOJ69Sahs2Qc54bC40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epTDaO0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epTDaO0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4B5C4CEF1;
	Tue, 26 Aug 2025 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218974;
	bh=AW74IdItf0v2KgngWRAMlDN1Ut4q8cZWI7ba+WCxa7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epTDaO0BouQ/z7i/r6BicyhiBTWAHbVx+C3ktZddxwAU5d1zIwTaaZIcM59TB/ae2
	 P+UcDSVj61r7byqwcAC0tWCDDe2tOuJ36FVqFU2jyL8QDJ0IEJjacZQ0b7gpueC+BS
	 vGhPAfgQmjQNluv1Nfj141sXVm5u7Vds9gugggR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/403] ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros
Date: Tue, 26 Aug 2025 13:08:50 +0200
Message-ID: <20250826110912.488152364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit fd3ab72e42e9871a9902b945a2bf8bb87b49c718 ]

Fix all macro related issues identified by checkpatch.pl:

  CHECK: Macro argument 'x' may be better as '(x)' to avoid precedence issues

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-3-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index e752b6bb03ec..04267d4e3ecf 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1990,15 +1990,15 @@ static int dell_dock_mixer_init(struct usb_mixer_interface *mixer)
 #define SND_RME_CLK_FREQMUL_SHIFT		18
 #define SND_RME_CLK_FREQMUL_MASK		0x7
 #define SND_RME_CLK_SYSTEM(x) \
-	((x >> SND_RME_CLK_SYSTEM_SHIFT) & SND_RME_CLK_SYSTEM_MASK)
+	(((x) >> SND_RME_CLK_SYSTEM_SHIFT) & SND_RME_CLK_SYSTEM_MASK)
 #define SND_RME_CLK_AES(x) \
-	((x >> SND_RME_CLK_AES_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+	(((x) >> SND_RME_CLK_AES_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
 #define SND_RME_CLK_SPDIF(x) \
-	((x >> SND_RME_CLK_SPDIF_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
+	(((x) >> SND_RME_CLK_SPDIF_SHIFT) & SND_RME_CLK_AES_SPDIF_MASK)
 #define SND_RME_CLK_SYNC(x) \
-	((x >> SND_RME_CLK_SYNC_SHIFT) & SND_RME_CLK_SYNC_MASK)
+	(((x) >> SND_RME_CLK_SYNC_SHIFT) & SND_RME_CLK_SYNC_MASK)
 #define SND_RME_CLK_FREQMUL(x) \
-	((x >> SND_RME_CLK_FREQMUL_SHIFT) & SND_RME_CLK_FREQMUL_MASK)
+	(((x) >> SND_RME_CLK_FREQMUL_SHIFT) & SND_RME_CLK_FREQMUL_MASK)
 #define SND_RME_CLK_AES_LOCK			0x1
 #define SND_RME_CLK_AES_SYNC			0x4
 #define SND_RME_CLK_SPDIF_LOCK			0x2
@@ -2007,9 +2007,9 @@ static int dell_dock_mixer_init(struct usb_mixer_interface *mixer)
 #define SND_RME_SPDIF_FORMAT_SHIFT		5
 #define SND_RME_BINARY_MASK			0x1
 #define SND_RME_SPDIF_IF(x) \
-	((x >> SND_RME_SPDIF_IF_SHIFT) & SND_RME_BINARY_MASK)
+	(((x) >> SND_RME_SPDIF_IF_SHIFT) & SND_RME_BINARY_MASK)
 #define SND_RME_SPDIF_FORMAT(x) \
-	((x >> SND_RME_SPDIF_FORMAT_SHIFT) & SND_RME_BINARY_MASK)
+	(((x) >> SND_RME_SPDIF_FORMAT_SHIFT) & SND_RME_BINARY_MASK)
 
 static const u32 snd_rme_rate_table[] = {
 	32000, 44100, 48000, 50000,
-- 
2.39.5



