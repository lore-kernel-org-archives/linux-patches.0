Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70C527781E;
	Tue, 12 Aug 2025 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025624; cv=none; b=QFe7iKZJO+4JU8ZBfLTlLnkM9Z4Y2KwUo5Q9jNzlPyS+TlgkBUS/gRkAj1m8TGL0YQxcvAJeinQGPZHBCZjkHEM7FgYypzhjEaD6YtxuO+pG1/80Um05rOVz1qmsta65jnyikzBnabOm0ZHfgtvlkF4BlEO8WFjHU4OxRzjZDDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025624; c=relaxed/simple;
	bh=zY6hR6BUumkBNoZ01J+Qp0NP+olAXxnoTwULMy7ptlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCJl9+4c5HCXRWLqe9L4ML1GH5OZqb3yG8jqDC8KmZBLjNsAUDexO4yLNPxsfw4lDD9vA+9x0YebFaIv0QEfevo5LUJD7D0+w+H2AdtvKtDNtCoVeCYiSxYsV1jE8EolqG6JtoOXZgVdvvaMQYYrj0A392om78duQ361OV4uWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiHe/oE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiHe/oE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44132C4CEF1;
	Tue, 12 Aug 2025 19:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025624;
	bh=zY6hR6BUumkBNoZ01J+Qp0NP+olAXxnoTwULMy7ptlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiHe/oE5L2VWvXd6gURsNCnw+CyqAPMOAgtVM/85X3VolbfB+Xdmo5h4VsbIxoGTV
	 3GcHH1VkYILT+HCFrfWdts/aLhJ5g6TeXwrkfd+06gIEeN193fGNH1LiO9xMyRZ4QV
	 RE29DX6tR07v3kprVsIbVls7Msc8xNxkuDKeOM+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 096/480] drm/xe: Correct BMG VSEC header sizing
Date: Tue, 12 Aug 2025 19:45:04 +0200
Message-ID: <20250812174401.416037889@linuxfoundation.org>
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

[ Upstream commit 5b27388171a18cf6842c700520086ec50194e858 ]

The intel_vsec_header information for the crashlog feature is
incorrect.

Update the VSEC header with correct sizing and count.

Since the crashlog entries are "merged" (num_entries = 2), the
separate capabilities entries must be merged as well.

Fixes: 0c45e76fcc62 ("drm/xe/vsec: Support BMG devices")
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250713172943.7335-4-michael.j.ruhl@intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vsec.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vsec.c b/drivers/gpu/drm/xe/xe_vsec.c
index 1bf7e709e110..56930ad42962 100644
--- a/drivers/gpu/drm/xe/xe_vsec.c
+++ b/drivers/gpu/drm/xe/xe_vsec.c
@@ -33,30 +33,19 @@ static struct intel_vsec_header bmg_telemetry = {
 	.offset = BMG_DISCOVERY_OFFSET,
 };
 
-static struct intel_vsec_header bmg_punit_crashlog = {
+static struct intel_vsec_header bmg_crashlog = {
 	.rev = 1,
 	.length = 0x10,
 	.id = VSEC_ID_CRASHLOG,
-	.num_entries = 1,
-	.entry_size = 4,
+	.num_entries = 2,
+	.entry_size = 6,
 	.tbir = 0,
 	.offset = BMG_DISCOVERY_OFFSET + 0x60,
 };
 
-static struct intel_vsec_header bmg_oobmsm_crashlog = {
-	.rev = 1,
-	.length = 0x10,
-	.id = VSEC_ID_CRASHLOG,
-	.num_entries = 1,
-	.entry_size = 4,
-	.tbir = 0,
-	.offset = BMG_DISCOVERY_OFFSET + 0x78,
-};
-
 static struct intel_vsec_header *bmg_capabilities[] = {
 	&bmg_telemetry,
-	&bmg_punit_crashlog,
-	&bmg_oobmsm_crashlog,
+	&bmg_crashlog,
 	NULL
 };
 
-- 
2.39.5



