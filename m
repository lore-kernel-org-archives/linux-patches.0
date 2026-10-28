Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212783;
	b=TH6jDH28XSpmiQWOxs4zNL83bn4IrboLx4ULeM52mSGmTHRSOtA5k5KuXNJEtQ/SgeMO
	 Qa7UjqudJW1ez6EV/AUAjbyTnxVeuGp4Gt4J+gRzJ4ZNDy+0CBOJ6N2fFNEM9gupaIGv/
	 vCecXjsZ/55nU3LGSHFhkGfuncWydryEqJRIAbImKoWGHOffVjztJi4dar6uOBhdHShpy
	 NHTvl5G8ZsyGZp36aUzcg6NmKZpdO4nQH9ChNJ2H6Hee0jz7Zw7wij6xsggchuj9/C2bT
	 Dt0kNciHPGVORWH7Q3JZv99ml0amXPL6gyg5lcJNMFt/65bCfb8XMQWCVCmpCgz9h5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kAWYexN7zXt9+NhMvmNt2spqSoG9IS+kVqcsS0+9a9U=;
	b=BiQnKzvg4NoLsslownikFjIl3AuWC+KueHW9l5UjXDcOz+0IA9aMh9vqM2bG3Aorg5Td
	 +EIlF8/uDnxgpxH7PyfXuI9rRFml0MBF7LLN3z2xu1tPbfWN5OAhFf2BR1VwnSc1jNSVM
	 s2R9ateLfTHK9Mm2wJ9RHVDzXS79AofopQn5+wlskN5/rcIaC6I2DKj1k/1dtUkdNoqDm
	 DUO68f43oa97o0c/NHmTk1KVfy6QN6FS1B7Y/gm0KTjvCn8FycYImuoHggS+aL5jXJHOb
	 MTt5Lyiy1tf3oabxy36kaydyq39pmXWPPE3GbJjFf6wXMP0pM2beo7I2kidg/h61uAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnlE5ncc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDE606A31C;
	Wed, 28 Oct 2026 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnlE5ncc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF551F01825;
	Wed, 28 Oct 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212783;
	bh=kAWYexN7zXt9+NhMvmNt2spqSoG9IS+kVqcsS0+9a9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnlE5ncc61StuAveply6d2uX+nF8dHdulXSqumj6tJ/RgqA+iR5N0UDLj6yRenty4
	 cObYMc/yez2NKqK3v21baioOx9zh4EYGG1fSGfdIbNjG5QBsuu0Iji0baplRxR32mk
	 OCbw17xrzs03QgiRcseVHt4BBfBQbzb57TXZpr1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Liu Chao <liuc63@xiaopeng.com>,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH 6.1 0275/1887] usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd
Date: Wed, 28 Oct 2026 17:39:31 +0100
Message-ID: <20261028170505.488162450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


