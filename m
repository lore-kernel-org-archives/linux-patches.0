Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043482;
	b=tzWG0tqnm3s6LXhK7VTdaU/90YX91XGvXduz+177S5gmVVNFxVkQyEbh8NuIHH3owXSc
	 lJ+WHGyl26wTeGIPiObxE0wXpf2/CiClZqy5hbXJ5Z9PH8evT1FnIBsWgo2auljZrSLPg
	 lQdYZFpVt0Ka53EjWZPE1ZwG93EhjVXfDp5E2YH9FytSQORLoVr5g9y/mgQvWFYPFD8j0
	 P5tpYY266wc+ajAOLvX5mCYAGEdOb8IgSfIfmc1QiVqUCxXNVhkY1NJpmzaeaDtI1i8tm
	 7YAtDCJV0bZHh+YlZvR9U1NsDO8lf7z2wXF1gh7TYz25oFM/Y13GFVCMHFlprmuKPKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWWiUkZSCyHpFVAt+du9uyZ5RtG97w1KsmaQeTniEJU=;
	b=osIUVq/06FLFWREGGWeTRRc3uTSK4jhYCWL1ALOtNK/wdSMpFEEREOSy90ddw3v6H859
	 2BCo7s08hn9u4JCe/6Q0r/7GnmFcxIShU932k6avWP+qx7SOZcW12ieRv7Ok45c4V9XQx
	 uGtaIubrulNkueWO/UHQ27p+oRiRqfbPHNq/nZ2O+hn53w5Wnx/dm1xAsUAIWlPRmh3qI
	 7LQRYgPiJ7XgAR8ipvY/ctgfBZh84OYDfp4qyIYatN6+YTMYvr9BCIncmdKTtgl9lK2jm
	 InN9gmGFl9JjAX0V1pgcp0jLvvgCka6QoZ1e7hDOOiHAbkY/Pxh6bc7Iepd9EEgbnRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im6NhBN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AB606A338;
	Wed, 18 Nov 2026 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im6NhBN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1F71F000C4;
	Wed, 18 Nov 2026 23:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043482;
	bh=rWWiUkZSCyHpFVAt+du9uyZ5RtG97w1KsmaQeTniEJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im6NhBN1payExvN/mhpL8O/rmTToh98w7tUKNnASarrWn3WSDdc9iWgldi3CkQYQH
	 XHpAcyBlKWF8dOViGmAbdpg8FO9sGTcz4quMq69+rY/PjNleVLnxAx/6so4VXlTV/G
	 JwPNjv59YeUm8czzQ83Ps4W07CP5RTJnsF+pKYP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0225/2857] nvmet: passthru: fix OOB reads when parsing ns id descriptor list
Date: Wed, 18 Nov 2026 15:20:59 +0100
Message-ID: <20261118150209.560174413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 917e8b1f8a226..b52036f0bf989 100644
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



