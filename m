Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217091;
	b=FzPfBeAvZd4z3otwi55VzzAyNVkLrMekCjz6dtS2cxPszmTZP/uyC5qqkWFFcP5W3J69
	 waUEwc30RU+2gCBaPJyKzcW+QUsSv0C11e9W5UJpQjwgpCbTrD9TISIRQuUa5qFg/8qVr
	 reWzo/NOSiqpzW+zpF6HATvazP0OoyRWRoYEB69fSZFhpa/JZK/wSx8FIi/TCy9jfkvI7
	 oIe/0a1LqrF/2ZLTUBzEQ3nxKhC8OvE5zgPEgki4wTgUtW6NHzE5NPow3adeTR28fITTg
	 srhkaWSqrMxyYV8F4mfEjSok4hDpfF+m+BMYv3k07pgmaPchhr0oR4ZeLDKhdUYnymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZi821eoUzQqCFPMSjkWQLSSt6ej5xFsszRKjAJSycY=;
	b=MusKHiY0HRr0Qz2l6cBC9TvvNUMM5bP5meChZ7kfRTmAqfxqRzZZ4x79QrBSJi6CBpJq
	 ed4vR39TGrsjAq9b1K9JUfhgqxQBwEoIO6AnnJNBzj2VyezFebKGg7/DIReq3DKKOAx8i
	 9hCFEgMXgxs5Nectnhz6jInw3fjN785lUp+eC+rFyRZzliNfWPWzvyhRBXz6FlkycNQCf
	 0JqmvML00bFeS21SAH4QNyjDNpOJwCQVP1yhfbXJSCMPkH2HxFmLBkNHqkr5/PZ7L28n0
	 bkaHt6Jou+Q91zJ9aoaK7vyq4Mi9p7Th43n+iRpG3C/x3sE2JP3b3iswZncsKF/t9AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4NZ1zLx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40591606A329;
	Wed, 28 Oct 2026 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4NZ1zLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE411F01828;
	Wed, 28 Oct 2026 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217091;
	bh=cZi821eoUzQqCFPMSjkWQLSSt6ej5xFsszRKjAJSycY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4NZ1zLxz8Y2DkMrk02BkatxTOifdm9c0681TfoAhYMsJ2dXOSQrKWKNwotVpssA4
	 Qtw8DyJ3LY+kxol4K/j83//iJUH2rHMUURzpPNhfcIW9e0j5ydMGT77lDLMIgvHNDm
	 mDi9NPsriYwUL0G2Wl0/t+XAtzxgONqyJP5u0Ufo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 1742/1887] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Wed, 28 Oct 2026 18:03:58 +0100
Message-ID: <20261028170539.095259406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


