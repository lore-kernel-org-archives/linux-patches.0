Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774754;
	b=o/1r5fiLK0VYrUwRI8v7lyf0Dcm1keDppEe/8AOLV48EkWcBOqinADx1CR0fd8wbGGAQ
	 qDFuLAk9nAqrcFwAs0/TmKQqUXrSk37mcfBzXl1Us47PjZ/f3b2CZBqBLV3+yIi/yWc+I
	 ptp4uPBHUg+KfU3xKGju0qyza9tgw1aT26tA1i7d9PcvXSE4egDlZ7RyvisSJMSEj9F4f
	 FUWuPhV+XlhG6GE35Choewg+vZBgmAecSpCH2rlhj7Gdml1n81sK3ZVao9F/+1k/SoUMR
	 pOM3frtMha4B+bIgde5LjyaSWJpBesgQ+Xqk2LhYUSI+ZJa1Ez1l3I7TvrAsCN2hf8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JR6ubzpFPUd91vSjwltRIqdwE6sn7IekVpsgLU5+4kM=;
	b=yk6+js5Gwde8sttSzjtT1BiyME2KRsO8cP0CbFCWaarlyvTIWVenxm/XNEk+04YhA/iA
	 Z8dmwiHAMz9PRIYHxxgyV3YvOANd17Wzdzw3POBI1U+NSm4dYczEVSubsW47hCL+2Lld5
	 IhzCFJtjDqqMcNhPPvr63FcDis7KfxTxy+OG+NFt9a9HCCeO5HtPA9zKsztiFo4iVFNxe
	 W5SrA9Kbo088hgYdg+7w93PU1FtM4s1MkvL7xnMxHmZVoyE7b2MMPzIBXwcL+w4FMDioC
	 cm93UKRxlx16B/pwHK6NCYNHC3qvanKabmJ0VQlSoM8qX9wKbKauPsWBfDkIbPOXXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+gbX9mg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9782E606A31A;
	Fri, 23 Oct 2026 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+gbX9mg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80CC1F01825;
	Fri, 23 Oct 2026 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774754;
	bh=JR6ubzpFPUd91vSjwltRIqdwE6sn7IekVpsgLU5+4kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+gbX9mgOhCd750xi7W+6IzFPCSvIVnzRXe0u90bta+0ezlWAiQpfLPze6QHqngE1
	 evbDDMJmsEAEfIekCugBBRF/Q3tgHQXQnpkTGunss6YMydkcAwxq0x4nR7lvVmYei+
	 CgwT18WocmOe+3DWAd/NaJET5UDOfOV2arXftfoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 147/242] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Fri, 23 Oct 2026 18:39:49 +0200
Message-ID: <20261023163717.259755162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


