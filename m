Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065121;
	b=OG9U41jEr2ZWNLpC+tgQpVRmYTO3d0XBg32ZWoo59RDCgMDQD3UW11iCC4g4FHf3Cweq
	 PYgugDkmxov3QsY6OwCYxDtrL5Dq8Cw8GxBNyvx5XYFKnOQ+f1dELWB1WBKpJzB5iH0up
	 aW0xQxD+zKs6OWoEVf6vimQacQ+r3KnsxQiML5B+HL133gzKbhoJVWQ70TAS4qiafJT2Y
	 BVOMKRa2rUxoly2xrS3c9sdzuUKo9o6SAwNuMCv5BPPLkPdcVesYAoKwgSUqQnRLaO2K8
	 Gui3K4BT+j0lvf8Ti6+WpRofVDdisyOCZxSC2TI/vr4a81B5OqWGWjJ/30kueJ8Tfdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w3EfoysV9d6C7Qo9xV2b4Gsk20uuAjp+R3RA7NOjFpM=;
	b=4XXWY9f3NscENVcCnlbx9OrFlZkhWEAS++QNVhVXWWhl9xgUo2Q+b40+1qdW635DJ1VS
	 r3PQko0a96AKoWya9vLYrm6lqAIJNsM5epPvMpL0FIRjyjMIGLT1G+g4sELSrGiauW3jL
	 9gE+ZW9GIlwfRBrUpmSeLIqi1GmVbVsFAA1rNJgWt3/sDmqHXrJ7sInqtDlFZUtcM8xZq
	 43NVejI1ECPESS9eKa54ESD/K0ZwL/zxFVb+XfpsHxoWS9wNVnC0bqjXeucM1jzRcESVn
	 O2P6CIcuCRC01JKUFJtf2ZckCq9S0ZwHJFO2srjmEadBpk3VguayUWdMyAxUNCEVPZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGQnjRfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C85606A326;
	Sat,  7 Nov 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGQnjRfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A141A1F0089F;
	Sat,  7 Nov 2026 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065120;
	bh=w3EfoysV9d6C7Qo9xV2b4Gsk20uuAjp+R3RA7NOjFpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGQnjRfBybYOqM2x6RZsUbIemW/76kxscFdPS86zFiYbK+E5LoL7HtNM0hE2X33eX
	 tNglCMvhBbR37YZw7cdHan/enENCI8LEWQ3qtP+c57NJ5msRoSEaLkf3+i5z1xGRv1
	 V/kbgbS4HR7S8azCYdQBiPpH46J5gXsYycnOb5fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0945/1257] gpiolib: Free chip resources when allocating the label fails
Date: Sat,  7 Nov 2026 08:54:01 -0500
Message-ID: <20261107135005.447995062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit 8381e1f15e27087fcb6f07046a526ac8b9b9b2b9 ]

If desc_set_label() fails after the chip's request callback succeeds,
gpiod_request_commit() clears GPIOD_FLAG_REQUESTED without calling the
free callback. The caller receives an error and has no GPIO to release,
leaving resources acquired by the request callback held.

Call the chip's free callback, if present, before clearing the requested
bit on label allocation failure. Leave request callback errors on the
existing path to avoid freeing a failed request.

Cc: stable@vger.kernel.org
Fixes: 1f2bcb8c8ccd ("gpio: protect the descriptor label with SRCU")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261018044456.1259250-1-pocj8ur4in@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c0394c7d6279b..239c0d54843b3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2627,10 +2627,13 @@ int gpiod_request_commit(struct gpio_desc *desc, const char *label)
 
 	ret = desc_set_label(desc, label ? : "?");
 	if (ret)
-		goto out_clear_bit;
+		goto out_free_gpio;
 
 	return 0;
 
+out_free_gpio:
+	if (guard.gc->free)
+		guard.gc->free(guard.gc, offset);
 out_clear_bit:
 	clear_bit(GPIOD_FLAG_REQUESTED, &desc->flags);
 	return ret;
-- 
2.53.0



