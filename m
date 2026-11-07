Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062465;
	b=nMok9ssRdVgahs0QpW4+WdAx2aXRGSBuyVEplbgLr0OutiSg8T2fSxAfVTtn6xPfbPF3
	 v0ER3OUq/HU5ocjm6zBT9Q13K6uY8pTixgWD6fOfisYpw9oZp7Z0pESzlVt26d8Hq0D90
	 btA7WmEuK14mMwEek1l0ez0pHughgmEILsQkkH8cz3BI4hR3iHdJIf/Ycr3fml3p/TW3u
	 ThodmvmZKVfsTD2u52it/Ut6nXoQBU/H0exXH/6XLJuYwRR65eWBYBMNQ/wmYvv5cSylI
	 cek95B5Gm/qkMkpYqH/4pg5IGwTp1T1L6jaZguYR4g30tg8808FNJkKYTH/poxqnKBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4caDlYDITfCoQht46zQpldLyI6sm2GH6/9v7Yujp4o=;
	b=TwXy9Y4z8HvHRGzNdfQPqfNyLvgJv1CEkaQEOPScvgUXt3xC7D+2iCp6PCTpPagBEStc
	 yeaXPrDjFPYJ5HGr75xGcLDkcD0uY2RRQMs+8OKWb+cM0jNM3H99zOcQbQPaypslfEBoh
	 kIQ9tNXLioEhy1nlbivvDksaibTa4Fv8ACr63zCWSCBzMDqpCvESEOwdH3QI39U3VPZKG
	 w5oCcc2HFm594YGQ+7AarGf/MrVNA48pxT1lXQ+kTPIP/2pLMfcz+xHeSAYkEiRX3HlXR
	 ChkFTFbWOKO3aAu40YQEdXb+z416c3dwvtutT85TaOhd8Grplqh7cD3O84gwbfPJrOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIn+8UXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A483E606A661;
	Sat,  7 Nov 2026 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIn+8UXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDA61F0089F;
	Sat,  7 Nov 2026 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062465;
	bh=s4caDlYDITfCoQht46zQpldLyI6sm2GH6/9v7Yujp4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIn+8UXt7uytc7WgYozP7e5MRGjPXpRjD/DLgiNgoiV9PJAGyEsoR1EIzTdYJT/iP
	 nwexUsbdmUO5KBW2cHMRPDiSJsUUzVjm+SI5GgT5JsAmn7pPDkdJ8Fbt4bSk8rbOPu
	 75bSpblV5ZNmhduM5yDvHAi3z+lQcUCGjoFv0UJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1371/1536] ALSA: compress: add missing OPEN-state gate to SET_METADATA
Date: Sat,  7 Nov 2026 08:56:27 -0500
Message-ID: <20261107135036.348393534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0436ed1b1284f..ae8ab99f53f86 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -672,6 +672,9 @@ snd_compr_set_metadata(struct snd_compr_stream *stream, unsigned long arg)
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



