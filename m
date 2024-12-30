Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7115E8B;
	Mon, 30 Dec 2024 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574223; cv=none; b=oApRtMxIQhSU0TNgx0/ja1bS62e4g/HkNrxXfFo/tkozM19abtvaPd2SlUmOD/3SNRxrnn8L0rU0VO25YKuiyW59nUjU97Ie3QLHlfcZ6N9BZg5pbh0pr3hH7CUzhLIOJ+REgc2Mb+01vJVhaSYuUFH8SErIjcKblTVI2U045HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574223; c=relaxed/simple;
	bh=2o4jRgaBR/O2rrc4Liq+JQXlFHTJyvd2AfDPTn5ptLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOHfm/qCEGmsuoUu0EH04AFT3ftF9Cwk5ZJzjdwBhRSfQHrSTHwhGCyNRnlyFhxloiSwohx2scVMuhxmKnePNXeb7HiW311v/+at9YFLKuikC9oxHu2BF6yCdyaUcpMDencAp4WU++YPFupD/WmRtad2yo4OL9XHcBN0nojTZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9xuaQj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9xuaQj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F7CC4CED0;
	Mon, 30 Dec 2024 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574222;
	bh=2o4jRgaBR/O2rrc4Liq+JQXlFHTJyvd2AfDPTn5ptLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9xuaQj7nrwZoY+iY5PHyBYKruudQxIWZe4lVhzxu6onOXmsU0bQWsOAuPwFaSZU5
	 E1UvV8DbuAJokxR6X659HXv5mHqJh7rO6pzpx2z6/iwLndmczf56VuJwykgRDLeh7o
	 h/LB1TyXQNoWS2w8rDAT33J0pFkeXeB+cMD7gFNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/114] ACPI/IORT: Add PMCG platform information for HiSilicon HIP09A
Date: Mon, 30 Dec 2024 16:43:09 +0100
Message-ID: <20241230154220.864943684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 77db10e944f0..b42fea07c5ce 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -255,8 +255,9 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip08 SMMU PMCG | #162001800      | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
-| Hisilicon      | Hip{08,09,10,10C| #162001900      | N/A                         |
-|                | ,11} SMMU PMCG  |                 |                             |
+| Hisilicon      | Hip{08,09,09A,10| #162001900      | N/A                         |
+|                | ,10C,11}        |                 |                             |
+|                | SMMU PMCG       |                 |                             |
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip09           | #162100801      | HISILICON_ERRATUM_162100801 |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 4c745a26226b..bf3be532e089 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1703,6 +1703,8 @@ static struct acpi_platform_list pmcg_plat_info[] __initdata = {
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



