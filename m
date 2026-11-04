Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830876;
	b=jiQVHrHfaco0vx123OE/lf7VW0hfo4XEbmSnX3uJQ9UI/Ojf/tIDTx+Z90ZtXv+/Bthu
	 z/BfFecSl7xXBspM/UP9PC+uNtqzRgmKkDNFjVOuLbtFW7qixOwoGVxhbjuFp/6MIyF17
	 d+Y0dTEqW7pLI68hw7q1LWCZ5hpAazQZhotIe2QAOnoIUEQ6jKKq9kxAMJxXDzuFI4hEv
	 l4hS7rqGQ2WXNmy/kiFBceBceqwi7V//5Aaf9/rgyZtBUI4IMN6Cl0d12aa9nRfW9xDB/
	 DI2JAZzOPcUYLT6gMx5uQz1wJ/Lp2E45TlWlzzSaqrb8TRqnzL0lkvVZmrkL2/6RXuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xTsOAiEiLszpK6uf+Hd4nfCa4kbWfJs/0XYSzW9qDxY=;
	b=hp/jY9dNvrNqs0ZphKfnyM1a6NzQosXU6qbVK5u/oY9JkBAiaFvHcz1PMPogKQWrNGwJ
	 /LmW8JM1JNM/JaOPxW4czkK6brpQbKUiSFwE3DtXBYe6Xrghynj7RELuhl938P+c7LFNY
	 eEEKNX48+LUhVnbSk2kaggbZlkCjm7mLumMt7LZzH6JJQW/2abNhQgnnAMb3fwVblWKBg
	 xV311E0EsEkRRO56Ezk0lmEwZtIFPiHeaLIVrrFgR1o0i+Aq99zgrnCL83oIb3bE7IXRW
	 oh1mperR6TQq1H7rJej5Pg3fL1V7F9NaFCN4c3dWmb44pvT9JB4T3o6xPn8tw0Qr5Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AThC6Zm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993C8606E821;
	Wed,  4 Nov 2026 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AThC6Zm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F02F1F000C1;
	Wed,  4 Nov 2026 22:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830876;
	bh=xTsOAiEiLszpK6uf+Hd4nfCa4kbWfJs/0XYSzW9qDxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AThC6Zm2vfjIimWg0xmnpqBEoF/U4B4UQRiiqajFSj61sk43Mz7KC3z0YrpU7qBg6
	 ZRgoGIJ4Li4ukyhI4R7l0QkDb0GoppfjChpEVnSAfrR+wU5Y4EAujwOyw1DM513Pba
	 QuBAPd1JbR6pio3Gda4TCv5oH+7goKcoYduO5XdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0374/1005] nvmet: passthru: fix OOB reads when parsing ns id descriptor list
Date: Wed,  4 Nov 2026 16:01:47 -0500
Message-ID: <20261104211054.566081303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit bc7f75eba50012ed447654d8ce169ebaba695193 ]

nvmet_passthru_override_id_descs() walks a namespace identification
descriptor list populated from the underlying passthru controller's
Identify response, which is device reported. The loop advanced pos by
device controlled amounts (sizeof(*cur) + nidl) without checking that
the next descriptor header actually fits inside the buffer, so a
malicious device could push pos to within a few bytes of the buffer end
and cause cur->nidl, cur->nidt or the reserved field to be read past the
allocation.

Additionally, when a CSI descriptor lands exactly at the last valid
header offset, cur + 1 points one byte past the end of the buffer.
The unconditional memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN) could read
that out-of-bounds byte and copy it back to the initiator via
nvmet_copy_to_sgl(), leaking adjacent heap memory.

Bounds check both the descriptor header and the CSI value before
dereferencing them.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 0c361b1e35665..6d7469c94610e 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -53,13 +53,22 @@ static u16 nvmet_passthru_override_id_descs(struct nvmet_req *req)
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
+
 		if (cur->nidl == 0)
 			break;
+
 		if (cur->nidt == NVME_NIDT_CSI) {
+			if (pos + sizeof(*cur) + NVME_NIDT_CSI_LEN >
+						NVME_IDENTIFY_DATA_SIZE)
+				break;
+
 			memcpy(&csi, cur + 1, NVME_NIDT_CSI_LEN);
 			csi_seen = true;
 			break;
 		}
+
 		len = sizeof(struct nvme_ns_id_desc) + cur->nidl;
 	}
 
-- 
2.53.0



