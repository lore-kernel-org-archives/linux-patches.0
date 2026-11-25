Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624209;
	b=pV2L+ToDjCcpug4HS/JT3fQ4OlLvRXmBUv5w3BrXOvhvMz8txKHp/WUf4WjIvDdBxPGM
	 PuUlwbmrmt+0HsDxTSRazUj5zJEZ63jz++imUxvVCnB50bXAdoS8EeD1N601RDPiNl93Z
	 n/wmonrSLpRCHTLlVKww5ahlHdmDDe1y0BAB1IS+bQJRrunGr9aeGvjAlbUXqqpdw8VnS
	 wZEZup07aIMpHj3KY8mq6dD+pw9b+bhb89l8HSXLKe9QcHKwV+EZxrdLFzTe5sn8zvrJ6
	 cHFeoWn7Nyts4pQQ/w6QobRj1ClrvRiK0qWccS/3vuTzYryQEnoCP6jXCUsqqs41vRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJgzcAxYQYrLatHIV0obplKB+VMPv/7gEpjCxN7RMls=;
	b=J08Mdz++JD2DehGs8AA+Mb8o5Ljrnv+gxHbEKfUppR5pezUDao+BatYaaSOBINjmHsT2
	 rdaPwE3UBWq0y2thYT3GklQfg7nTGItF66+1faqgb4G5u6S5Citrm9TXczxqlZrVdMO6d
	 1Wu4UF5rcgrPKyXgI4X33CWT825xo3OTpi9DpucYbR4hTFRcZeno4v7MMTkfUrWBEfh7V
	 rsH2JS4Vo8lBPi2swZ8t1Dd/wB7VqHpd6yzOvhSk9RZJjFxPevaourXUHx0Z6H9a4h014
	 6sPkbfrhpqpHvt1/32pM8hTB84jV+0Dv+HvCp51BcZ9q5g152wX9Ybl995aPFqLgF6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa+1R3eq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D5606A680;
	Wed, 25 Nov 2026 16:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qa+1R3eq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40A51F000C0;
	Wed, 25 Nov 2026 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624208;
	bh=zJgzcAxYQYrLatHIV0obplKB+VMPv/7gEpjCxN7RMls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qa+1R3eqrS8TRxrQLAns7fCIJloBowfuAmHmKuEGFFUQfNj1sjAhGmAGVWkUFBEFr
	 5w0RMhpG8qlTziTkmfVqleEKzHmZQ+GNdncu2sZi7sjQCf6OnB0w/cuETKL/82y+e/
	 LsdWVmZ2meMyNg4rkQfM1PEIssyRBhgU3TgjM4D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/816] scsi: target: Validate REGISTER AND MOVE TransportID length
Date: Wed, 25 Nov 2026 15:27:10 +0100
Message-ID: <20261125143851.118643092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index c7f16c2ccf1e4..25df74b2e3559 100644
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



