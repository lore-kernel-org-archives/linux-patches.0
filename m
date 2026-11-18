Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059583;
	b=sfZYgsnjzlDe7JWEs50wIjfXR4SYnrUmvC/A3vjEG4qcC21KIWuU5uVDGUW8NtObyEGb
	 M205YMhBduPrNNbMBY78fJtzh89PexkOZqrAk7uSH8hgcWKmaFMqQrqQ5WlhJbHazjidz
	 t+UISEJT5wc25R6KQI3NsAUmjW/9ZHYg0YKci3jjVuvzgA2A8Ty2YXK7IJUzeh17bGh9b
	 KGyO2VTkSccoFKWi+c4/HSmM//FJhdoM023yzifyPNyiZa6WCXjCkQ+YFXFKG7p8kDlpO
	 SlvVSyurIuPLU1jmsJTFDdFYg6RyDer5UkpyLT430gsuMJAvGo6WDBKsD76x+F6Y58g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSQz+BGb9EPkiO+r5WXoRwgThoBFNtHwhzT/HF9a1VQ=;
	b=kPfYs9JZbsjK5LPEUMnfptqykdUPlNpjlNbyCByUWwo1HQuJaGENAv1k/Q4mGO/oXxOb
	 BA80hFmfMnHVScK2OwX6HrNVNpokZZntVziYEgpx9JVgyOg3Us8OyjaJFLn3hblfkFTBF
	 CZzqmdCqJcVahukeYzz4ycbak7xW0gvrnwxwSuGw+LS0iEpxy5MblT6VgU0DeqEuFF9zA
	 rdEWV7twKqpxBePPVo6XELWf22GbsCEVLwoV1yUgbp8oINtwXodBnIPoymUhPLDi9b3sR
	 rgRHQ9BBh7v+d4Gn0PSL67ei7vpROBx/wHX9Z+LHXbwt9SjwZaEF/FHMudPRt4emSfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwW0KG88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BE5606A326;
	Thu, 19 Nov 2026 03:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwW0KG88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDC11F000C6;
	Thu, 19 Nov 2026 03:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059583;
	bh=RSQz+BGb9EPkiO+r5WXoRwgThoBFNtHwhzT/HF9a1VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwW0KG882ixOMA6DdxtIyEKA9F2ohh6S7g9gsy9K2HzBd5n/sjqUjRY6z9kiEZ3wJ
	 rCzecW00s1dD+d+L5Dk4Eae4QMJMrWBHwvXA5MsEIqDNRkvKGHp2eZ0Hx51l73RClH
	 dNiQh30TxdVrRb0psI4euy1pt9qoxtI9wXKsJbo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0886/1848] iommu/dma: Catch scatterlist length overflows
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118145953.575416443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted overflow handling to use an unsigned int cast comparison while preserving zero-on-failure returns ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 62dd195d88062..321c2f34de4dc 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -864,6 +864,8 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		sg_dma_len(s) = s_length;
 		s->offset -= s_iova_off;
 		s_length = iova_align(iovad, s_length + s_iova_off);
+		if (s_length != (unsigned int)s_length)
+			goto out_restore_sg;
 		s->length = s_length;
 
 		/*
@@ -880,7 +882,17 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
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
+			if (check_add_overflow(prev->length, pad_len, &new_prev_len))
+				goto out_restore_sg;
+
+			prev->length = new_prev_len;
 			iova_len += pad_len;
 		}
 
-- 
2.53.0



