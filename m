Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FDC30BF54;
	Tue, 26 Aug 2025 11:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207982; cv=none; b=ghBSnGFYMpyb/uqpuG7/WHz4KQkY09Xg2P2Y/Ns2SzL3W3EPyRNhlDJr4HbdMB6gEXJj+GcMKBoGRh1rTTFITDO2KcxISp/oikmkLMrxFUNB6iyY42COlKroG9bN/GyGcR5yB3Fho7neSBwYCGaC0xosNbnisO/kAQcJyGg2+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207982; c=relaxed/simple;
	bh=0Sd5SmAjW50i/ai+nKcUZVztwahk9ggsDqqztB+qpG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/upPPP/2/x8Dw2tGxG5kUvWP9uUC+sHJHjiO/crDLBFhT+S8bDDo38J9pz6QUGnjTQW4c/1y+1IEI314MyE96Cs7e/jvf/Io1vZ5hnzoNeFYEcN2SggDh2WcfFIsXBe3u3qcqCHnmui1uIZHP1xiAPJcleKhoPT8lWZDzS+6Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxbjisim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxbjisim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A32C4CEF1;
	Tue, 26 Aug 2025 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207982;
	bh=0Sd5SmAjW50i/ai+nKcUZVztwahk9ggsDqqztB+qpG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxbjisim1g2fjZps9/R53Nio76BBlIwb7+i6NiXN7GTuGFlgF8sxO/pxacCaHj0eI
	 hc/M4PqBLP+UQTo69lIYREE64/Abz58DI2Q+KSj4ZFgguZvtCLcWLc9TD3LfyU26cv
	 ykuzjg/aGe6Gpxgq4PzRPFq6XK2CF5N4sYspWccE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 393/457] ALSA: usb-audio: Fix size validation in convert_chmap_v3()
Date: Tue, 26 Aug 2025 13:11:17 +0200
Message-ID: <20250826110947.007858802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89f0addeee3cb2dc49837599330ed9c4612f05b0 ]

The "p" pointer is void so sizeof(*p) is 1.  The intent was to check
sizeof(*cs_desc), which is 3, instead.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aKL5kftC1qGt6lpv@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1cb52373e70f..db2c9bac00ad 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -349,7 +349,7 @@ snd_pcm_chmap_elem *convert_chmap_v3(struct uac3_cluster_header_descriptor
 		u16 cs_len;
 		u8 cs_type;
 
-		if (len < sizeof(*p))
+		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
 		if (len < cs_len)
-- 
2.50.1



