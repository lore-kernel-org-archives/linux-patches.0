Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3165835CB76;
	Tue,  6 Jan 2026 17:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721645; cv=none; b=VRBzP0BSGV2crj8RAUC2jU/0aExtrx/gyslO6h9odl1bzhSQb+hMZNIiA1SI4u+KgvkPP/70xhafVwSAIjBcMmpikLf5m4z/jeZMp/hrnie1JQXs/+rCyqX5xGbBrmFicpGgBBaHzVExwCHCZN4i/257LngPk9qgieqwCbnltUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721645; c=relaxed/simple;
	bh=KSMn+YEtoWChojJlKFlWaeJaeXuKa5MuHGkRHpVfymQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hvqc1csP94h786UY4bHJzgK+Vfua3d+U0rGzeLkCny89NGnjOm+2gtOCjsOvzv8TkZgMdMGZZ33IeBHwir8bxlyL4sZ0MTUdwy5TNdz2a+JlpMs/NDTByCOj2oihDr9kEunVZdNPoGMJgEUToG/vkNbUzIxw73nJjXiQZdPucjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHl3W3kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHl3W3kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9DAC116C6;
	Tue,  6 Jan 2026 17:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721644;
	bh=KSMn+YEtoWChojJlKFlWaeJaeXuKa5MuHGkRHpVfymQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHl3W3kf/7ALY1jA0AeokeGj5pGxUYPfmRmE0kM4UygzA4rG9t2cgrvU/H8VjHne9
	 3VSuAdFxb2HDiZQNBujezls6IgpXZ01+3plb/zp9DrP2GNZUGWH22uJAvkVM/69fgR
	 6GK7nribfFdtpn7L32pEpYg7Qv+JXwijwoyNBQew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/312] platform/mellanox: mlxbf-pmc: Remove trailing whitespaces from event names
Date: Tue,  6 Jan 2026 18:01:44 +0100
Message-ID: <20260106170548.947335282@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit f13bce715d1600698310a4a7832f6a52499d5395 ]

Some event names have trailing whitespaces at the end which causes programming
of counters using the name for these specific events to fail and hence need to
be removed.

Fixes: 423c3361855c ("platform/mellanox: mlxbf-pmc: Add support for BlueField-3")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://patch.msgid.link/065cbae0717dcc1169681c4dbb1a6e050b8574b3.1766059953.git.shravankr@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 16a2fd9fdd9b..5ec1ad471696 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -801,18 +801,18 @@ static const struct mlxbf_pmc_events mlxbf_pmc_llt_miss_events[] = {
 	{11, "GDC_MISS_MACHINE_CHI_TXDAT"},
 	{12, "GDC_MISS_MACHINE_CHI_RXDAT"},
 	{13, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_0"},
-	{14, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_1 "},
+	{14, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_1"},
 	{15, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_2"},
-	{16, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_3 "},
-	{17, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_0 "},
-	{18, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_1 "},
-	{19, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_2 "},
-	{20, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_3 "},
+	{16, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC0_3"},
+	{17, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_0"},
+	{18, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_1"},
+	{19, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_2"},
+	{20, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC1_3"},
 	{21, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE0_0"},
 	{22, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE0_1"},
 	{23, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE0_2"},
 	{24, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE0_3"},
-	{25, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE1_0 "},
+	{25, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE1_0"},
 	{26, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE1_1"},
 	{27, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE1_2"},
 	{28, "GDC_MISS_MACHINE_G_FIFO_FF_EXEC_DONE1_3"},
-- 
2.51.0



