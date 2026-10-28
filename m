Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207736;
	b=j6qXqm9pRq7abk2Hu8F2yqjbM4O1unhJWQpq9G47DDSoZf8KDkRa8W4stcIfyAQ3Zz9P
	 dPlk/ObYXOY2R1/lN/zfJmb1eaqk8eEevjKpQTXRlGpi/VQWVIJKtpE3dasuJ3ZxGmQDD
	 G/UJNPJPFXHhlCan3BmClFgkzI/K1vmgOoD7NeZN23lb89GwBZCFp2B1i1rx2qRmm4ziG
	 qAXrkN4aiCAIzZemWReBg7zzwlZrI2TLn6V6OsQ7Ow+O3NAB8cSGIyOx1oriakcC5RSun
	 PtECerKtxi7IsWS5Beztqj76PXg11mv3TaMeXvoo/hY+6GZDY18mcmcyIdnvSOdtecA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uEasz44e1kj84nNn5EeSG/K0CH1+hs/XdOhU7j8D2I=;
	b=1urXVDtdNmqUXEKlddKzFtPLfKp1mS9Nwg/KOHw9lqOGTBj3t9GKzF9FnK/8oElemT8+
	 O8CWJRRe1pllREqUq+StX/5nG0PI75+C4qy/HOV2mYoOZSb5gXbNAS8autWTxVvawFLqW
	 EH1Miojnph+gMY19/gjhC60zbHiPJg0rkk/Pc2Ys0SgiYkIXzvBsYnyl8fk8yTJw4VoIv
	 XORtKrz0j0qVy4YRnxjxdQvl5CCKbfuZBQzxPO/MH1b/SmR6MNW7OtTdkbo9cQD55btkn
	 L3tnXkXOT1QmEJCVT8Yh04j0T3xNliIcbKQx4g2ujs9L/ol6OtU/ktkBWqNjnEP0GBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmP6e9uA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C99606A325;
	Wed, 28 Oct 2026 17:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmP6e9uA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303791F031E3;
	Wed, 28 Oct 2026 17:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207735;
	bh=7uEasz44e1kj84nNn5EeSG/K0CH1+hs/XdOhU7j8D2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmP6e9uA5/Q1imEpjR3Qi8HAkCl4ow11eKxzRegGlgrwJ3nNecGiP+cN6y8gJ/myZ
	 T4M0QwWIXOTOiSGcKBaDmCzUheKqlH6vtMyKr8Jwed3rgLOJ/iKElFgorYhKh/070R
	 CuCadKeYEhXCs0siwRDPJjAnuKsGZ/5Nxkus5WYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 084/247] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Wed, 28 Oct 2026 17:58:07 +0100
Message-ID: <20261028165949.384342760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -1191,7 +1191,7 @@ struct iscsi_task *iscsi_itt_to_task(str
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
+	if (i < 0 || i >= session->cmds_max)
 		return NULL;
 
 	return session->cmds[i];
@@ -1384,7 +1384,7 @@ int iscsi_verify_itt(struct iscsi_conn *
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
+	if (i < 0 || i >= session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
 				   "%u.\n", i, session->cmds_max);


