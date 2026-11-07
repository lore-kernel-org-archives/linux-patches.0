Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062468;
	b=pLsrbXo7o+AHpEM0XVNAuAuBM02oDRcxxlsdKfXt6P6PVSjR0nBiWYzcqTyWiOLpRd9I
	 JVnpRSgg4KETApjE/I6q8VG52wZi4EhVdwtOICrXTaKLcGOFbuwZ/+GmR7W9jT/UIssxG
	 csy6c+kILes2qj5jXYVuMGulCya2NESIEb6VcFs8s7oKE2JciNqKmmyEp5bGPjRjp+sRL
	 H5geuLP+yK+l+GfR5myAs0v+XctWFhwlwwOs9mINXoHJFQ3q6QpvVLcgdiCngr0oQHhaw
	 w//9iVINm4b//5/TL+WM8qmPyxlsEDVZhhj/5y2iWQPlw715uexv5lUhuu7hFl04Ung==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2e5kKl73qkpNwDlEPNmLRPhOtFgwZ3ZzyZZYFdMIQig=;
	b=Hbq+qrtKmeQTLVcar8V79l0Wx0lTq7fomPh3MWZmGunWoc6hGGKFMAM7Bu5eyUkUwRnu
	 WaJSCcpt1f0NC1Y/hAffFI8akxTxFkWkkTtq4xNmjeKQsSLXuS8EKCQ2xkksKJn/bU26O
	 tR1zBmtTnr0q/AvLCe9ESvCJFD3i55gzVNdOCBSwy4o+zIqXjJYe4SpheOp7JNPiKcEb1
	 ob1qYKeNkgUZXCcxPxPn+rs3rcWnukyrzh9h5w9ndehuHILYTkTDCqEngHmnT3UBx1tfd
	 FWXjhReDZz/kyuda4sfpu6YZ3ZdGDGwhiyFKsLVLoLo+ArAKcwduL5VqegPj9hscVvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NCqeq/r7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2B1606A66F;
	Sat,  7 Nov 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NCqeq/r7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1881F0089F;
	Sat,  7 Nov 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062468;
	bh=2e5kKl73qkpNwDlEPNmLRPhOtFgwZ3ZzyZZYFdMIQig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCqeq/r7Z2yHLDf49AHreQDpACSH5h0rie82xaVRW6MPEHQr0UFlXaNwLDgxEGChO
	 xRkxmhHCq0RLx8QJlhtc+incdixlmFvpnHnvjhi2aXMM9+Cte5VRpuWcxFwcvGGVmM
	 Ca6BrFqUlPQn0kfvdqymCtZsnu/NTOh+p4XVE5go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1373/1536] gpiolib: Free chip resources when allocating the label fails
Date: Sat,  7 Nov 2026 08:56:29 -0500
Message-ID: <20261107135036.402881913@linuxfoundation.org>
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
index bffdaa91d86c5..115bf569dbdd0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2350,10 +2350,13 @@ static int gpiod_request_commit(struct gpio_desc *desc, const char *label)
 
 	ret = desc_set_label(desc, label ? : "?");
 	if (ret)
-		goto out_clear_bit;
+		goto out_free_gpio;
 
 	return 0;
 
+out_free_gpio:
+	if (guard.gc->free)
+		guard.gc->free(guard.gc, offset);
 out_clear_bit:
 	clear_bit(FLAG_REQUESTED, &desc->flags);
 	return ret;
-- 
2.53.0



