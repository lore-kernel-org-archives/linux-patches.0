Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548A413D896;
	Tue, 23 Jul 2024 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760030; cv=none; b=uyrsjC0RxTJ6Hluf1hhtVGLnzvyJtsEwmCCVJbPi37dEqfx07akmRJRvWYsWkvTsEStGL+e/ZHRClCjV99tpBWdZA0dMg5AGSOCe932ZspRD5wzz/xe+EUHnCEGbKeJ5ricnfZ9Ym9W1fKowXq9QY9/pmIwcUF62RtpzKsUhJWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760030; c=relaxed/simple;
	bh=JfiT0Sg8s71c7gNZR4MUQiRAk0duQRq0P329BR0Wgus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkuKhqFtsAXSID4NRZ54HBIX7KXdP6zudIMueGkOZAwz70gS09r7FfaWUx9tO6wWRbVcRcjlzMWoN33RJAY/V5hznwfE8ULhM1KgnRjvUm+PfgKdxG4iBInUl99ojcRRq0Ohcbd7MgdJbORK57nvCKAuqpXnlADy+pCfYajgsuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ueoq/cuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ueoq/cuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4974C4AF0A;
	Tue, 23 Jul 2024 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760030;
	bh=JfiT0Sg8s71c7gNZR4MUQiRAk0duQRq0P329BR0Wgus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ueoq/cuhDWOx5ZHrw2EUefg+xoS6cuWecM3NKd8rzPkT35WHrQhI5LyPfwzPuihdY
	 4veDDOLg1C8LPMlKkENOBhJvQBCZSnpv/fP42uFwXGpXWZpmIbTj3caAF+Qvn0498G
	 lF16a4FLYdAmriDsVU3aY7CYkdRniLeyJdepl7o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 080/163] drm/amd/display: Change dram_clock_latency to 34us for dcn351
Date: Tue, 23 Jul 2024 20:23:29 +0200
Message-ID: <20240723180146.560987665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Miess <daniel.miess@amd.com>

[ Upstream commit c60e20f13c27662de36cd5538d6299760780db52 ]

[Why]
Intermittent underflow observed when using 4k144 display on
dcn351

[How]
Update dram_clock_change_latency_us from 11.72us to 34us

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
index b3ffab77cf889..40ca38dd1b23e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c
@@ -215,7 +215,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_51_soc = {
 	.urgent_latency_pixel_data_only_us = 4.0,
 	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,
 	.urgent_latency_vm_data_only_us = 4.0,
-	.dram_clock_change_latency_us = 11.72,
+	.dram_clock_change_latency_us = 34,
 	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
-- 
2.43.0



