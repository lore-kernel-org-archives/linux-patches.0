Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619976;
	b=uANmHWbYzmZPQZ0zp9GYogaaHqcImR38zrQRLc2byuG570MZZWJmWUxu29+tw9S+I/56
	 QdDDJI47wse/hJ7ePt6gdizL8HH9i/cG+kLykqbO1t/T4+EQMFbxrK7qCgPhUS0xsSlgo
	 HrIg+rcC1LSsmowcc2K0IMPSucH9VQknJm/+MrkOuEoGLZ9CCncffxnHbdzHzYIbmPleY
	 sPl6lpa01oeETE+3JKJlj9RXTqTdUn6AbDrcUkCDP2tpBubV5LI+CS2FSV/kTL06u3zHQ
	 C2yABXtUfN4i0+ycl5tZ+eDZk2TEi7xnDsH/vyhyYYJCGeYbJgQ6AZh//yStuR3Ilxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CnFTUaQNATzBIml+7lLPfvLeS+L0unVXCwX6b2pIWFU=;
	b=StOdOCZY7WunGGTbLx74L153olLPMj1u8gRNNAEbM2DAtNi7nuJ4X0YsaK42P3J4sypS
	 cANzHiSmMNe3w0FJqYmaNvDo3pZj/gImMPDbwBZj3jl6LBdcOJspbNwBE+/P81I8g2xQT
	 ZyY7Yf5GdwRK9jMzlc+uG5CUjrHckSJkjA0e4A/4SSrjIQhK5+14Hwzy4HUD6qnuGgRnK
	 unMu4a/4og2JblbhOjS+0xRbCQ8fiKoS2+ynce4ZTuilsvaO66ByUi04oAOWfJo2dnly6
	 b1MOP+44pVei8EX/7Wbef6KoOQplplMKR8GuXBlfzRCmrG9sWVkq3D9zCqZdmVEPJ0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1Y+/Ea7W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48785606A321;
	Wed, 25 Nov 2026 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Y+/Ea7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997A41F000C4;
	Wed, 25 Nov 2026 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619976;
	bh=CnFTUaQNATzBIml+7lLPfvLeS+L0unVXCwX6b2pIWFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Y+/Ea7WxhzrL+SUPtoX6x+P7NbcCgiCglQ9KB3umwHf3BJm9ufJ4Otiq66+zTiK2
	 fHh8389UCNw2OJyRTWNv4/TxBBAlKs4uRJ9IYJahrQtTurC+xkCzxKjEghJQGhrCO0
	 xYqtC5F0T8UY66kJL2CVDhTbS8oyFLRfEkdmOxNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0768/1005] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
Date: Wed, 25 Nov 2026 15:35:06 +0100
Message-ID: <20261125143839.737098826@linuxfoundation.org>
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

From: Tim Budding <tim.budding@gmail.com>

commit 3097fba868019924e92b8786ebd473992565f015 upstream.

When an I-FORWARD-TSN skips the message being partially delivered on a
stream, sctp_intl_skip() passes the MID from the I-FORWARD-TSN to the
PARTIAL_DELIVERY_ABORTED notification as pdapi_seq. That MID is the
highest one skipped on the stream, so when more than one message is
skipped, the notification names a later message instead of the one
whose partial delivery was aborted.

Report the MID being partially delivered, sin->mid_uo or sin->mid,
instead.

Reproduced on an unmodified kernel with the pdapi and pdapi_uo tests of
the sctp_ifwdtsn.sh selftest added later in this series, which pass
with this fix. Reproduction and fix done with AI assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/179293012867.3134.16497481637722705271@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-3-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream_interleave.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1245,7 +1245,7 @@ static void sctp_intl_skip(struct sctp_u
 	if (flags & SCTP_FTSN_U_BIT) {
 		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
-			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
+			sctp_intl_stream_abort_pd(ulpq, sid, sin->mid_uo, 0x1,
 						  GFP_ATOMIC);
 		}
 		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
@@ -1257,7 +1257,7 @@ static void sctp_intl_skip(struct sctp_u
 
 	if (sin->pd_mode) {
 		sin->pd_mode = 0;
-		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
+		sctp_intl_stream_abort_pd(ulpq, sid, sin->mid, 0x0, GFP_ATOMIC);
 	}
 
 	sctp_intl_reasm_flush_mid(&ulpq->reasm, sid, mid);


