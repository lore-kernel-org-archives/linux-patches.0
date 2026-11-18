Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057538;
	b=iE4EVT/WHlmbKV7Mjwi8/mL789zP2n0+xzHTdsboj0KbhOyQ0+25m5VCTs/Af/5t0CGP
	 Rx0JKuSAzOFm+LUXy4qZsi0XSmaH+ArXDoT4k2cH5jBcS6RdGwfB/eKJMTH3P4q8XYIK4
	 1POIfkQvE+FiW5Q/VXlKJ/5IzElx8DYubnbz8yGKEjrz0pZmrREhNErDlJ3PdnDoGz+nJ
	 KVeyGWPF4FGSSnBWulMVFC7/Cn+u6YY9bvNmHP2+zTIAwCAvZEGlA5SZ30Le6pKybhhxT
	 opHWCp156+FIj91XfHIjpc7k8yvprMvaRrIyGt+rlRwKqdAfI5s1CFrb8rAXtS6EwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JHBlJPVVqGGP8fBKKNLUNZqyDcIB33wEPnonA4rIp3g=;
	b=taLlOH5Dg8cVRLNIz3e3TvugEiHH+HEC7ZTdtfUpDCm5JAQ1Z/zT8QAouyw5Ebst9ux4
	 /Na5SxqZVMFpRIoeTt9se2G1fDBhql2S4n7DldaBMBR1TxBkrUq/JFD4GzmlSxddYl50Z
	 1zfXZkIcOca/efDxL9tfYNEyu3qLBaMrtaXekhIU3EmHxmRSA/TbWK+DSVumVM/ErpvrA
	 /VZaLXei3cJoY9Q5Q52ub1dtY+fzp6eA9BB3xT/zxY3ZB74tOfAFP4NjydGsKT5a0tiuV
	 9jVYQdjGI2Jax++EPj7o42I3SO3VNqlPx3vPdvf2+Wq0VN0ENA2hHV/+ztsITs5BEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0OF75gp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1A60A2611;
	Thu, 19 Nov 2026 03:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0OF75gp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF101F000C4;
	Thu, 19 Nov 2026 03:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057537;
	bh=JHBlJPVVqGGP8fBKKNLUNZqyDcIB33wEPnonA4rIp3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0OF75gpdgnwwNcDp9xT/Uy7vT6Ij6yvqVg70M0trEjL3lGspjMYzGdn7r4jCxovj
	 q0N+SJmj4Tht7ajJ53EYQJAdoMarHdtn83R/JtjYsaDMeu4i6xru73Krq6W/ZtGFTC
	 /6QAndlXqwm1h9Sa7uEQXTtQolxVbfYrQqAFQZzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0165/1848] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Wed, 18 Nov 2026 15:36:43 +0100
Message-ID: <20261118145918.542623529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit fabae5548149ef5c8a056875d9ebdc38366db539 ]

This is managed by USB core and drivers aren't expected to touch it.

It should only be not NULL on a submitted URB, in which case clearing
defeats the "submitted while active" sanity check in usb_submit_urb()
and may crash the HCD handling the URB and panic the kernel.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://patch.msgid.link/20260810075728.483c827e.michal.pecio@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2yaudio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 205c41d671826..cb86c8e33ee1a 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -165,7 +165,6 @@ static int usx2y_urb_submit(struct snd_usx2y_substream *subs, struct urb *urb, i
 	if (!urb)
 		return -ENODEV;
 	urb->start_frame = frame + NRURBS * nr_of_packs();  // let hcd do rollover sanity checks
-	urb->hcpriv = NULL;
 	urb->dev = subs->usx2y->dev; /* we need to set this at each time */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-- 
2.53.0



