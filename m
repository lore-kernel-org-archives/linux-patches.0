Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058604;
	b=xVCCbReu1OBu/xmcoX9Ze5K3GJIfSbfiAjoeQrvKJMLhuIQN3E6DKcQZ2oAWmDFccDlu
	 F3SUQqHmyWvATS39R0NeXdft69eobCJkjg71cFj3CXYRSFapv//VXeo52NVTliW/vkFgI
	 4TCqYQWQa0xwKju8gNmc15u9ZAsyBaNwJQyk2OJl724lV+YroUQOqdVS7tD/gVbLKQwUp
	 y43bHTgxoB71TAY7yfBLKUiORxq8ADgICMUsMBgs0IyyxfDCyMInTHyVpPHJUy9lRebDG
	 z51LyPpFPX+gl0mSF2B7pzlVbCs673OJjMkZtUcj2ivLF2gA57BmsdN8Nde6fIS8XqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Lsn37DMEhm9NiG7FF+3iAe+784/8xcYiCp2ZaIflQw=;
	b=wmMgeZAl/GAeOr/jo6Uf3sib5U4sXnN8okbvT/4xlOQxk7Mv3/R+nubxvEdsxsjFPpxq
	 XL0HJ9FC+Spu33PH6l205tunuWvXeLajC0zqVY0FBXPeN612zT6vGlVsB7TZB8JV8ZMZ7
	 YvXmlv0ZpypLpVz6Jf1jA3T2x17qPgxX/0+qJNgbFQRuSFHuj0ryIV4GYv/5a5gKXoYUR
	 Id/tavLmn+blXaM4tOigfDdfXKJg+X9XakxNpe1A/TJTFn2Mc80fZI0ZJB3zeH9DvIp1Y
	 GeyW3LOCmwJ5cxb05N42L85JiCOJUFJas33v/LngzjkYlw/EyIorYUy9BbiQnHmgYwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCA2Pz7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98249606A32C;
	Thu, 19 Nov 2026 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCA2Pz7U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97CC1F000C4;
	Thu, 19 Nov 2026 03:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058604;
	bh=+Lsn37DMEhm9NiG7FF+3iAe+784/8xcYiCp2ZaIflQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCA2Pz7UIHZPE7dhufgxncQ6mP9JET3PJfOZzRHpH26fmfOz6KiveXkKv0f9Hl/nu
	 uVrDETcuDG/fyizlpAh5zUu5RESlc3a/kkxeawEG1bluoZELWOv1b7+lkDpaqBvnlH
	 jUBEHVetW66ue0hVz38zYxmK7CnGVyfmtcyC3+qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0546/1848] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118145937.826203984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 931f5714b7921290cd1a4742e185aeeae7270ee6 ]

snd_compr_set_metadata() calls stream->ops->set_metadata() straight
after copy_from_user(), without ever checking runtime->state, even
though the function's own comment says a parameter change should only
be allowed once the stream has left the OPEN state. Every other
metadata/param entry point in this file (SET_PARAMS, WRITE, ...)
enforces that gate.

A codec driver's set_metadata callback can assume SET_PARAMS has
already run and initialised its private state; calling it while the
stream is still OPEN can operate on that uninitialised state.

Add the OPEN-state check the existing comment already documents.

Fixes: 9727b490e543 ("ALSA: compress: add support for gapless playback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20261019144533.30665-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 222ea652edf37..d43bfe5623e99 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -674,6 +674,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
 	* we should allow parameter change only when stream has been
 	* opened not in other cases
 	*/
+	if (stream->runtime->state == SNDRV_PCM_STATE_OPEN)
+		return -EBADFD;
+
 	if (copy_from_user(&metadata, (void __user *)arg, sizeof(metadata)))
 		return -EFAULT;
 
-- 
2.53.0



