Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16112612D7;
	Tue, 20 Feb 2024 21:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463485; cv=none; b=QAqvdeKwcfpskjpNmzwJUpgfAymZ6C7WBXQl9If0KGdjh+suT5sC2Zg4ogV79ujYXJ2rtxNHDQ0TgWsY4JLUYXAj1AcRwUL6ThuNIFvFMXQoHzdQppBIAJ0an+MXRDtdHdOGl2xK61zhtS5GVQRnUJfqRhLhFZ2JzZoggDDPxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463485; c=relaxed/simple;
	bh=MKHsbAXXOmVAv5V8dBB174BcQeWtqLIJ6quTnM6+FBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qb4D8V5/nmSSATxoaI+W7YPu1d+DSKgktVs3xZjiZvTsewIi/749uw3+OCXastqYXYbjzwy6ywQ4uUGRp1/ljZ9RuFliKeojt9tcYYGYFhySfciQ4ZGtkdpMgh8zDWtO0l/G2NEyaiXo46shN/4G3qbXi6KzxMCG3NikN72fZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7IF6222; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7IF6222"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81102C433F1;
	Tue, 20 Feb 2024 21:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463485;
	bh=MKHsbAXXOmVAv5V8dBB174BcQeWtqLIJ6quTnM6+FBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7IF6222oCpPOeHp1ERk7TSpgyGPJ2BZvokP9DCP13U62PuA4OB826/OxDZir9Dp1
	 xx/5ISbvWf6rUZU5eeX12zSc4odaVI+e0b+J6Msr2vONjAvOjrQyN3QlxP8DDLKdbs
	 LVlh8LZ8YaOPmDfoQ9I0D4sp8skLkFibpzDWnZKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hojin Nam <hj96.nam@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/331] perf: CXL: fix mismatched cpmu event opcode
Date: Tue, 20 Feb 2024 21:52:25 +0100
Message-ID: <20240220205638.501795477@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



