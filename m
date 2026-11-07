Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060950;
	b=weXUbI5x+s0DUF3nClxKWVXCpF8tEf0zTNMcdnandyQJKYmUyiIl3BAsI+pxoyJ7kYm0
	 JcLrO+vD/tEyl2Ddc+9012EcFoHqhHbb33GKX/Io2HkThYUkPjafPdFqyWJ4NYgdstUEI
	 SFpAeSlMjkpEHxiyAN+QkDIyM/BnkpjPTdqk+RHFNrg00ak+5aDonb5YcDA7z8s4hPETx
	 qWIDFNs51gSfbRt4sOjkLEk7LvJMH3kc98Kg5CgAUAwTpGY0/0UcHEk15AEJgXyjkt1t6
	 wrDQsi13vL98N3yGYgdAntfR99gvLuCvtk58j9a6H1BeSzWkCNB0V9lT+a/z3rXk4Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DcyFiDWRPbmYtmQSe0CM9mooz21TZSzYjjWRqJwkHoU=;
	b=A84CIi8tkrm219zYrkBz0GZ7/Xh7AnZRQpB8FbDe6Jt2SEY2qZS3bDUsiXfzzoG8sbg3
	 ASo6d1mG7p8o9382CKHRW5CU2r3yBg3cnuzMFMLBJZD8jqho0pvdmhZLRjMPNdAxwTXjg
	 hyDP63XZfQhaZymmtPmZl2g704n+fiGEO/ORrO9JqQzaPU4y7Xt6D0Xi0ZW++aSNuAwid
	 wUan77cWo1LuLrwg9ahmuWcQpm3EMAlzAlI3tNk6p2q763ANaj6PUsg9b3SBZz4grIkoq
	 aQFyZqiJeqON+QEtJGQ5uXD0NceggjKtLsoUw2bdEpBJBJVaQQ/StQEFeVrIPm1rOmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmaJSylb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25492606D80B;
	Sat,  7 Nov 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmaJSylb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C625A1F0089F;
	Sat,  7 Nov 2026 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060950;
	bh=DcyFiDWRPbmYtmQSe0CM9mooz21TZSzYjjWRqJwkHoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmaJSylb9jw+euOnU7q1EY7saddW1oWATwF4fhLLdkZTjFdz+IzpfoFFWdtpPyLgD
	 8w8IoUSfLowOZQEG/seCF6OHI+/FF2ni2GBg/36yoPfIkcWg8c19pt3akcLsxKdHRD
	 nPeRvYpPQ3i2CVdfbm9yB+CWJos6I2enTa6JTK58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0309/1536] nvmet: passthru: fix OOB reads when parsing ns id descriptor list
Date: Sat,  7 Nov 2026 08:38:45 -0500
Message-ID: <20261107135006.398116607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 0f9b280c438d9..67964b632b492 100644
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



