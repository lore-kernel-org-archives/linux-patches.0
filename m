Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774152;
	b=0HaEYsrk49Yad6jNkDmkOuoumxZp5CmlpGC0ty3xPqQkTrkfaORbVY6wetw0F88QDp/1
	 ku5lL9dfj+6QIct3EFMiToPtSwyX2LRdf/o6gY6KC84eu1ERVX4uJJkigpOXVYcxSqduI
	 tz2jORp8R3WqFO4Ls3nXAMkgANnYnRIa1WoS5VDyUc+1sfBYTGldNF6/+0gCya0WjsTSP
	 dNE76vQ7vlPuuvdd4wPyLp7Ba/O0Kvb6QBX2/lUiTflgjMfK1D4qkRjDjVGCg0i7TrISe
	 kgRDvOG0Y2oDguPCzyj491hPbI/BY9ngCULtFq6Z3I0hffUn4B0Z6ePRVgVOdAZ/VDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EccihAiZNrPS7krr9Ofi3l3h8chJ5s4Brwa2rVrM3+8=;
	b=JKTBlFecw/OCpLJ3BXF3wwQOI6KcEOrONHa3VQgJ1PUUii2FqC1BTPdEeAbqLt73lHoD
	 dGMRrOQVhW62t6yJIZcstAckWlWhEdlMQQxZwAVi3bsqp7wOO4StAygbHa5kV+zHTsjrj
	 9udf4wmdv7BFFXYPAKlNqzR9Ib6XjLYb+eQhJDT8tQun/WHDoorpwJ28Yy+2XF6r5c7xE
	 XWD/D3zEfSK8mr96IOTlFXGt4GdBfnVA2MjpfNxw1KmZihdTt4i+LG/xU+4/XD1L+6Prn
	 pbpVULd8nZy9n9O/jL2n/DzWvOG+4VpndZP6WglnC2B46HtBa0ewV10jFKSeQmMZItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBNKgMUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D409C606A31E;
	Fri, 23 Oct 2026 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBNKgMUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229141F01825;
	Fri, 23 Oct 2026 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774151;
	bh=EccihAiZNrPS7krr9Ofi3l3h8chJ5s4Brwa2rVrM3+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBNKgMUTr7UGPE6/KQXOoSyGXUCZiY2ZTLc6fuwvwjbyGhRNb8Q3HDI4jwbzvlHBk
	 AAJXIf1lruyR1lGPdtveEme3ZRHAYXHjIKmAv8t/rV3jyeJLi6P1Lqlydsvbh1NDaV
	 96/VwnStGqb+wJYU7yDfzjU/mM0Ppq1qOQdsFBOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 100/193] scsi: libiscsi: Reject a negative task index from parse_pdu_itt
Date: Fri, 23 Oct 2026 18:36:17 +0200
Message-ID: <20261023163716.571837503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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


