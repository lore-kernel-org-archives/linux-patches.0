Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EF5257459;
	Tue,  8 Jul 2025 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993393; cv=none; b=EVpOlzpq1KGFWs7PRU2+/Cu7K+9vPjFo+diMw//jtr76eVSpRDa9AQdkGM9t4tOyqxQD99SP95sAAkS22FUraJA9MYy9QJ+wVtpjHT0VNezSZmRvenWLJ7DmYJq90RE4EpGxyJ3YQ5kL699bOFJKprRFsIwkP1XiElWXZcyIRR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993393; c=relaxed/simple;
	bh=nbreTs6wvx8DMGgukpugh0+3q22Yd2LkiKZWlssFMTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdCX6yL0tu3Sh3cttfTU5RDD7kaP7iJ1nYYCWf6V/PB1YDiQIxUZP6OuRfmywkzn5DObXOG3VyYXrW4gKmRg09tgy8QaILQRmiasiUWys2vKfO6jChgtxuwvjbvgSywaEtDFLVpVdPTt3VnJVuqHotnSEzwMYy+996xhC8pr3As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keP3g/Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keP3g/Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C2CC4CEED;
	Tue,  8 Jul 2025 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993393;
	bh=nbreTs6wvx8DMGgukpugh0+3q22Yd2LkiKZWlssFMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keP3g/Br5dOHgyUydSQcSNGYiRxMiaCcMzfFckkf4VWlP8wC3SftLAUPmsTeRdCft
	 twLhOZCJESXGViG5uaK/Mw/hMMjXV/vZ6v/lp9lyO57q6Eo1+eUZ1O2N6NN7Wd3ls9
	 cyXuI5UlDeZaeGjkHcIvZsqngwf+rYleEWYRPa9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 058/178] platform/mellanox: mlxbf-pmc: Fix duplicate event ID for CACHE_DATA1
Date: Tue,  8 Jul 2025 18:21:35 +0200
Message-ID: <20250708162238.196140471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 173bbec6693f3f3f00dac144f3aa0cd62fb60d33 ]

same ID (103) was assigned to both GDC_BANK0_G_RSE_PIPE_CACHE_DATA0
and GDC_BANK0_G_RSE_PIPE_CACHE_DATA1. This could lead to incorrect
event mapping.
Updated the ID to 104 to ensure uniqueness.

Fixes: 423c3361855c ("platform/mellanox: mlxbf-pmc: Add support for BlueField-3")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20250619060502.3594350-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index 36a00692347dc..771a24c397c12 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -713,7 +713,7 @@ static const struct mlxbf_pmc_events mlxbf_pmc_llt_events[] = {
 	{101, "GDC_BANK0_HIT_DCL_PARTIAL"},
 	{102, "GDC_BANK0_EVICT_DCL"},
 	{103, "GDC_BANK0_G_RSE_PIPE_CACHE_DATA0"},
-	{103, "GDC_BANK0_G_RSE_PIPE_CACHE_DATA1"},
+	{104, "GDC_BANK0_G_RSE_PIPE_CACHE_DATA1"},
 	{105, "GDC_BANK0_ARB_STRB"},
 	{106, "GDC_BANK0_ARB_WAIT"},
 	{107, "GDC_BANK0_GGA_STRB"},
-- 
2.39.5



