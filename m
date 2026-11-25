Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623575;
	b=wekUWEcneZJye15pvKKG4otqlxvVZUNthrjyvQ+ZR51jEaecUTeb7nWBjjPgqH1+E/En
	 1X62+kj3KPySEkMBpOM5l2ANMOLzRYoQoeRzVbSDqJcqBiRzZRSC/b2KrjpH4ShnB2ajv
	 SXcAI+TGRMEGq07cd/vYaKFHAwq8IeM1UnLYnVx5qFPPKoBh1R9jnIaSP5ZoB1sUmqYHL
	 Pr4PLSP7GDgxbl+caDqqwf9aAmBw3utyMsMhMjKRQmML8wzojVt0UyslxThIQe1f9xlMa
	 BG4o/hODB+L/zgN+d9hd73A41D59W2nuZv+c9RNiB8YsFjUdk1zRZJKSCkNGPZsHUAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BGk6iLLckczejv90qG6Fqj8L9Dj9r4/6Kw5l5HIDLiA=;
	b=ifPPP05er2PKOiUm3b1ECJsc9inAlcQ6bjkv720UoazO4IGPMDSZG2SNm4MidWebEOhH
	 FjM1shhQXUwzlz6q32wk8vBbI6bYn+tPKi/83+4ZXpgTGFEI2+nSnix20h24Igox46vB1
	 pA/naECiguXcyc9OIMhYXYeVaEEMz8bdItfnG3D2GZcQ/GZ6QggozOh6ueXSqdU5lHncN
	 hUD1sSsfrSL2LQgM1ecKuXmNAl5KrsHjkn13t2pTWPckeYW55RXj0SZTUZGYbo8M4y+E3
	 jhGVkivU92kPV69eZSjbndMvrk8FI5KlPnVNCnGpiHnqN4nwn6R5QTlg5i4cbBIj8GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8lEIVbs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9DD606A31E;
	Wed, 25 Nov 2026 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8lEIVbs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F331E1F000CA;
	Wed, 25 Nov 2026 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623574;
	bh=BGk6iLLckczejv90qG6Fqj8L9Dj9r4/6Kw5l5HIDLiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8lEIVbsYE8dku1ZBhUWM7JSr6hd1slFzG8vARClze3hYCeijXEo6HQMc9cmrVyoH
	 T0Ujs32b1U4R756UPUgd7qMh9+0ruUZonPXRs1RzUmyhVRnDx9l2MvDvnscEGKSD0Q
	 bCrKABhXCjyarXpC3lMhtEfaLj9eQfA2TdJldiqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 904/990] usb: typec: mux: fsa4480: Keep the USB 2.0 switch on in DP-only modes
Date: Wed, 25 Nov 2026 15:37:51 +0100
Message-ID: <20261125143843.183971066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonhoe Kim <26rote@gmail.com>

commit 89aaaa26f6985d55676fc5c90440f279733fa132 upstream.

DisplayPort pin assignments C and E give all four SuperSpeed lanes to
DisplayPort, but the USB 2.0 D+/D- pair is not part of the pin
assignment and stays available. The FSA4480 sits on that pair, and in
these modes the driver turns its USB switch off, so a USB 2.0 hub or
device behind a DisplayPort sink is disconnected as soon as the
DisplayPort mode is set.

Configure the USB switch the same way in all DisplayPort modes.

Fixes: c7054c31c1c9 ("usb: typec: fsa4480: rework mux & switch setup to handle more states")
Cc: stable <stable@kernel.org>
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20261022165143.1327-1-26rote@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/fsa4480.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/usb/typec/mux/fsa4480.c
+++ b/drivers/usb/typec/mux/fsa4480.c
@@ -93,16 +93,9 @@ static int fsa4480_set(struct fsa4480 *f
 		sel = FSA4480_SEL_USB;
 	} else if (fsa->svid) {
 		switch (fsa->mode) {
-		/* DP Only */
 		case TYPEC_DP_STATE_C:
-		case TYPEC_DP_STATE_E:
-			enable |= FSA4480_ENABLE_SBU;
-			if (reverse)
-				sel = FSA4480_SEL_SBU_REVERSE;
-			break;
-
-		/* DP + USB */
 		case TYPEC_DP_STATE_D:
+		case TYPEC_DP_STATE_E:
 		case TYPEC_DP_STATE_F:
 			enable |= FSA4480_ENABLE_USB | FSA4480_ENABLE_SBU;
 			sel = FSA4480_SEL_USB;


