Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132271714B7;
	Tue,  8 Jul 2025 16:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992973; cv=none; b=YVj3tlziIOSB6ii2ixyUTbcXRmbJx87eOylsTISVWttjjh48/Bawl9hAexUvF3+lsc66dpwdheKulSeavt4A19Wlc6m7pGWh+luWDgx7dMeK7ezjaMpW8rde11Bf4X3RMO5apEMSKxVV114tfV4+CIcre3PeOW2UzKgjl3p6M+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992973; c=relaxed/simple;
	bh=HVdk4Ia2q/1TtSYpfgvnCenY5BQ6pdcrOAs1tf+I5Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCXfqZ3SK4z0XmKUqTEmFJRUbSR//OtAwnJ5vxq1QrFK/8vujntEGTomWepZ1+By2/Gar8DqLIJ+ODp5x4B/ePZA5nvFGvs61gY0nMRBpuVlgdg/KbGuvtVKTxYOVJ/PDTiS89sUY5pROlHjEuMMWpp8D1O8cCuawUPFMkky6A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dft+13kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dft+13kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903CBC4CEED;
	Tue,  8 Jul 2025 16:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992973;
	bh=HVdk4Ia2q/1TtSYpfgvnCenY5BQ6pdcrOAs1tf+I5Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dft+13kwejvnJxAQ60J/l2n4tli9U/eYuY3W6OxmpiP4WTAYhvphr7qTBfG6xVKjT
	 MOc1iwMlRiJyx0O2bCY/WnfEgFwgYmWSM4H6NbcMirZzIU3pNzUDPoVH/x+KVpNFtE
	 gSLdi7J+o/lZ7i9V10nPa56/lGE39u11NCgq+Hrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/232] remoteproc: k3: Call of_node_put(rmem_np) only once in three functions
Date: Tue,  8 Jul 2025 18:22:21 +0200
Message-ID: <20250708162245.235536713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit a36d9f96d1cf7c0308bf091e810bec06ce492c3d ]

An of_node_put(rmem_np) call was immediately used after a pointer check
for a of_reserved_mem_lookup() call in three function implementations.
Thus call such a function only once instead directly before the checks.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Link: https://lore.kernel.org/r/c46b06f9-72b1-420b-9dce-a392b982140e@web.de
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 701177511abd ("remoteproc: k3-r5: Refactor sequential core power up/down operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_dsp_remoteproc.c | 6 ++----
 drivers/remoteproc/ti_k3_m4_remoteproc.c  | 6 ++----
 drivers/remoteproc/ti_k3_r5_remoteproc.c  | 3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_dsp_remoteproc.c b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
index 2ae0655ddf1d2..73be3d2167914 100644
--- a/drivers/remoteproc/ti_k3_dsp_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_dsp_remoteproc.c
@@ -568,11 +568,9 @@ static int k3_dsp_reserved_mem_init(struct k3_dsp_rproc *kproc)
 			return -EINVAL;
 
 		rmem = of_reserved_mem_lookup(rmem_np);
-		if (!rmem) {
-			of_node_put(rmem_np);
-			return -EINVAL;
-		}
 		of_node_put(rmem_np);
+		if (!rmem)
+			return -EINVAL;
 
 		kproc->rmem[i].bus_addr = rmem->base;
 		/* 64-bit address regions currently not supported */
diff --git a/drivers/remoteproc/ti_k3_m4_remoteproc.c b/drivers/remoteproc/ti_k3_m4_remoteproc.c
index fba6e393635e3..6cd50b16a8e82 100644
--- a/drivers/remoteproc/ti_k3_m4_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_m4_remoteproc.c
@@ -433,11 +433,9 @@ static int k3_m4_reserved_mem_init(struct k3_m4_rproc *kproc)
 			return -EINVAL;
 
 		rmem = of_reserved_mem_lookup(rmem_np);
-		if (!rmem) {
-			of_node_put(rmem_np);
-			return -EINVAL;
-		}
 		of_node_put(rmem_np);
+		if (!rmem)
+			return -EINVAL;
 
 		kproc->rmem[i].bus_addr = rmem->base;
 		/* 64-bit address regions currently not supported */
diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index 4894461aa65f3..6cbe74486ebd4 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -993,12 +993,11 @@ static int k3_r5_reserved_mem_init(struct k3_r5_rproc *kproc)
 		}
 
 		rmem = of_reserved_mem_lookup(rmem_np);
+		of_node_put(rmem_np);
 		if (!rmem) {
-			of_node_put(rmem_np);
 			ret = -EINVAL;
 			goto unmap_rmem;
 		}
-		of_node_put(rmem_np);
 
 		kproc->rmem[i].bus_addr = rmem->base;
 		/*
-- 
2.39.5



