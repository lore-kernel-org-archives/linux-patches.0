Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034126;
	b=TFASAURS4QEhvOpUZCod0dB0LmAGE1JnN1ae1P+CT+P3T4aIaP1f5l0UQjaumMhvu1Uq
	 fFChSUgc+QTAiuQtsqpsjeTo5rVLXH5oCoQBSaW1o0BdNkY0MVhLiTO30MR5UTUJXihE6
	 GTU40EbfRXUxFQLYTWS3sk69l2ARdlxaDqFGr6TyywBq0Xt1mbtUNd5cJg38jkwYiIdiI
	 8N/DUPLCuYjGl/oxLYYgUqVw8T8qjXSuegZuqNiycsiSAvZgfIw4wWYkYRRFr0kUZ5nUw
	 4wwf/t/5K6Ks0tXdbhnvKHbypLxZ8JaS/TniImrL3RXZ58Frjn69SgHo5PGG46X5aNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sGjFq2Fha7LvTDCIh9ZM8zxt2zj37m+ZAp++MorT0RI=;
	b=dSoPNqZQxsrD2GmHw4/a0xyy8DhBwz7xVcN3uzHTVo4RCGDxodG33fuLH6EnVExTmWJ/
	 /TwQQBqCqNwuuGdspEX1c6LlkBP2tSdcIxhiIMn5mPRwjZYqIEGpuRYBgkJF76YAoHJM8
	 njNot2DNa9NXGv+pR91lMmIg/825HmbTuo2X+W7G5dp4AYK6T78M5Z4crd8/dUvIgZJPe
	 +jEGAWiBzBSAnvhqARF1DNgixdvhHsx4Fc9SmxvUNVwTnnKR8/F67Y6Q2/8wT+3rpgA9j
	 HS+NLQW3UEvZWm7dHNJa06B8X6n9cRi37VzFbfN/+8AofTqxZz+80zkgS+Hp4BfAV9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhnM+xK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04B7606A325;
	Wed, 18 Nov 2026 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhnM+xK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1951F000C9;
	Wed, 18 Nov 2026 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034126;
	bh=sGjFq2Fha7LvTDCIh9ZM8zxt2zj37m+ZAp++MorT0RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhnM+xK9h4l0roJOkXGXxg5E5z00z0CfZPr0h1t0lfuHkDbLH/CPlSYn/u+BY5qTW
	 Gvh6CAnfDGTF/9d376ab6UaSoINNnDy3kQtz9WH99aGU5SZjDveKQPuvLdH1Z7+l3P
	 /bJwtwyBpiaMxuA+mpaY5cMK6YpZ4PgkXyKjO1x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0260/3318] nvmet: passthru: fix OOB reads when parsing ns id descriptor list
Date: Wed, 18 Nov 2026 15:14:42 +0100
Message-ID: <20261118150323.169394729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 05febc5e6b21d..590eb36950628 100644
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



