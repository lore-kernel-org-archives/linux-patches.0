Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591243;
	b=YFi9XdmIB5pm6V7bGQ889icAJmvPo1CEdhas0l3h/YW2nhPG0bU+2eYyBPmzd+5q16r0
	 m4rnAnY8nM3gcSuQ1YnMltEX83VCzNG11ghmP4/3VHZSkKxiU4VVWmNv1boaztsKhHElv
	 lH2vZ+iWfWe4OYzvOkp3UQXF2A3xjQ31O6IsLtt0RjRb+dg024tEqY36D8N7imuKylJWh
	 N5Sg28sMLym9FPHXPLbCuLIPDIoBta6AZzv1hSySgpG8CR/oK6iiNwuKUnT1+0iCFZD9h
	 Itd/gjJeg20ctqGOEcFiEciRpeEDGkuABdqxlwp1iOAaYLHQZU/YO6orfPbl+c0QqlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WFdHgxM94C/M2+3tfAFf8kOJmqd0kAQ+Ber2c+FVjxI=;
	b=oTgXumsf7jT7bsxHQPWpMrhGpLmMu4+3juiwFW57ayARUX95b8run8bnQaTbqVctKGyD
	 3GpMTCP4UxGfEWEOxsAoREXnWlw4vURib3CEkT14EKQ6yrx6FfmAv37Q6/EzPKJUeLK+E
	 RUN+qdWqIZwJx2dEPX5RtNd3nhFjmGwJKatuHC5EOLwGGJSIddUbUA9Ys/KS03F8YnrNl
	 1YV/3RJSvv442jUHuLz31I52DXtC1BFjY7Wy3MUfE8af/EtiRmOBN/O6WYJtJhlPpcoCs
	 oJ0IMCuMH4w4xWEVtOMqKaW/Zyc4cDIlgLFGT0egyu0TItmBISHHXWkBsF0uDLfHY3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4F1MrAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001860A2637;
	Fri, 13 Nov 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4F1MrAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDBF1F000C4;
	Fri, 13 Nov 2026 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591243;
	bh=WFdHgxM94C/M2+3tfAFf8kOJmqd0kAQ+Ber2c+FVjxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4F1MrAW90pLR+t+vHKljB7dCObjU73yYg84wfi+5aO3yswJNsZTph4pgbNzrbRL6
	 BNb1RJ0dXkLMH9Cjk3uugYwzlaCGckE2VIdPVE+/5ZIC4rOOMTW1pwhH7V/z1ErzUj
	 O6kB9RQqiGsuUMGV1KDSqe+ltzg9uK1HTCOVA+P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/670] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Fri, 13 Nov 2026 10:48:53 -0500
Message-ID: <20261113153824.304764984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit d21746bafdb8e1a5fc9bdcb86f603d827a500a62 ]

The three controllers that use the EP4 input URB allocate it before
checking the endpoint type and before registering the input device. On
failure they jump to exit_free_idev, which clears cdev->input_dev but
leaves cdev->ep4_in_urb set. The card teardown then calls
snd_usb_caiaq_input_free(), which returns early because input_dev is
NULL, so the URB is never freed.

Release the URB before dropping the input device on the error path.

Fixes: 6da7a2aa899f ("ALSA: usb/caiaq: Add support for Traktor Kontrol X1")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261104025341.1527407-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index c12eeb9710002..6a5adb8d1e6a7 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -830,6 +830,8 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 	return 0;
 
 exit_free_idev:
+	usb_free_urb(cdev->ep4_in_urb);
+	cdev->ep4_in_urb = NULL;
 	input_free_device(input);
 	cdev->input_dev = NULL;
 	return ret;
-- 
2.53.0



