Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D08130E42;
	Tue, 23 Jan 2024 00:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969083; cv=none; b=sCgf/Ug3oCp2EiHAUSkI6m5stq8Upjxw26tO7K31bo/1QtSqn4QNhVVKvaGtnZyy7L3sNaO0e6ZeCyCYjb/0ampDbJk2ml4smrFJoYVL1b0kpoHp1omaUKL9J2/v+cXDUrz/ofHCJtnTG1uUMwmtvzH/UW6cxtq5uAe1F24ClnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969083; c=relaxed/simple;
	bh=1oRhlLYzrUEcjPGTp4OGrVVstNrfgFaReER6AoKl124=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFGC0yiFl9DyEfbmDDxC6R+uvLyi0Q3D0N/Rv7tM607nKuD2E6zeWOvfErhlSaC21snH7zEIhFxoPEbCaMv7ts8fBB61Mr+rAg47Ex4HmxBDAWjj6sgx3KTcpIMMJM8w6P8NMIhmNYsH1M2koqpkBcGJ/FR9E6HssoWzMXmh9V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqWKg2g5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqWKg2g5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707ABC433C7;
	Tue, 23 Jan 2024 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969083;
	bh=1oRhlLYzrUEcjPGTp4OGrVVstNrfgFaReER6AoKl124=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqWKg2g5e24JSHxqTG7e5tXTkHU81V4Up4ieYwtWb5BD9Es5p5a6iIeU/rlz6AuhN
	 DzcaV5UeRKu0MTSGtocw5WAgAyk/tyrCHKgAPNWiWdmjRIJj0sGXFVA6F6bNmdptUX
	 YKNkmsmlVmol2d7kCCjDPDBQji7uf7F308Ri/NZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 011/641] drivers/perf: hisi: Fix some event id for HiSilicon UC pmu
Date: Mon, 22 Jan 2024 15:48:35 -0800
Message-ID: <20240122235818.470654848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 38bbef7240b8c5f2dc4493eec356e2efbf2da5f4 ]

Some event id of HiSilicon uncore UC PMU driver is incorrect, fix them.

Fixes: 312eca95e28d ("drivers/perf: hisi: Add support for HiSilicon UC PMU driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20231204110425.20354-1-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_uc_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c b/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
index 63da05e5831c..636fb79647c8 100644
--- a/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_uc_pmu.c
@@ -383,8 +383,8 @@ static struct attribute *hisi_uc_pmu_events_attr[] = {
 	HISI_PMU_EVENT_ATTR(cpu_rd,		0x10),
 	HISI_PMU_EVENT_ATTR(cpu_rd64,		0x17),
 	HISI_PMU_EVENT_ATTR(cpu_rs64,		0x19),
-	HISI_PMU_EVENT_ATTR(cpu_mru,		0x1a),
-	HISI_PMU_EVENT_ATTR(cycles,		0x9c),
+	HISI_PMU_EVENT_ATTR(cpu_mru,		0x1c),
+	HISI_PMU_EVENT_ATTR(cycles,		0x95),
 	HISI_PMU_EVENT_ATTR(spipe_hit,		0xb3),
 	HISI_PMU_EVENT_ATTR(hpipe_hit,		0xdb),
 	HISI_PMU_EVENT_ATTR(cring_rxdat_cnt,	0xfa),
-- 
2.43.0



