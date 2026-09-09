Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC44577E36;
	Wed,  9 Sep 2026 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963022; cv=none; b=lyRIHR8EpMobek2N7Tlk0ae/BfZ75XRbseWJAS4NFcPB87PPlqx6J27O2sImif8+tZaWQl1hXQ25b4UXPFaMIy6SmTTt+hAO5VI9n4YYVCUQy8l/K1rAzMdGspllpGPYUgVeprfFyiWxrxnCNari2I9QhdKRubGZP3BWQ2FKF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963022; c=relaxed/simple;
	bh=+p9qt3tKsFW19YY6+lOluEmzVabJPmzMMEobInVj854=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uypwhAN6NSe6pXolikE0UXEfWfnRHl+f7j1Dy5M3Ge8XgYR/YHifdUUGmMohwGflis/PoDu3wPUGWoeWZdbBmER2h19+PwK3ZV3cTK1O1Fcy32wiF+49xIiBeQixTNFSFJOdPVGx1/fqEDKm6y2zHWnHD5VOrrifu1FyYzf9R9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0Kh08yh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0Kh08yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C91D1F00A3D;
	Wed,  9 Sep 2026 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963020;
	bh=ICw+1qlS5o/r4dV/oB1GpyG393sYIOXj+hNJl1qm7Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0Kh08yhFwXw468XsQHJBw/YrmsZj6RQymOG9V1uyPanrNyGCJxNyJOYhqH8M4SyL
	 BBpFtva6UzFzA/VSNKornmyu+UUiIa3qk4hhY3pf9hSU2yLhhTsQiWl3h6tMTb5zkS
	 6yymb7z2t9XfK+8dzDWC4bp3ffx1w/oPcU3THPO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 7.2 493/556] drm/amd/display: Set gpuvm min page size to 4K on dcn35/36
Date: Wed,  9 Sep 2026 15:42:53 +0200
Message-ID: <20260909134247.829095211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

commit 9ce3169430f1db035d491481086e2fae2552569c upstream.

[WHY]
Splash screen corruption on some 8K monitors.

[HOW]
Set GPUVM min page size to 4K for DCN35/36 to use the correct DML2
calculations, avoiding the corruption path observed during splash.

Fixes: 115009d11ccf ("drm/amd/display: Add DCN35 DML2 support")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2cbfb03dead5088a7bdfe2ce392a5caa3d1b3719)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2_0/dml2_translation_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml2_translation_helper.c
@@ -301,6 +301,7 @@ void dml2_init_socbb_params(struct dml2_
 		out->smn_latency_us = 2;
 		out->dispclk_dppclk_vco_speed_mhz = 3600;
 		out->pct_ideal_dram_bw_after_urgent_pixel_only = 65.0;
+		out->gpuvm_min_page_size_kbytes = 4;
 		break;
 
 


