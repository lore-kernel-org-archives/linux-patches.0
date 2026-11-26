Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705090;
	b=11rqWaQpOFz7wayCcjhIFMGmVLm3zEs1Hl8xXpliTaIUTPUgDMXawwUhcbFR1rnwK/Uj
	 VjggDny4eg15LsuklFa8Oeiwn2eHOTXWo/8xjJYaMNMiuTq7YbsRxO6hJpgGL4WKk3fw7
	 4Ty7fy6l9+SSTGlhPV7Cuv5ierKKDlOKI0zMtcYA4W5ttGDaZFlR23wu92mXa4uEr7Ff/
	 /m+jlZj4urwzNJiXbXt/UJ+DdpUePmRLbr244hEtySBlPqMekAQDfdwFSZezuSDsnnjZv
	 skkxbvZy4/zwQHqqkqfTece5Dz4UQpzERLsoh3i9amX8qmegT+XjjcpPdjqoiI8i6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+bMsHEvFLooc4eFiDfCsSYkQcBxYGHPqA43XIhttp0=;
	b=Ei6RzhP4j2nxinnMG6vwrpMFCxuCV7wIE0qP4LjmBeR39BEo9T4pRRczzdOSv2yAsGCZ
	 n2GV63kW6JqOTjU79KjTcSgVWfFPWWKyu2IXNdt7/Uftz2a0Y+3wR0MgXiBI2b7guXo3a
	 9DmTIBejGdEcMSy1+OFkEUxVDLLQ4a6PWAysoW4SmMwn4qvZWa2XSoyzxVjobycZCwtXq
	 yo8NGccoV1Aosf8YRKpWg+JF8hedmu1KJEupulx0FIQgTITnC46JP798YjQRqzbeo+Kye
	 j2MwHUu1fDsi/GEIXW3ZOHk4jw+pexP8PE+1mkYiQfzn5QQ3TnqIhqzLV3NamE6/bXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+j5wqnf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D4E606A327;
	Thu, 26 Nov 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+j5wqnf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D28E1F000CF;
	Thu, 26 Nov 2026 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705089;
	bh=e+bMsHEvFLooc4eFiDfCsSYkQcBxYGHPqA43XIhttp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+j5wqnfc9ZNrFfQcFWbxeuMm83bvzEZsRlk8mSY8fcUAM6ctzVCxdvO3UnBhQUFJ
	 NzCvxCQILt8jMU9GzXhZQ+5YTIwLXwlbjYbFHJUGfs4BcUwJ8ZtXFypbge7xOOi0/3
	 5FfajvDVgb+pyDRmc7B/gYSUfCCU3e8QPuHoKu1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/319] scsi: target: Validate REGISTER AND MOVE TransportID length
Date: Thu, 26 Nov 2026 15:36:42 +0100
Message-ID: <20261126144007.510670434@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 5d5913710c81eed6fa275b6a24773059d9dbfdfa ]

REGISTER AND MOVE has a 24-byte parameter-list header followed by a
TransportID.  A 24-byte parameter list with a zero TransportID length
passes the existing tid_len + 24 check, then the handler reads buf[24] for
the TransportID protocol identifier, one byte past the received parameter
list.

A TransportID is at least 24 bytes.  Reject shorter TransportIDs and
compare the declared length with the bytes following the header before
reading buf[24].

A malformed PR OUT sent through vhost-scsi triggered this read on a KASAN
kernel.  The command is now rejected with INVALID PARAMETER LIST before
buf[24] is accessed.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Link: https://patch.msgid.link/20261021094334.198599-1-physicalmtea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 94200c1553cae..524fe2c15bd0f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3215,10 +3215,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	if ((tid_len + 24) != cmd->data_length) {
-		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+	/* TransportID is at least 24 bytes. buf[24] is its first byte. */
+	if (tid_len < 24 ||
+	    tid_len != cmd->data_length - 24) {
+		pr_err("SPC-3 PR: Illegal tid_len: %u for data_length: %u\n",
+		       tid_len, cmd->data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
-- 
2.53.0



