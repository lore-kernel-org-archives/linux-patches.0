Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620678;
	b=Kr1ZkkqF2m9Gc2GX5FmgNQ7cmBFgeo9HuWcz+1Z/B1lf4R3wh20L7jyKpDbs+Tt+Ia2R
	 FE2kgSPpBmEukKVCBC7Ykwj9L0LwvYjW830tDJPIsYx7WX+qS8eGIxrHu5wlFQnArXDoV
	 eFWt9IKefZpsiym65Tw55cy/azqeAHV+np+dMRtiQjitrXIkVMFtLwjhY49VQRPGOee8h
	 tRCdjoGbUu9vxiUyS9mNUNrnaoGmeIqPzDoETa6AcZSuE44w5ApII6uTiDyJ5E8/ZuWFH
	 6pkTqCyU35uOY6f9dhG84iV0D/pswl1A1wg38O7a9anEKpA1Ca32NHPwdGEDFIb/rxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+4zUlId3CxOISWweUDhH0a8hZc3diaxJzg1iVVuHIvs=;
	b=s7jhLL563ar66rCHzr9xlzuyshXAK5ggXRpKcJGSc2C4tumdF1m7X5BEr3l/ZdDjuRpV
	 IDBExoUK4aJB/x4cK1hatU/62l77zL3HcaBDoxJXNrq5ZMkP7hI73xrv6c7SdlllITJKb
	 wI3rmxeKKZhbyw9rwwKbUtTUBLUaFGa2nY8YR6jMa1udoE7kNX7GZ3GfPNSEwzgma+LGf
	 5hN3+76P/bqSD24IBYrJWB95jQxE94lade/daUnnUD76uaxwiAT0A5XkGCFDvz98R4PQB
	 lCH4Odot+5QV4cTsp6YzDYlcw43+9pX+nQ9gxcqWh/vD90L0bQ3bH2NlmGLQpfE62iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZR8zH9UW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA01606A321;
	Wed, 25 Nov 2026 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZR8zH9UW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE321F000D2;
	Wed, 25 Nov 2026 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620678;
	bh=+4zUlId3CxOISWweUDhH0a8hZc3diaxJzg1iVVuHIvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR8zH9UWBIj2tzanypu5iGCJ+ACu6+VpftNJboznhydd7lLCnRjghJQ+kb6ak/YPu
	 OXT68ofcZ5siKuvrvttoBe1WW8N46UwN+NVc7Cn4bwKcb4dndjyvPaK6KB63L1wFtb
	 a/iR2K3lFpJyhJe1kEbotF2rufdhbMPeCmOJ6D9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunjung Ko <hj351016@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0998/1005] gpio: mpsse: reject bulk-in endpoints smaller than 3 bytes
Date: Wed, 25 Nov 2026 15:38:56 +0100
Message-ID: <20261125143845.031884589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Hyunjung Ko <hj351016@gmail.com>

commit f94f85f82e042c89a1e64ed3ff1d591a2bccfa7b upstream.

mpsse_read() reads min(len + 2, wMaxPacketSize) bytes and then copies
len_actual - 2 bytes to the caller. A device that declares a bulk-in
endpoint with wMaxPacketSize 1 completes the read with len_actual 1, so
the copy length becomes -1 and memcpy() runs far past the one byte
buffer on the caller's stack and past bulk_in_buf:

  memcpy: detected buffer overflow: 18446744073709551615 byte write of buffer size 1
  WARNING: lib/string_helpers.c:1036 at __fortify_report+0x6e/0xc0
  Call Trace:
   __fortify_panic+0xd/0x10
   gpio_mpsse_get_multiple+0x767/0x780
   gpio_mpsse_gpio_get+0xa2/0xf0
   gpiod_get_raw_value_commit+0xf8/0x1f0
   gpiod_get_value_cansleep+0x1e/0xa0
   value_show+0x42/0x90

Reproduced with dummy_hcd and raw-gadget. A read needs room for the two
status bytes plus at least one data byte, so refuse to bind otherwise.

Fixes: c46a74ff05c0 ("gpio: add support for FTDI's MPSSE as GPIO")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
Link: https://patch.msgid.link/20261117104110.240112-1-hj351016@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpsse.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpio/gpio-mpsse.c
+++ b/drivers/gpio/gpio-mpsse.c
@@ -676,6 +676,10 @@ static int gpio_mpsse_probe(struct usb_i
 	if (err)
 		return err;
 
+	/* Every read carries two status bytes ahead of the data */
+	if (usb_endpoint_maxp(priv->bulk_in) < 3)
+		return -EINVAL;
+
 	priv->bulk_in_buf = devm_kmalloc(dev, usb_endpoint_maxp(priv->bulk_in),
 					 GFP_KERNEL);
 	if (!priv->bulk_in_buf)


