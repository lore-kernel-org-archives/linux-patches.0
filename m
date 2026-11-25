Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623230;
	b=pFkLB7ZSWzUDftjnC/j3UHRbW/zOY1uEmbocQdn40m4rCPhLlbOUHXFJ3yfGsZkK9bIY
	 lIy8JUcf2ptQjrlJkUDj6BHDFveFez25cj5aoor6mTm9+IXcjbym/cei/BTCpnFSTcXI0
	 +vs+ox0yTpzMpeGlrFDcKRpgilnMO9E52c9Q8XK2zgAEwz0UPAiC1A6ZWBOtEi0+kyvgf
	 oFWz2/lkg/gFOUy7nEHJm1/jKlnC3AciEjrLMPl0sKqhloeUtpSo6CNCA10ONI4jsp0h2
	 17D3eS3puSHoYqvc4KW6Xlc+/qoTmhZG7Vhi7w+SzoTuJf2ixrESOW188iHL5GnYnUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXtPEVE+iW4pu3pST+kExmbtjnwaoDR4Qon66LxZ6Y0=;
	b=GyL2EE4QFOFdFdIEGYlaB3nvK4PTK29gWPYWutLyEWDlbpmgubwSzOv3LbZ/RKUa6/7U
	 4AU2pG0gFQquGMfOGBoG60G2R4XcCBVZGCL7/DABleQZuj8PE95rjED/GfO6MX+hiTNd7
	 MTiijumUFEsz7iSmn/5fN/AM9FyttxB0tVvglZF2iYgxJvgVE9j5ZUb09lTHtLiS8mae6
	 0dE3ZeCpWBk3aYb0tGpgj8LMXh82fU5/RbEZkOyFyvaPHHM//utPqCzAnzAP695lvXvR3
	 Hv2MraXw/JUauAo/GxEzqEMUG3IKfduG89bF/boLFmw6H0286Skkbcja0kkDdfKmSVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mk4Frisp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E277606A329;
	Wed, 25 Nov 2026 16:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mk4Frisp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD1E1F000C0;
	Wed, 25 Nov 2026 16:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623230;
	bh=sXtPEVE+iW4pu3pST+kExmbtjnwaoDR4Qon66LxZ6Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mk4Frisp7w5pbB+tVsfvcmcIWDQsA/H2aUSh04YaH9+YwmzxmjvlccH3XL56R02AZ
	 wJiJ94IyQn+uzNCpqNnKmmw7MfKbj0HTTlIuU8Amku5Q6g8wlQrIsdVK5Ejk76I+4M
	 /ypvDKoqBG73ZAC8Fi71QqOX5I9zOkf0q6jucgs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 793/990] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
Date: Wed, 25 Nov 2026 15:36:00 +0100
Message-ID: <20261125143840.619988818@linuxfoundation.org>
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


