Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB499531AF3;
	Wed, 23 Sep 2026 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174176; cv=none; b=j0Ugdu4Cjvf3/hVp7chpXOWSSTEUtwJqkGhg8Cr5lRBIpQWEii80mOS5mNrx0JqvdgoYKql2DFRDkV4eAOjRFGT5hdgh9EMTuLw729qvCK1PSnB0MZUnVhPdt1QWeuCu9JzoE9sE6RS7LaCQZ7knkgEwT3qjx8+wfLoGdX7GDt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174176; c=relaxed/simple;
	bh=yXnwGxi2Qyw9JCnn03z/2keYnOWDlsC2BV+7/yI3HkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usEKh4jQAYZAlTkw/6NZABwR/cUJl8IA1Ig6d4OERgJreHSQyFcYnwuWOD9PT0/qxVmjk+MSjKYnfE/0qL0mw5msLwe9JM2U3/h0mKODqBWIPRID/LYVvJQu8A5PY4BrVpOZAqCstuKOzW39Kd3jaw3S2t4WoEVoDpN5jQMb5vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXQhZyK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXQhZyK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBEF1F00893;
	Wed, 23 Sep 2026 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174175;
	bh=QluXSK4KjzTZ/XXszIi6N0m6U79uEz34eoaVppL1Sa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXQhZyK0soGC1LADj1cp3jhgkCzho3Dea5zAnIhOlw8hJir+w7LcX6x5eaR2/Qdpp
	 wu11Cy0KhHnSXcjdzYJt5wvkEYptrHkDU9TvXStjTi6AkIt1WO9aawlXnhzfm74nQ/
	 9AjF4uaVHiqTw/0Qrr1rlbSomtvGwRJEb031aTcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/398] power: sequencing: Fix build issue with COMPILE_TEST
Date: Wed, 23 Sep 2026 16:01:47 +0200
Message-ID: <20260923140644.286619854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 3b54dbd119805361695cb50ca6a875f4c7518b74 ]

The POWER_SEQUENCING_TH1520_GPU driver depends on
(ARCH_THEAD && AUXILIARY_BUS) || COMPILE_TEST. This means when
COMPILE_TEST=y and ARCH_THEAD is not set, the driver can still be
built even though it requires AUXILIARY_BUS, which may not be
selected in that configuration, leading to a build failure.

Fix this by dropping AUXILIARY_BUS from the dependency and instead
selecting it directly, so the dependency is satisfied regardless of
whether COMPILE_TEST or ARCH_THEAD is enabled.

Fixes: 1a7312b93ab0 ("power: sequencing: extend build coverage with COMPILE_TEST=y")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260826122742.153643-3-biju.das.jz@bp.renesas.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/Kconfig b/drivers/power/sequencing/Kconfig
index 280f92beb5d0e..a33b705415c49 100644
--- a/drivers/power/sequencing/Kconfig
+++ b/drivers/power/sequencing/Kconfig
@@ -29,7 +29,8 @@ config POWER_SEQUENCING_QCOM_WCN
 
 config POWER_SEQUENCING_TH1520_GPU
 	tristate "T-HEAD TH1520 GPU power sequencing driver"
-	depends on (ARCH_THEAD && AUXILIARY_BUS) || COMPILE_TEST
+	depends on ARCH_THEAD || COMPILE_TEST
+	select AUXILIARY_BUS
 	help
 	  Say Y here to enable the power sequencing driver for the TH1520 SoC
 	  GPU. This driver handles the complex clock and reset sequence
-- 
2.53.0



