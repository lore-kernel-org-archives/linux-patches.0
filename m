Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826EC78B61;
	Tue, 27 Feb 2024 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041132; cv=none; b=MaFqew++QgWmYkiCcsuBtIrMSxVIoOGJv6DikBSK3BunWA8S4mWF2txJ98C0Dc08p7YlWvq1B4McD5ZJy56OGRV2XEhEjTK8iKCNKfRHs59UaBvjgpAjoCCr6WJFZvAdNa9mlv0GZDhpc4LXRGw6S3R6j/Vq+eZ7QBF0wgJAU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041132; c=relaxed/simple;
	bh=3kv5iGh7VeNF1fX1gZarobEV7x/dm8+krnPdExuy8I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpK72396OVax9xqwYqCJzGd6CphMwk9EDpDt/TUI1lDJd0wJUPlaSqXBOvbPKC3wlGTRdkI/aowB5f6a2VIE2IUuibpQ+eehwnxbWBqIiDGyCsedk8ceOIY6vYVMNXFESBARV9nRrkENuMJKEvZohKSm71+TuZhtE+g6lI+WtaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSNM36bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSNM36bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0800EC433F1;
	Tue, 27 Feb 2024 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041132;
	bh=3kv5iGh7VeNF1fX1gZarobEV7x/dm8+krnPdExuy8I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSNM36btnvAM7ToS5iPd7o5FWP9cIV/46EhVLYiRnUWU2C9y0wx9rGhQu1BDsGeu8
	 Lzxuztf5luAaYnq5AuZbiGyYc1QJ7O20SvV8W0iioDjr5nDBx/JQaVzJoqd0FieC4j
	 x8ia97xanQTqdiOv/3WyY4fRix7xrYfwwRlh5rPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 231/334] Revert "drm/amd/display: increased min_dcfclk_mhz and min_fclk_mhz"
Date: Tue, 27 Feb 2024 14:21:29 +0100
Message-ID: <20240227131638.275835594@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

commit a538dabf772c169641e151834e161e241802ab33 upstream.

[why]:
This reverts commit 2ff33c759a4247c84ec0b7815f1f223e155ba82a.

The commit caused corruption when running some applications in fullscreen

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2719,7 +2719,7 @@ static int build_synthetic_soc_states(bo
 	struct _vcs_dpi_voltage_scaling_st entry = {0};
 	struct clk_limit_table_entry max_clk_data = {0};
 
-	unsigned int min_dcfclk_mhz = 399, min_fclk_mhz = 599;
+	unsigned int min_dcfclk_mhz = 199, min_fclk_mhz = 299;
 
 	static const unsigned int num_dcfclk_stas = 5;
 	unsigned int dcfclk_sta_targets[DC__VOLTAGE_STATES] = {199, 615, 906, 1324, 1564};


