Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619964;
	b=RSjAedpm54RSLvsSO8glA2dr0010WrWsoaeeHLl0THOAGhv0XX+65t4cpVafNg/NgCE/
	 IWwZ7qGLhe+MRcHN1ubybokgn78fuC75nbqlGMwX4SK5mpjdt4mlca3wTIMcE3ryWkEz9
	 4A8vAm4wOZS38f2+BwFUDf/q0OQAK3ofBvKKNqqFSl2wPF02OwSxAtcXcTEf7o09cPyWv
	 8qI+PnKErDB0KYMyuWJ/Lr3DHf9wXFe+g4bUb1JqU/PZcT0t5P4zwIGN/8IAiuRkxUth8
	 MNwi9kE+NreuQshpK+6a38qtdo+JLoRse7oG0s7NUzd+5YJBTrsiQP3wT/TJ0+WTw7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYA5Y69mtm+QcSaYR9s0FuxUY7q5cXe8mT8TKWmtLr4=;
	b=bITB4x1ogc2Zuy3WyTqwtgNKZOL5AuDDlzzMM67i/zGC9wF+RN6ixP5USN8SnkarTGi3
	 fYKr73mbkcfRjxPobMx1ThH+5iCYyxsj25wXL6WH3k3Xy/OxZQV9qi6aBuaFGF+1/uge6
	 PZ2055c98FleyngFqEcXsf/OeFdSiELkiYBWv7gnLH3EwoKzi/J+C6Xe3gjI6eMEJkrK1
	 ZLiQrEVpBlXeqeX5glEGQGOgGoZlYGniSmSAYXwhiKKpJ5yGI8LH1h5hW43gMf5ZsptDH
	 zwNbDVv+0Ky6ZMdOcbBSCaUIObAfLaYKIdOWH/xP9lb1+LttTgV3F9PyveqsqcFq2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLUeCoa7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B436606A327;
	Wed, 25 Nov 2026 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLUeCoa7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C5B1F000D0;
	Wed, 25 Nov 2026 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619963;
	bh=pYA5Y69mtm+QcSaYR9s0FuxUY7q5cXe8mT8TKWmtLr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLUeCoa7WBv/TiNFqHe3rEv05zf0q74Ix0B+gm3xz41Sf2tStgXjTigvtNhe9hTuu
	 md1ofS4GiSNJ/QwnOjvR5HNCTvfmaRa+CZZiLxN/AzgCXPgV7gguH6yhQtjAi6HVZH
	 i0zPepkAgisZFMUOfmavhQ5mZsx/K5R9HjoZnSZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0764/1005] sctp: abort unordered partial delivery when its message is skipped
Date: Wed, 25 Nov 2026 15:35:02 +0100
Message-ID: <20261125143839.644612859@linuxfoundation.org>
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

commit 05852c8b70f2291a50bb3f740a66ce9caf9cb98d upstream.

When an I-FORWARD-TSN skips unordered messages on a stream,
sctp_intl_skip() only aborts the stream's unordered partial delivery if
the MID being delivered is lower than the skipped MID. If the skipped
message is the one being partially delivered, partial delivery stays in
progress: no PARTIAL_DELIVERY_ABORTED is sent, and the next unordered
message on the stream is delivered as the rest of the abandoned one.

Abort the partial delivery when the MID being delivered is at or below
the skipped MID, as the ordered case already does.

Reproduced on an unmodified kernel with the uo_pd test of the
sctp_ifwdtsn.sh selftest added later in this series; its partial
delivery checks pass with this fix. Reproduction and fix done with AI
assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-2-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream_interleave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1255,7 +1255,7 @@ static void sctp_intl_skip(struct sctp_u
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);


