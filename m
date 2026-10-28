Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208776;
	b=ccOoaiNNZ6116FWaTh0SwW6IqnzyHY/H1+ur2cNvoPYqqtad8pcd+mpreeCpBNRaVORn
	 Jxv6YVnIs0anH/4C/Ocq0X3wMLPwLH5i9r4CvNRFR+PiP+BSrMgEDeavKMQ0g50Y89qSi
	 BSYsmwkZU8++swv6zKGKbHUeekUJbZVRMKg2JSKXxBGemHaXJbswttVZ0V6Vf6kb/cmAc
	 DQhZenU/FPL4EuGuMIyMiKBwPCdT6iR2GKzsIFnkF6eeWxPhcEetBSISnvFMSqYXFmOG6
	 NZJTv3bVpF3O0RmEev+duap8wtuSMckmHJCV/U9t6ZlBKLJxN9KEHih82a6+baBeTMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4fCHV5yXn+3QrW/APZ+JpmL7UD23BhefS/nvPOyiKo=;
	b=cy2roBHl8EohZduuFA801zeIVeRRLp/aBD9CMIq6gK0y0/4Xmqgf/fkaO2Rl2Z6EhHDZ
	 9cWnESehckxWVE/J3IEm3QEmVQqsDYyY+DScRi0gR4SqIB4D6bblDpu8SPg+fSdGJTE8x
	 ggXZWDhkkKZHyyANCuDWnN9aOtKBLPHt2btcevF/5dKewWsw3kgwPR0uOVnriDNuaSjNA
	 WHs64e/Sd2iA6z2VvG+GSKWD0aiirW390D7h6nVXmSqdDVzFGQDL0RJvp4O+iPcjy5nDF
	 yUfSR4DvLoIBaJkYEG6D6IJhfL/gycsjjc11p3hs/OABEoLnFvjcbLiQFjJoUbhiAMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCQiLCzY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C3B606A31A;
	Wed, 28 Oct 2026 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCQiLCzY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539881F01825;
	Wed, 28 Oct 2026 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208775;
	bh=P4fCHV5yXn+3QrW/APZ+JpmL7UD23BhefS/nvPOyiKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCQiLCzYxloq95iklHLdmc9LNrOgViKcsxzpAOjtrjwRdB4qB3nez7HP65wp8H1qi
	 X/3lgu110dVNuv8PoXTsE/+fJQI3OeVtCDv7NtJBX8yLRXhM6fvyydyhcx94PWppoi
	 SEEJzzQEoWV+ztoPpUitP2+2CU+FYXP+QMKyL4y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH 5.10 194/516] usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd
Date: Wed, 28 Oct 2026 17:55:46 +0100
Message-ID: <20261028170008.098511448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Liu Chao <liuc63@xiaopeng.com>

commit 9062d50e75c24dc7911be05c9b1719b3b256af15 upstream.

generic_set_cmd() and generic_get_cmd() use the low nibble of
ctrl->bRequest as an index into con->data[]:

    u8 cmd = (ctrl->bRequest & 0x0F);  /* 0 .. 15 */
    ...
    con->data[cmd] = value;            /* OOB when cmd >= 5 */

struct usb_audio_control (include/linux/usb/audio.h) declares data as
a 5-element array, so indices 5 through 15 write (or read) up to 44
bytes past the end of the array on the heap.

A malicious USB host can craft a class-specific SET_CUR / GET_CUR
request with an arbitrary bRequest value, triggering the out-of-bounds
access from an IRQ completion handler with no further preconditions.

Add an ARRAY_SIZE() guard to both functions.

Fixes: c47d7b09891a ("USB: audio: add USB audio class definitions")
Cc: stable <stable@kernel.org>
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Liu Chao <liuc63@xiaopeng.com>
Reviewed-by: Ivy Lopez <skunkolee@gmail.com>
Link: https://patch.msgid.link/20260921072551.3708191-1-liuc63@xiaopeng.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac1_legacy.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -797,6 +797,9 @@ fail:
 
 static int generic_set_cmd(struct usb_audio_control *con, u8 cmd, int value)
 {
+	if (cmd >= ARRAY_SIZE(con->data))
+		return -EINVAL;
+
 	con->data[cmd] = value;
 
 	return 0;
@@ -804,6 +807,9 @@ static int generic_set_cmd(struct usb_au
 
 static int generic_get_cmd(struct usb_audio_control *con, u8 cmd)
 {
+	if (cmd >= ARRAY_SIZE(con->data))
+		return -EINVAL;
+
 	return con->data[cmd];
 }
 


