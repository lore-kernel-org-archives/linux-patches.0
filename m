Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDBD366542;
	Wed, 20 May 2026 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295795; cv=none; b=Hz2JEo1woUxOOAX6/InYwEZ68YDeRcxratqXhwN1G/9E0k/8fU0F8ZnaXOXn3BstTrIw+gBjJpAP8ErcXlzZNL7eWT1JqOi+KFcbsyct5RPInBbqe5u6ZTdAYjqlfl517PqzvmDXI5i8EO6xKfcVqsGAvfvehIJ9AJ6JHosR/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295795; c=relaxed/simple;
	bh=TfJJvGyhRsqN/rPf36Cm7wFX1Sy8PqGkQNNsQSidCuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvbP2RArUBetidhsRXk8+A4fulqRjiOGM5k4Qun4rVsVK9hwLkeWypYs0Kc8eQ8hTEDACSK2FHyXpz06sjWbXS8JL1sS/oI4pD0KDfPauleNICzEYgJ9qu/jKrWNO7ufBI/5AB5P9UspV4MQKNnp4cgFAZqGVgSrfemxknenqMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4pP9d06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4pP9d06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9BC1F000E9;
	Wed, 20 May 2026 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295792;
	bh=2VJfe0Ec41lboINjqccO0QqN8EUq14RiSiZliX4Y6b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4pP9d06GhrBD/oz1WxLNxWATyjnvplt5HCwKCq6K25uRlL/v5Re4eb8c5NQD80ZT
	 NEiglA/UvUdEhoNF53EXqq58XXkXCuMA9ORoVx4Bm1CQ3VK5qc30ax8pqwoBVk7WDD
	 yYuGY6jfsbfj3x0EiMIAkSoHVW8GkYYBVmOUdOm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0553/1146] soc/tegra: pmc: Add kerneldoc for reboot notifier
Date: Wed, 20 May 2026 18:13:23 +0200
Message-ID: <20260520162200.694822814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 21669619e4c17a5f097e0415bc64b1d400c54fcb ]

Commit 48b7f802fb78 ("soc/tegra: pmc: Embed reboot notifier in PMC
context") added the reboot_notifier structure to the PMC SoC structure
but did not update the kerneldoc accordingly. Add this missing kerneldoc
description to fix this.

Fixes: 48b7f802fb78 ("soc/tegra: pmc: Embed reboot notifier in PMC context")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index a1a2966512d1a..8268a41c471a9 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -437,6 +437,7 @@ struct tegra_pmc_soc {
  * @wake_sw_status_map: Bitmap to hold raw status of wakes without mask
  * @wake_cntrl_level_map: Bitmap to hold wake levels to be programmed in
  *     cntrl register associated with each wake during system suspend.
+ * @reboot_notifier: PMC reboot notifier handler
  * @syscore: syscore suspend/resume callbacks
  */
 struct tegra_pmc {
-- 
2.53.0



