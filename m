Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211789;
	b=TKtyV5vuKdt14vsH6y0Vv/P0kLTQTbCTNUZgu9aPmkFh3pUmfw40MvvxVhOkvkwV4Ju9
	 Z3KP590rHCo2pHJaDsGxxU7Y2Bc7rj1noWbEHA60QEDY1S2q+XmHEq0iD0nb3CtQ32RdN
	 48N5OvphBSkgh0qgCzEGdP9r7wh8xopE0xEBW3o3F1jLy/vbH1fV89vdNK78W/xcjC6fQ
	 gcyyRSvUSAEJgeVdG59Cu4mUS394dKqfPGI21DXEfiJZ3hRUmDjqfWQRjzQVwFGOHbKsn
	 ah5g2Y3g42zvrln9fgYJ/Sr3Qg0403w6YlJJCJQk70vTe76335a6GisqHwYRLjxkK6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBte871UaKW98GCIjs1zvtSCJQqR2gQVH8+iT3kCCPY=;
	b=qOGanybM17oZRm6L+g2c/zecHk0ykzrBkzdNhWY57yCCfgnq0KtyHgElTp5JkPVMjslt
	 Vmca5iDheariTKrqOPSbQ/0R9JpsEXdO4bRaQYiW3rZ4ksGlIZcDG/rqqwgO3R//1OQ8/
	 RCNPAKxZqyuNU7DY505Zvm6pSNsIGgQCbjgilXlF3VYNvCFu5oX/ukrDj9zGeTjc+c8Xg
	 O/MO4FgI6oArC1ueXr2XkaK1IznAXHh3ZyAWgm3HbvY2ALSD3+byckeYO0wv/8OAZebRG
	 xnvTwLAA0OlqZeZ307fjEur4FBAF996mJ3xyxe2x/Uh9XoBlljc22PsZ6tJ7A9PIh2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yaQuUrm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D530606A32F;
	Wed, 28 Oct 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yaQuUrm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC57C1F01825;
	Wed, 28 Oct 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211789;
	bh=fBte871UaKW98GCIjs1zvtSCJQqR2gQVH8+iT3kCCPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yaQuUrmEpfPL3gEeds+EHy8Jgar2Dffcds4GM9YMDPR5ZMdHtuy9eugtWoRt2byf
	 An1u0Ll4HjnPeCC3NJRn2IriAHF/ax/EAQKFfJsG2pRZuE/0UqZ1L+7njglH7z7wNs
	 PGVx3EVHsqiTTwZADKeNauYZmwbWmbloe4SarNo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 500/571] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Wed, 28 Oct 2026 18:00:47 +0100
Message-ID: <20261028170019.893360444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -1132,7 +1132,7 @@ struct iscsi_task *iscsi_itt_to_task(str
 		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
 	else
 		i = get_itt(itt);
-	if (i >= session->cmds_max)
+	if (i < 0 || i >= session->cmds_max)
 		return NULL;
 
 	return session->cmds[i];
@@ -1325,7 +1325,7 @@ int iscsi_verify_itt(struct iscsi_conn *
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	if (i >= session->cmds_max) {
+	if (i < 0 || i >= session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
 				   "%u.\n", i, session->cmds_max);


