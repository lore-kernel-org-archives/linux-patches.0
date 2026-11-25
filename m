Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617830;
	b=puVv/F5ter0LcuilrEqvpOBLLKH5xYiVhpQqWHEe2rxAlZFpzR+OIbLPCes87dTgSctV
	 WCE9Ra4nyZd+0R42muHdILjTCCud2a56yGXe45Bt4JpyCWvKUgBheskNNWnhPXGuwN0Tw
	 7BQTA5m5CeeRCPr3nx99YyJSQFfe34maP30xiArJk127H7/grNDYENMdYK2N0vlW1w90+
	 5m7yB3b+1fSgZEo99nJ0VVFb4LPHWzwxKPVd8rNyswP2mjda1z8pJ6FXoXHuP+FukR6So
	 r0HGAm0x+3uNS84vAJfZy/txFdtqb+tCxo/aXkZsB9UNTCkaCVJIrQbkbpjaDt4Dfvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkW5xfrYLYuPq7GAb8flsRAB+nI38eM8M6API8invhQ=;
	b=nlSe/7XAjpmCQJPjXtTJIUNxLS42xRUTY7MWq4X996HqPQ3RbDTFOTtH8vnSByJYs7iE
	 RMFoCV7k2KDXtfOOVZsj+ERpqJcUECgj9JKd6md/aHU99fvpKZ25tjETU45du+sYSmM4V
	 pivF4aWGbL14CzOtBmTCQZoU/y65EMYVQtErlsYLvd7/e4DxZl74PIxOndLXXhsA0KDl6
	 ggQDu54gBg2x4TeXzLWSbo4EVMTO2QfgF0Gf1e/6mm5IghAXBQ2zJhOulZotOB/HpvwZK
	 ReLwEygbAGPVPURTbcfYVOCImuJyt9YD6TzpdA3YqpaB/0oE+K8PqPcEXqy6R0isx1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PFnLkr/U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951B8606A31E;
	Wed, 25 Nov 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFnLkr/U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54C21F000C4;
	Wed, 25 Nov 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617830;
	bh=RkW5xfrYLYuPq7GAb8flsRAB+nI38eM8M6API8invhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFnLkr/UmXadlX2+noMSoTb06ldzhuB22yn9HYhsQODdL+FHKLC7daiI4+w8LacJ3
	 GlqPH03LAMf2hf8EAaw3X+PWVK1BBbOK4e0u1Dsgm45TenjjOfEnNK+Uk7ZQBJzKVW
	 3cWqdQ0QoOlo21g9uz8ivd4Pu1LIt2aLEptVefIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0088/1005] scsi: target: Validate REGISTER AND MOVE TransportID length
Date: Wed, 25 Nov 2026 15:23:46 +0100
Message-ID: <20261125143823.802431572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 25b1bcacc0c8f..ca1a2802aa228 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3226,10 +3226,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
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



