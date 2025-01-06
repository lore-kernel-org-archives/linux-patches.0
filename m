Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA8782D98;
	Mon,  6 Jan 2025 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177329; cv=none; b=Tmg0g3bOiZZS1EqQxz3wH1RIpNr1IJu4u+tdbbbmu/5IS2lfE4VcrDBoZGB+kMPlx+XAZ0+X1dzir6vzVJlfaaqWDM/cL/1hXvNPOnd7+9Nwxft9dX4yzJfTgfKbTYgDaepbuFzxULTCHMfFvY2snhjwddbUEll3ADZyQCzdCxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177329; c=relaxed/simple;
	bh=Uxk52S8IERxXpimhUvg1d59iA2MHrdgM4PszYf0OvoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kADC0sbOYp7wuEHEWQwQN+i96GLTQqpmMjLHzexM8NNpHKJ2/rnVdsNdaRMCJV7Wps0Ghe7vhK7+fM331IVqH3Rd2ug7CPImyoxYky+Bg5IX6cqwMxM9SfUe8nmMBURnvnwQpu8gBLadXJ27dwmrvNJ3epA2wNEYfntDK9NYKUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQBXAg44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQBXAg44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5398C4CED2;
	Mon,  6 Jan 2025 15:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177329;
	bh=Uxk52S8IERxXpimhUvg1d59iA2MHrdgM4PszYf0OvoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQBXAg44DHzFVh4siy/XgRUEEpmlI7c1xkjKjyL2DGo0jGRqu1kCOnn79uAziFbCe
	 RtPvJfFEDTGCHuZUXfFkvlNOZtuA36/hTclfXUWZ3gi4cj+QG/pRY61QkVsUQ6obnr
	 Ne6k874n0vlw1lXutpwyHf9ljMRRu7F7WnQwrHoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/222] ACPI/IORT: Add PMCG platform information for HiSilicon HIP09A
Date: Mon,  6 Jan 2025 16:15:00 +0100
Message-ID: <20250106151154.230813605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qinxin Xia <xiaqinxin@huawei.com>

[ Upstream commit c2b46ae022704a2d845e59461fa24431ad627022 ]

HiSilicon HIP09A platforms using the same SMMU PMCG with HIP09
and thus suffers the same erratum. List them in the PMCG platform
information list without introducing a new SMMU PMCG Model.

Update the silicon-errata.rst as well.

Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Qinxin Xia <xiaqinxin@huawei.com>
Link: https://lore.kernel.org/r/20241205013331.1484017-1-xiaqinxin@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/arm64/silicon-errata.rst | 5 +++--
 drivers/acpi/arm64/iort.c                   | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index f4e6afd59630..8209c7a7c397 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -244,8 +244,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip08 SMMU PMCG | #162001800      | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
-| Hisilicon      | Hip{08,09,10,10C| #162001900      | N/A                         |
-|                | ,11} SMMU PMCG  |                 |                             |
+| Hisilicon      | Hip{08,09,09A,10| #162001900      | N/A                         |
+|                | ,10C,11}        |                 |                             |
+|                | SMMU PMCG       |                 |                             |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index b1f483845bc0..1a31106a14e4 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1712,6 +1712,8 @@ static struct acpi_platform_list pmcg_plat_info[] __initdata = {
 	/* HiSilicon Hip09 Platform */
 	{"HISI  ", "HIP09   ", 0, ACPI_SIG_IORT, greater_than_or_equal,
 	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
+	{"HISI  ", "HIP09A  ", 0, ACPI_SIG_IORT, greater_than_or_equal,
+	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
 	/* HiSilicon Hip10/11 Platform uses the same SMMU IP with Hip09 */
 	{"HISI  ", "HIP10   ", 0, ACPI_SIG_IORT, greater_than_or_equal,
 	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
-- 
2.39.5



