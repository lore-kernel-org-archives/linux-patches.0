Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209401;
	b=JbOwBsZsCkQYnJE46LXmaQXrveiYKVbDd4BF2NbGxH06GdLwxKxN58t16Pmsnx3Ct6lW
	 BjR3H2PaaLUXLlMNi6qFZhxJpMgRtEfkesY9DsvDgCjmal9PrmXPPXXTvEaxgnsC0iswy
	 j1pWwVyNOhL0u26JzOgoB7QFU8l0NnaWmISlEcwwCzoNMl20HrHepSNgoYSlDSC5sidPi
	 WJZCFpxw/mwqElRPsXKro0fWypjllOPZ/xFbB2b0vi+DIlp5fPw8ltOc42IbuVaHmOT0N
	 KoMwM+ccjO42XUHhe/i6t5b/m7mlYt/Si19WVnQS9hgBHFGzsVFXnpQYBOjkqu4opyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQ/Ukktb3OsyDSnr9bDxAR8xA9hiIqyz4vimrlcgpFc=;
	b=30bPgDzLWRp4bAaJ8VJFX8kfSY6bT/ruMs5uCqPSgfzjfCEuu4GlE10hhgQZZos6bHH0
	 bZ89Du+ADjtsJRg0BPj+/iI1PmotYJiitdz3jFlAcumrnbPjKoZetYrqTppLrI9N39vDq
	 9l8XMnztusR+AejuYsCe+HtCSYmO+xAXnePWXgExy4a4T2Nqlb0RcXHyViqkLPJOFFjFF
	 5mPHC5r8j+PLTVQ2DD0OdF1KKGqk7DJ8QUslU6EJ5gYvklOeW4AtmX6Rg+UrOwHpjejWt
	 MJj7meYhcpt3tDCHgBHsLaH274qonCifj2sb4jELNCic/KXuekHBifEDrmsTwXqqWVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOfs1p3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6E606A31C;
	Wed, 28 Oct 2026 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOfs1p3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE0B1F01825;
	Wed, 28 Oct 2026 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209400;
	bh=AQ/Ukktb3OsyDSnr9bDxAR8xA9hiIqyz4vimrlcgpFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOfs1p3WLYh73AGelBNoo6kB5k+nT5PEDfUQLIJOrLVS/yXm3/xxmNhGn4f2njj36
	 +JpLV2PY2GtA/Ypx+1Mdc6Svsi1NNsLvm5vGiMRLQwUj6V8uj+lkGHrGAsRntYM6Vb
	 V+uGdDGB+HF1yRYvxS29tVwjcdQS7s62B6KOljSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 457/516] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028170014.305150948@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 8ee2a09a1dbb257c9e828ad2497f8e4832dfb142 upstream.

A transport that implements parse_pdu_itt hands libiscsi an index taken
from the PDU, and both lookups bound it from above only:

      if (i >= session->cmds_max)

i and cmds_max are both int, so a negative index passes and
session->cmds[i] is read from before the array.

be2iscsi produces one. beiscsi_parse_pdu() assigns the raw tag,

      *index = (int)itt;

and beiscsi_complete_pdu() forwards an unsolicited NOP-In from the
hardware async ring without replacing its ITT, so the value is the
target's. It also reports the session's own age rather than the one in
the tag, which leaves the age comparison in iscsi_verify_itt() with
nothing to reject.

Bound the index from below in both lookups.

Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20261007015842.634893-2-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1106,7 +1106,7 @@ struct iscsi_task *iscsi_itt_to_task(str
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
+	if (i < 0 || i >= session->cmds_max)
 		return NULL;
 
 	return session->cmds[i];
@@ -1299,7 +1299,7 @@ int iscsi_verify_itt(struct iscsi_conn *
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
+	if (i < 0 || i >= session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
 				   "%u.\n", i, session->cmds_max);


