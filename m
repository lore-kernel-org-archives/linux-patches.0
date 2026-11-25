Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621052;
	b=a5XH8OanLVF5NOFY4J3387fJOiAFke8MDKrCCNihjEtE0rckkwxQL8D1xA9/peC9WrYR
	 sFVUaZv4y+PqWZZIwKpfO7CUrmL8R1zkb78tNdMug21pgBxc3b1OxMVx0agfjltzPZtKa
	 LlzWFPG3/fhYw2IORxoB+zAPfhQEn60c5BVckScJqn7LZOumqOnkYCqQEZayohFaZZTCq
	 1RlROGbM57EgM51E2Ngh6L43cKcZvUNj4CRXvzT6y0nmZSUN2nZmwWq5IJhrhD7pXcruB
	 jqjituNanPMR+6he4p+fm72If1+7raLger28Kvc4T+prH0rLKjuP0sF3RBY/sQ47Hng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXIehU4anHhhAwRcVUDcNPKNGLSJVwXQOV5DuT7pMJQ=;
	b=gpzP7EeoWWin/pzul15M+dUwsJWdOwLUGDzQGs4qwgrrJ9ERsy11bmTs7rSr2mkTuRn1
	 sJrvE7LVxtcqbxf6FQSI2t3FlUiZxKrek4KUeR6gPVB1GUC7zXxnPq6nVNo6ZeUF1SXse
	 9InSSq5DXQhdl3dAf67WzauDysQdIZuJelA+ez6Y7y18VCSMReXqccOxFKcaovyb9ONtp
	 z8CkHhKqiy3HCb1WIcTtUpNeK7e+Mp51/z0jXZNjkThIA5kGwoxnjQewTOmzqwxP2psjF
	 UkxwQ6z5CJiGN/UHTl2Pp4uUi1g/QOplcFVblFzeWSem6mCh/ApdTT/N2z3OJRaI6vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw3DqjOx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFB6606A32C;
	Wed, 25 Nov 2026 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw3DqjOx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A041F000CF;
	Wed, 25 Nov 2026 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621051;
	bh=DXIehU4anHhhAwRcVUDcNPKNGLSJVwXQOV5DuT7pMJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bw3DqjOxyFrjluDNaO2b89KBIeQ0ZSWqvAbwlt9xJIBs6wCptfJbcZacsWyGoHDcb
	 OOtGXitfJ8XXQ4buFMbNV1e/z26l1yGgGvHQj0vknXzmDLnQIHuY8fpIDs67RksauA
	 k4JGCjXfJsTtzHnCAv+rbOlIjHSKDJPpN0nKXmiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/990] scsi: target: Validate REGISTER AND MOVE TransportID length
Date: Wed, 25 Nov 2026 15:24:30 +0100
Message-ID: <20261125143824.501442680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index f18085d8345f5..24b240786f88a 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3220,10 +3220,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
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



