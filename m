Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043978;
	b=gX7jwWDDzl9ErmIwSeXR9vl1dhnICePdN8lYscBYnZMqwbXYoPyXHlD2qJQur14xmdns
	 A4XjuzoEcwnipL7AgR4jRQZ6ghl1TX7ONHiZEVkfuuSXoSf6L/GD5Hcczl4rbISZvLcwW
	 lH0plyH+TBiy2bKG+szbmDiP//YF44XMleO52rpzm1mmO9vYfiHWRFBFn5bba+6Cl27Y1
	 bjgWTHH0jwww8qlylovd2Sy+BdSRsOr2FWjnxzW26sKUp6RtQvwRGR1izF++VUWYKuR74
	 MWe86tb1xc9Ca/D82BnMahqts8V/jhFDUitl3mXcXy/GO4futC5kQAjVs1ziaThKd0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jQv/NvOsF60d4VLneFcE3LAPKG0l32Q7Pdfmk6SXmg=;
	b=Vm1xXbyzotvZE7p3uwXZlL3lFoMymxLE+kkm8sbiDOD49cDaeLYIRx8FlmdUoJF01K0v
	 vSClfI+vRq/08VlxpYHMPktfasSA3YF0XMMEaR5xNXVV7OGa9UU5hvF+WEDtyIzQncEkO
	 Mhv8eKfv1Ln4w73RCs7YYMBUVwcS5BE2s95itRzQZdiHMqYxLNkJF6BtH+L9hXsvP38HD
	 MH8A44bxTRjOWY226COEBNFhPoswG7HHUpQ6w3JmrFqAwcfQiwsvOfdyD6dytvQC2c392
	 c0e8GHag5MrjOdW02rCg0h9M51RhtfDGki4CkthHUSkLFneOUWtJ82Edb1uXEnKeuKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGQ9K0mW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7696606A325;
	Wed, 18 Nov 2026 23:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGQ9K0mW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C291F000C4;
	Wed, 18 Nov 2026 23:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043977;
	bh=6jQv/NvOsF60d4VLneFcE3LAPKG0l32Q7Pdfmk6SXmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGQ9K0mWCjHtA36DnCJ+0Z/57LCoY+neEBrCKYSj9edocV0ggPgI4Qd3Byd2nV9IA
	 gRdOednnKw0YrQ2as0GTaxCP0JEzL7DUYhWCnxiBLx6pZRrCO4MY9FiQ5WyDTTMk83
	 EC5dPPemGoEOYcuuBPgRdIVmTGofo8dk9XXz2uqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0402/2857] ALSA: usbusx2y: validate URB actual_length in interrupt callback
Date: Wed, 18 Nov 2026 15:23:56 +0100
Message-ID: <20261118150215.863119929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 8f5ef203abda9dd36b2af473c7b737d544f807bd ]

i_usx2y_in04_int() processes the interrupt URB data without checking
urb->actual_length.  A short transfer from a malfunctioning device
would cause the handler to process uninitialized heap data from the
kmalloc-allocated in04_buf, which is then copied to the mmap-accessible
ctl_snapshot[] array.

Fix by using kzalloc() for in04_buf to zero-initialize the buffer,
and adding an actual_length check to skip processing on short
transfers while still resubmitting the URB.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260904205826.4071119-2-tristmd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Adjusted context around the new length check because this tree still has a commented-out printk line that upstream had already removed. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index f6ab927490b4b..10d2575f8149d 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -190,6 +190,10 @@ static void i_usx2y_in04_int(struct urb *urb)
 	}
 
 	//	printk("%i:0x%02X ", 8, (int)((unsigned char*)usx2y->in04_buf)[8]); Master volume shows 0 here if fader is at max during boot ?!?
+
+	if (urb->actual_length < USX2Y_IN04_SIZE)
+		goto resubmit;
+
 	if (us428ctls) {
 		diff = -1;
 		if (us428ctls->ctl_snapshot_last == -2) {
@@ -254,6 +258,7 @@ static void i_usx2y_in04_int(struct urb *urb)
 	if (err)
 		snd_printk(KERN_ERR "in04_int() usb_submit_urb err=%i\n", err);
 
+resubmit:
 	urb->dev = usx2y->dev;
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
@@ -306,7 +311,7 @@ int usx2y_in04_init(struct usx2ydev *usx2y)
 		goto error;
 	}
 
-	usx2y->in04_buf = kmalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
+	usx2y->in04_buf = kzalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
 	if (!usx2y->in04_buf) {
 		err = -ENOMEM;
 		goto error;
-- 
2.53.0



