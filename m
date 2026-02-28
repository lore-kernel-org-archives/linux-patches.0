Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C2D313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300986; cv=none; b=IzWehP8alZ3h5LLFPGVKviCGoe5tOxiLrUlUv+yxgD2UjexKIPQRLrREuh93xy3cq3W7vNCyNXpo+k0UvJbsrKgBNF4HBHRjmmCD+9HrKMGHxIJUy5uaJwsBg6qQZ0XnLM/3RFaQ3bYrSEwYkLlEsHBzwJUL1eyfG2GbP0/2fLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300986; c=relaxed/simple;
	bh=zQQDabQxX/Mj3pMOdIretiHOgmTgNC9y9Xg7vn5SY9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irR+ySMUti+IUgBjLz7lEZl3KEBojzVFvyRlXAlIdKy3DCRB4pDjTnGa48BWMXbYb2o88jIOLVY5Fu+9XxI5jrE7ROjPzJ1iMyHzM8bfy/7dDpydHk1zqv2s7MAUm2Rt/9EoI2UwxJbsscAXb+b+OJe15xcFA2l7PV5JOj3exKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kH5eDgx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kH5eDgx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBD4C116D0;
	Sat, 28 Feb 2026 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300986;
	bh=zQQDabQxX/Mj3pMOdIretiHOgmTgNC9y9Xg7vn5SY9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kH5eDgx+D9WR1+XDKuio/KDAC7STHJj9HDaVnr6zoin9EN/7hxb7BTAghbPoK0mFw
	 TFhGVNwEgkcYWTJWo5SvEC4o0NeywZ0johKdIpchq/XTzyxCOtXhh/dACF44J72cn9
	 cjYUrDFKd0U8v2zA2w9ERb/C+RiV2wSp1RO9U+lkqH21sOJR7mo1Dwq1EQGhNzIoXW
	 olVyS1aegktqXPK9v2T+cM7J0yYHJIi8rdNcXo1UKjIlCUgcVWxWGHzzUjUvikQYZH
	 DZ8R1ZW0Wes9cteD8tKoo4MllXN6FdYKmzQOyAiTYLVu7HZKD0Z1TGLrJ1IY8/iSg6
	 Tt01wsCAAb+Tw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jing Zhou <Jing.Zhou@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/752] drm/amd/display: Correct FIXED_VS Link Rate Toggle Condition
Date: Sat, 28 Feb 2026 12:37:07 -0500
Message-ID: <20260228174750.1542406-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jing Zhou <Jing.Zhou@amd.com>

[ Upstream commit 531fe6e0fee85a1bdb5b8223a706fff654ed0a61 ]

[WHY&HOW]
The condition is only perform toggle if FIXED_VS LTTPR reports
no IEEE OUI.
The literal "\x0,\x0,\x0" contains commas changes the
bytes being compared to {0x00,0x2C,0X00}.
The correct literal should be "\x00\x00\x00" without commas.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Jing Zhou <Jing.Zhou@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
index ce174ce5579c0..6a7c4a59ff4c7 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
@@ -271,7 +271,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 	rate = get_dpcd_link_rate(&lt_settings->link_settings);
 
 	// Only perform toggle if FIXED_VS LTTPR reports no IEEE OUI
-	if (memcmp("\x0,\x0,\x0", &link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
+	if (memcmp("\x00\x00\x00", &link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
 		/* Vendor specific: Toggle link rate */
 		toggle_rate = (rate == 0x6) ? 0xA : 0x6;
 
-- 
2.51.0

