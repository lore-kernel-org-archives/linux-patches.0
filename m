Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053424;
	b=cYnxjA4Jv2DxBuR2jAF8txNLrLAlrYF21zasN/J0WZs6BZNwns67nW/MuwsUMR9rFzEw
	 lIYd01pgH6PZInVBR0E0/t+vS9aPd40BeBspubxV2bm+WaOIjBIHTWsU0uQzxRqiCwH3A
	 Mzsf5dj6VNY7h9eUP//mfvoKlds0TV1aN5Lsr2F3NtvdecYeBd+3X/YJ2X/1DriQ1I/d3
	 /1tU0eQdN1qk54Poq8lGn9tkZIGHOCc7ycUFe3ngG5FZMJWcepzYqpEc4yNVSq9rpSHtr
	 X/082KeUwF99UMLJn8ocGBWOLehfhmQBnUEN43XbJ2jLmHTIlG6sDmyPg0O8xYp1OXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5MuBfjx4gyPc3UJe6G9ZWHbc8NNgBE/lfTUHHlGLLK8=;
	b=oAl9ppaK9UIdc/StEoRcY+H6/Qo80GUudQh6e40tkcpz3c+1PA84FniZsS5pehL8lASa
	 Vx8BkOpqSIqLh2EqJLf4vu/f00FL69x7B1dy7qFYTAMDRs6lek7AOVaMtKGfgqWrBuGAF
	 ZSdPdQiRMDoFWEHNrGE02ePjwMlXm4LP2sfkK7He9OXJJQ8kYoNLp6FvKY7EFmGS5ozwi
	 GF3wf5spXrzwoRYKops2bkw4Ks4UtF05n19Zpuc/PVAbsN91zkxEx5QS1pNe3/yhGqpzU
	 BUPaf0Q4r4Gy+yY0jyE9B3ZD69MWPynw6xfXog4QLyTbmddzv7Gc1wJ8oma3MdF4MhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b49dWbUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F30606A325;
	Thu, 19 Nov 2026 01:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b49dWbUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905D31F000C4;
	Thu, 19 Nov 2026 01:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053424;
	bh=5MuBfjx4gyPc3UJe6G9ZWHbc8NNgBE/lfTUHHlGLLK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b49dWbUogSd9Q40y257doAAqP2HNe9250op5o+XVpbAJgBLZdJmTWsuzseQs0GgSK
	 V8nOZQm3jztsVv+is9YJTTs/hlCrlsBPzRmtGwZeg3A2/35cCt+czuEfdytPdrPjEd
	 9gamg8e6Lm0mRhmm8AIPW6wqNHjNJoh3+5ctKWys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0915/2214] ALSA: caiaq: free the EP4 URB when input setup fails
Date: Wed, 18 Nov 2026 15:43:11 +0100
Message-ID: <20261118150048.955040143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



