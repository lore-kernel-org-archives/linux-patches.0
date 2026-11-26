Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705655;
	b=f5ul+KnQ/pD/qsY8VZkOmOhDQlrxkyA+bmzhQ7t9Gj86ZkqQnwJMnKKDv8/1eNWCEAjA
	 EcVXw5C/DmJ9plmwt8bWIBkOKEHTRt540gSTk25Uaswd05yqqNHXskglsHBzB2zZV9NKB
	 VaqfFMC6DPEpFeD/ZlbXALXfNihHz9pxKENKPtdYXxyHJfmn3bwHtH1owjcfKESlAhMiC
	 bO/XUBh1jhwRfNT3UWgYVnKwOoAVtDTUVjSGf5gVvHsFRhO99YYYY3s+YQHRf4n4MDk9H
	 r9g7gwgbQIC2+o7aEs4Gy1Vjsc4dJKEuJzdIcozOKATeASQgGkpFg+m6QJODDiMrYLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYXbNIo8L1P++CPZi07cqsmyodBSYhS+UNSi3HlZp0U=;
	b=TNRlYtntCIs6+II/wDYphbzBsibYozhBCXtG9rxQ+mV2M3FNbY6HQFZNSgf194vB3L6p
	 72359LtUfKjR1wkY7YwaiQJt+uRDUddHgJV8sl65J4UJ+QVY2joqacp57DI5oU2sfG2qQ
	 UiZ+jYWv6rK2CxD07EPW+9LP1Se4zp2spjy8Q5VbGeftE2X3CcdKqpNCgALFknOIOSYDh
	 +vioq93fJvso+I+SVruguooQSv1bKJdh4W+zhBMfB63LuH3BIQugHc2hxPD9SxteM9c4E
	 rrWW3t2UJbJxowtmIfSRs3JniYR03nTy02Utfmr6L5AZ3JgMiTFUXrKLrbjZWnNPK4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TF524YOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7508E606A31C;
	Thu, 26 Nov 2026 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TF524YOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F791F000EC;
	Thu, 26 Nov 2026 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705655;
	bh=aYXbNIo8L1P++CPZi07cqsmyodBSYhS+UNSi3HlZp0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TF524YOQt3BRIgmm2kzWcxkbEMarmART2gPECMDnxStVNPQMVNqna43NyOUOka524
	 kQgTOICATaj7FoX2/Dyh4cdcJFUZMOVtCyleq4jMJR8jzzFWnCxNwQVeEQkvW/ytg8
	 PPF++5TSi0cVd8lCjTOrgJEYEFBcsb1DZ5FJUwBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 226/319] sctp: report the partially delivered MID in PARTIAL_DELIVERY_ABORTED
Date: Thu, 26 Nov 2026 15:39:54 +0100
Message-ID: <20261126144011.850118395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1253,7 +1253,7 @@ static void sctp_intl_skip(struct sctp_u
 	if (flags & SCTP_FTSN_U_BIT) {
 		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
-			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
+			sctp_intl_stream_abort_pd(ulpq, sid, sin->mid_uo, 0x1,
 						  GFP_ATOMIC);
 		}
 		sctp_intl_reasm_flush_mid(&ulpq->reasm_uo, sid, mid);
@@ -1265,7 +1265,7 @@ static void sctp_intl_skip(struct sctp_u
 
 	if (sin->pd_mode) {
 		sin->pd_mode = 0;
-		sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x0, GFP_ATOMIC);
+		sctp_intl_stream_abort_pd(ulpq, sid, sin->mid, 0x0, GFP_ATOMIC);
 	}
 
 	sctp_intl_reasm_flush_mid(&ulpq->reasm, sid, mid);


