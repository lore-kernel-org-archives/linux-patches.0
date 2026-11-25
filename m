Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626130;
	b=c5yVMjSicLK32FX2WRI/okrQkiU1LLySaD+chrPA5gscUSfkWvkL0vRkYEBmDam0K1Xs
	 i2GN2rSlZRsv09u1p6Ifrmuzz4bsN3BQoaMgPZTWIjMXrfuv//8aj73068sRgqU/Cf8RW
	 48cGxaglxy2VhWDHFZF4jRaksb4WhM0pUpgpdfLcxLMv/MEv+Rh1sYNfIXh4mF1umO1ir
	 ZpdLeDY6cqJsB9PRnXcM3hQ59r0kcZTY2xakz47hZL/r5hg8dDghCTKNvlyuGwLBhrAmG
	 K1CXhAlidXX09zVxE+mRudsw+nGK3KDFGALuokDYQu3KAC79YE6rBzjTqHnRxAduikA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5NXfN7xuRGqJcxSB7hKZghLdgpRr79sEydvpMB+pGIc=;
	b=DaU3cjHINGWaWeTc95mMi5/7m26o0Dzbjd45PbPXjH0oF/dCq8jyXBHgmzJE9Pcz4F7s
	 iOn8N+WAWwvonMftJUc+EjYcr3JPafqtdmIbyFUN67scKkbiINp3dBI1Zm8RIrO58mpRf
	 6MQ3+PmKDaoxS1XLCEd+KmdBm3Lqw/3pfPiCe55Ji57XWb/ddfrFzJ+RSXBfMN5Yv1CfX
	 p4loLkbnD8YRFUpXb5gMwxiaFxVOjZCSUQmudnqFZAtjocMg02f+d+K0/Vtm8dltGDDc2
	 xJVxa2nQroMyjyQ7lvwm8ptW4hkYGceoXSangS0qHQvzqoCtldcm5B1pXx55ryoa+Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dd5RFjmg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD769606A31E;
	Wed, 25 Nov 2026 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dd5RFjmg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE881F000C4;
	Wed, 25 Nov 2026 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626130;
	bh=5NXfN7xuRGqJcxSB7hKZghLdgpRr79sEydvpMB+pGIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dd5RFjmgDc9fNGZH/sXqD+Z6vodicQTtBU66SXgGzNrLiBWDoHy4MBUYfNz1yMoTF
	 xL2wHJYH4jVD5qA0fHj0mzWlBY7OBXCi+/uWlgvik97fDIjNxC97Q8yQ0tl3tkN1+K
	 PCPz/DmPXyuRqyLq+Q6t/A5lG2sca8VJ2ZNZaMuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joonhoe Kim <26rote@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 741/816] usb: typec: mux: fsa4480: Keep the USB 2.0 switch on in DP-only modes
Date: Wed, 25 Nov 2026 15:38:09 +0100
Message-ID: <20261125143906.330734140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
@@ -92,16 +92,9 @@ static int fsa4480_set(struct fsa4480 *f
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


