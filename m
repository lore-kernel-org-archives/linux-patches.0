Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210170;
	b=DwOpKjsELWk8IcI88PIOQ6pvrpDCGytm4j91DSHjAg8d22+xqkRa6aryN4JfkyvTmEcE
	 YlDCX7rTgs4Kac+fbXplacmUHyDaRpKRjAEbei2wLPjK/GUPy4FWGXIb9FlMj5gW0Aa6H
	 E52gxj2kjRTosCwqRD8FU017JWJhhOKOhyawdC22mNiP9otoKUtX8Zw88nucF7rUPMjfJ
	 eJoAcgFUtzYuKfozPfUnL22oD+BzErpn1BCOF39Tm1geZDzJSUMJjV6J3XwudHrHXX/QA
	 IBZWrLkvj/HhkQyv7ZurAGh3+Wl5p9fDcFu/KFI1zUaiNagtNy8eHSZAZg5kSv6dCjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gUO2WX69AhFXz+Rij60qDu6BS9X2Za8zyek932ralLo=;
	b=fqDb2bUIJ/6QTY89fHoM2SS4eS3Kp/FBgP7AXSsiuRqPNo1LviFTLCFzi8Rz3CTAIzHU
	 kinHxqPLZC+41MTnNjYM4ateviOAkpPYl8b3sidiEJlgyrZ2UfE8NvsDJdIfldbXrz4TN
	 5yli/7Zobf45c8kh8ajX2sfY81tTeV4QrwTnSRHSPjuyoB1udwYBGZfHT1wuRdWbNBGN0
	 V/sQAuRlO57hXFCG//2XJ12kuEFaCNnNAfHjIvm6543sGOhVtaLdOBKy1u7NVt83MowkY
	 Fc2lN6ERtju+Hc2zYBbrCDifjareiaQH84DdP8+AerNoEZe9qRTwSaV6y9YQxZv+uYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1XtPSJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFCA606A32D;
	Wed, 28 Oct 2026 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X1XtPSJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19CC1F031E1;
	Wed, 28 Oct 2026 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210170;
	bh=gUO2WX69AhFXz+Rij60qDu6BS9X2Za8zyek932ralLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1XtPSJQ3znrzFeX3wNwhdWFgFOOyJOlBXFsv+1mr8K2Yf+sn36S7rEJLjvbhKrj7
	 aX+zlT3wSNRo2JHAFeh/VtSLcQN/VXaZf5KxDdBf3KWQcawjLH/4obZodg+c8Y2VVl
	 iPfJFRcslyqJ/Z2s9f+5YenpAP/URnhIXQyWoI00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 055/168] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028165944.391859070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


