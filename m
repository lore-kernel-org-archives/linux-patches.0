Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61757136E09;
	Mon,  6 Jan 2025 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177327; cv=none; b=jsGmJfPG7p7FD9ZxivmZDEfe2sXMbESbamCOu+iggMJc4WPjoxD4Za2Yiyhl5qWQE8lF73c6eZfkBz0hYE0bBLuI9WQQ+mk3V5Wdteq6RUlYckzP/xGFohf3W3A3uQxYn2t8M4GFwlLDexM4yIA9EQMoEmc2AiUXAvR+NtHTTZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177327; c=relaxed/simple;
	bh=tpIlHtk+IeP8jDdKiEQerdir9FFoFEoPSpcJIFdy51M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTAKScszuZnoIxw08o7/hFvJveO9+jGXlGG3qfCjfVofSojruLuKReJO+JqHu7TGnU/OKdCmFzy1bPCb5rDefGqIv3Xs6Z0F1O49D3P2Fe3h9VHBnRmyL2cdjQ7VvBPUjN7TCbeIjqZk20XZ5IfkbrwIPrHkOElCaFlxLLqV6Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYRKg/st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYRKg/st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A7C4CED2;
	Mon,  6 Jan 2025 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177326;
	bh=tpIlHtk+IeP8jDdKiEQerdir9FFoFEoPSpcJIFdy51M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYRKg/st1nKYIh9i/28x4TcauLfkKqG9O2A6tC2RTvSsLHWmmjlATMyRpC5Yb7oYx
	 Z/HgMsbNhWN1K63/zq6Kj5tZ3uo9j3EjOImyEqo08HMsn2Gpv/rBCg7sRKyH6TBt0N
	 RITvOx19usKCBESooMqLeO+7E53ScZ2XEWfladEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/222] ACPI/IORT: Add PMCG platform information for HiSilicon HIP10/11
Date: Mon,  6 Jan 2025 16:14:59 +0100
Message-ID: <20250106151154.192460458@linuxfoundation.org>
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit f3b78b470f28bb2a3a40e88bdf5c6de6a35a9b76 ]

HiSilicon HIP10/11 platforms using the same SMMU PMCG with HIP09
and thus suffers the same erratum. List them in the PMCG platform
information list without introducing a new SMMU PMCG Model.

Update the silicon-errata.rst as well.

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240731092658.11012-1-yangyicong@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: c2b46ae02270 ("ACPI/IORT: Add PMCG platform information for HiSilicon HIP09A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/arm64/silicon-errata.rst | 4 ++--
 drivers/acpi/arm64/iort.c                   | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 3cf806733083..f4e6afd59630 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -244,8 +244,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip08 SMMU PMCG | #162001800      | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
-| Hisilicon      | Hip08 SMMU PMCG | #162001900      | N/A                         |
-|                | Hip09 SMMU PMCG |                 |                             |
+| Hisilicon      | Hip{08,09,10,10C| #162001900      | N/A                         |
+|                | ,11} SMMU PMCG  |                 |                             |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 6496ff5a6ba2..b1f483845bc0 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1712,6 +1712,13 @@ static struct acpi_platform_list pmcg_plat_info[] __initdata = {
 	/* HiSilicon Hip09 Platform */
 	{"HISI  ", "HIP09   ", 0, ACPI_SIG_IORT, greater_than_or_equal,
 	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
+	/* HiSilicon Hip10/11 Platform uses the same SMMU IP with Hip09 */
+	{"HISI  ", "HIP10   ", 0, ACPI_SIG_IORT, greater_than_or_equal,
+	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
+	{"HISI  ", "HIP10C  ", 0, ACPI_SIG_IORT, greater_than_or_equal,
+	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
+	{"HISI  ", "HIP11   ", 0, ACPI_SIG_IORT, greater_than_or_equal,
+	 "Erratum #162001900", IORT_SMMU_V3_PMCG_HISI_HIP09},
 	{ }
 };
 
-- 
2.39.5



