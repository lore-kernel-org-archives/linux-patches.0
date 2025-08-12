Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0372E27781E;
	Tue, 12 Aug 2025 19:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025618; cv=none; b=mIbtXku8FHuy/Wpd8HWv4/Iw0O+273zRjb/DctOYEuop7ZtAHblMcn23bpeWQpCGVfLHGCVvsXbblKmyX+qWEg1+4IMuaY/SXpsPOHr+wg9Nph3sYnpYj0wDMMJa66E3kA2xxkzVgKRqQe86602YoR5JxiIIS2wchy05drOQKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025618; c=relaxed/simple;
	bh=2yLX7lVyqhJsQa/4Qsz+Ehn5PBgw3/kyWhuAWnXiQHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZOz1OxAsRbyuXqexKIXSM7xqNEBYP7PLw1byFgcxZiSVPb+VIVaRNdZ091tbj6FK6Ap5bxdtgRVaRAcflKOkwBYb3cBpqa7I2EpQmhzaGY5ND0Mxvl1nq4qRJrOHkImyVglsJsK7pc3mz92KijIpn3GrrBLrAZeCyl/1LSpEBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c91YYLdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c91YYLdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7145BC4CEF0;
	Tue, 12 Aug 2025 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025617;
	bh=2yLX7lVyqhJsQa/4Qsz+Ehn5PBgw3/kyWhuAWnXiQHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c91YYLdh5OtJGoLuydpVzwaHyHU+78vVh1FRjOcj93Imi7vF5x+zWHj7zYKnLQ+pJ
	 ZROSXjhcEk3Hhf+4UM0Ul0zk/BOrczeWe17+2RODDegKftFBlrPmHNcJ7p6+JPHwiF
	 b61BsgpApGuM59x4o9Uab/ZwS3RunPB+W9PV3sKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 095/480] drm/xe: Correct the rev value for the DVSEC entries
Date: Tue, 12 Aug 2025 19:45:03 +0200
Message-ID: <20250812174401.375262785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 0ba9e9cf76f2487654bc9bca38218780fa53030e ]

By definition, the Designated Vendor Specific Extended Capability
(DVSEC) revision should be 1.

Add the rev value to be correct.

Fixes: 0c45e76fcc62 ("drm/xe/vsec: Support BMG devices")
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250713172943.7335-3-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_vsec.c b/drivers/gpu/drm/xe/xe_vsec.c
index b378848d3b7b..1bf7e709e110 100644
--- a/drivers/gpu/drm/xe/xe_vsec.c
+++ b/drivers/gpu/drm/xe/xe_vsec.c
@@ -24,6 +24,7 @@
 #define BMG_DEVICE_ID 0xE2F8
 
 static struct intel_vsec_header bmg_telemetry = {
+	.rev = 1,
 	.length = 0x10,
 	.id = VSEC_ID_TELEMETRY,
 	.num_entries = 2,
@@ -33,6 +34,7 @@ static struct intel_vsec_header bmg_telemetry = {
 };
 
 static struct intel_vsec_header bmg_punit_crashlog = {
+	.rev = 1,
 	.length = 0x10,
 	.id = VSEC_ID_CRASHLOG,
 	.num_entries = 1,
@@ -42,6 +44,7 @@ static struct intel_vsec_header bmg_punit_crashlog = {
 };
 
 static struct intel_vsec_header bmg_oobmsm_crashlog = {
+	.rev = 1,
 	.length = 0x10,
 	.id = VSEC_ID_CRASHLOG,
 	.num_entries = 1,
-- 
2.39.5



