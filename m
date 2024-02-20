Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD1152E1C;
	Tue, 20 Feb 2024 21:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464477; cv=none; b=i9YokXhQeUh8TcCOSNctORH+qXpqctgB/vIIAsGTi8CRXa1DkFeNEgsfNL6A5DgsAo+VvJN/lDqxUucVL3cfyn0uHLm80JXJpPJA9OfTduB2GPXTbLIKfY8P+zcz1A7vyFst98GhZ4drovm0wh/o3cU+ZGBL+g8FeITh4ES7ObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464477; c=relaxed/simple;
	bh=hdQsFzSQPk/Jc6Adi5kb1s7Jp8uyhLgeg4rTIjaQ+FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFM8QempkW4wrKlFi5HAMJ4A2Yj2EzW/GxRpBX9YidAY8ZXPZsKEjxYloeMfCkz4iY/n3wvmXiP0ddfcmN6/thpjtwhL38KXdjKRQ34rnfaA2rKpUFZ5ILfxYOz0kaQ2ZGi4OIOCJMiqjio7uieoT9Egq7JevqN9whWN4ZqrrEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1ZpKSr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1ZpKSr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6316EC433C7;
	Tue, 20 Feb 2024 21:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464477;
	bh=hdQsFzSQPk/Jc6Adi5kb1s7Jp8uyhLgeg4rTIjaQ+FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1ZpKSr8bCSav+B5qCkZ5qHMJoE5XEVv+LYRB1l1DQ3g5DA5IDDZDLPGoJ6/o2PRH
	 VfI1VAdwKk3OWyZkE699y+KcqhAkXM1mkf5pKzRg1mwBMMCHIjgK3VIbUnCp40wi9o
	 7lJlpE1AmbnZC0YhP6bvM+wLl653QxqYiLR0J1pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hojin Nam <hj96.nam@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 038/309] perf: CXL: fix mismatched cpmu event opcode
Date: Tue, 20 Feb 2024 21:53:17 +0100
Message-ID: <20240220205634.385209165@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hojin Nam <hj96.nam@samsung.com>

[ Upstream commit 719da04f2d1285922abca72b074fb6fa75d464ea ]

S2M NDR BI-ConflictAck opcode is described as 4 in the CXL
r3.0 3.3.9 Table 3.43. However, it is defined as 3 in macro definition.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Signed-off-by: Hojin Nam <hj96.nam@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240208013415epcms2p2904187c8a863f4d0d2adc980fb91a2dc@epcms2p2
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 365d964b0f6a..bc0d414a6aff 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -419,7 +419,7 @@ static struct attribute *cxl_pmu_event_attrs[] = {
 	CXL_PMU_EVENT_CXL_ATTR(s2m_ndr_cmp,			CXL_PMU_GID_S2M_NDR, BIT(0)),
 	CXL_PMU_EVENT_CXL_ATTR(s2m_ndr_cmps,			CXL_PMU_GID_S2M_NDR, BIT(1)),
 	CXL_PMU_EVENT_CXL_ATTR(s2m_ndr_cmpe,			CXL_PMU_GID_S2M_NDR, BIT(2)),
-	CXL_PMU_EVENT_CXL_ATTR(s2m_ndr_biconflictack,		CXL_PMU_GID_S2M_NDR, BIT(3)),
+	CXL_PMU_EVENT_CXL_ATTR(s2m_ndr_biconflictack,		CXL_PMU_GID_S2M_NDR, BIT(4)),
 	/* CXL rev 3.0 Table 3-46 S2M DRS opcodes */
 	CXL_PMU_EVENT_CXL_ATTR(s2m_drs_memdata,			CXL_PMU_GID_S2M_DRS, BIT(0)),
 	CXL_PMU_EVENT_CXL_ATTR(s2m_drs_memdatanxm,		CXL_PMU_GID_S2M_DRS, BIT(1)),
-- 
2.43.0



