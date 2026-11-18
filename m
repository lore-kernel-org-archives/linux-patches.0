Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036417;
	b=4RACGUedHFiys8z71xImSxqZwJq8HYG64ZJg7kAqFen6GUNhefLxmvQYBmH7MhnvbOF/
	 qkzqHQb3EiWwU/tOfdKF4cc6RDZt4ULN4daeAyp/yZe6nV5BWgd+gdSM6qxAWOkuAp64Z
	 1VMbua0gm9dMdMWbcq/0GPOJz0K+tNhdc9zYv7TNKy7LHBl2hpKdBOl69pKL2tL2Z3ZTY
	 ueYjdn8ZQojDFqHaUwu6uAtYbl9xozkaeX8wm7d4lpmmnxCxUyXO091G4Y0Shf02rrvqQ
	 gwbXJLE3X+qtbfhG26MxxmBTv5kJeykN+A+x+LQIvjXkSYLqldjxkudSV7o4H/Vje+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ozmQ3ZnW1tHXu5vGMsxIsIO1zxY4nkxb1GzB3d6u6kM=;
	b=LVdza9JO3PN4w/FRhmunumhcRneKizAdiGTZk6DCq1FxSkBlrDK37oikvg1lV5PdkAEh
	 NeGvMcKB47y+GhSFQOHEmGEtAYq2UicR6ElcLu7cboz6eauX51K/4Qx17CpfHl7KixbMA
	 nIfW02XmjvtGKOLt0fpiviSE1jwh/n4AQpPzsrPph/epFzNlfmiX+45unVVscIQcqYcZ5
	 OUVeQyr17jAXjwtB9g5pqEgdMCy+gN59sTnxtBps8fqtGBarFf4zoT6B8BUmt/iQPK0vY
	 AP7fl8xwotfSTci+gPpVSzvZuK2I3d2wkaTCOWIqbgbF52aqo6SHGWw9SbzI5NiJi3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLFzv2oa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34145606A31C;
	Wed, 18 Nov 2026 21:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLFzv2oa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DB31F000C4;
	Wed, 18 Nov 2026 21:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036417;
	bh=ozmQ3ZnW1tHXu5vGMsxIsIO1zxY4nkxb1GzB3d6u6kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLFzv2oaS5tWubC5Fz8nUNlf3e/aBWdQfw9xvctp3OlX8y02/4s3oc8vM7wXCJBVo
	 8FvhKUBJt010x+nublaGkPf1Dnw3LLG77ajfDFLYWTGXRiK2kdVwUgrzDyuNn40E1/
	 oM6v/WNn6lQv5jjgVu1Qspob74XrP0HlH8AcvWq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1051/3318] iommu/dma: Catch scatterlist length overflows
Date: Wed, 18 Nov 2026 15:27:53 +0100
Message-ID: <20261118150351.458338755@linuxfoundation.org>
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

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 1c8f6308e557f32412e9d4678b3f029f47f6d9aa ]

It is possible, when a very large mapping uses only one
scatterlist, that padding overflows scatterlist's length field.
This results in:
 1) silently wrapping the value
 2) smaller than desired mappings produced by iommu_map_sg
 3) leaving mapped bytes in memory (no iommu_unmap)

Address this issue by adding overflow detection for scatterlist
length field.

Fixes: 809eac54cdd6 ("iommu/dma: Implement scatterlist segment merging")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 69c6d904cc6e8..1d93e1a058f0e 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1305,6 +1305,11 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		sg_dma_len(s) = s_length;
 		s->offset -= s_iova_off;
 		s_length = iova_align(iovad, s_length + s_iova_off);
+		if (overflows_type(s_length, s->length)) {
+			ret = -EOVERFLOW;
+
+			goto out_restore_sg;
+		}
 		s->length = s_length;
 
 		/*
@@ -1321,7 +1326,20 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		 *   time through here (i.e. before it has a meaningful value).
 		 */
 		if (pad_len && pad_len < s_length - 1) {
-			prev->length += pad_len;
+			unsigned int new_prev_len;
+
+			/*
+			 * For large mappings spanning multiple GBs we
+			 * may not be able to fit all needed padding into
+			 * sg->length.
+			 */
+			if (check_add_overflow(prev->length, pad_len, &new_prev_len)) {
+				ret = -EOVERFLOW;
+
+				goto out_restore_sg;
+			}
+
+			prev->length = new_prev_len;
 			iova_len += pad_len;
 		}
 
-- 
2.53.0



