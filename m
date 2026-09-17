Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7A14CDDE1;
	Thu, 17 Sep 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658396; cv=none; b=K+emgST81qM4j2NkQU9jyvXKPAZe069nowkz0kIP1IeXvp3Hdi4I/+0ljfj5rTgQEJgM45UFkuLlrATOAtShJT7X60GPrnGnxFN7CUF5lzxD+lMQWcOw6BtT1n7S2yvm18AjLkV/L0G+Ejkg+3L+Sa2M31T7vOa3Mudb0LmGt84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658396; c=relaxed/simple;
	bh=501sC074RY09vP3KBoYu92iyps64b06cwvn5BGonrKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnf4JXjKJ+7J9XT/E2ahqMqt5oL87/q1DbNbEaZTvvnYdcwUePkURAIta6Dny6cMqdzAXgGN7GDYni0fW1UqK01toPPaEQ3WO0ZIZwZqYMcP4wfOqpqh5Tj3Mu/5/kWo2nYFrvaxg1hZTEemUoIlyzyLsTzlXT38y5hnfuTZFJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLAy/cZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLAy/cZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4E1F000FF;
	Thu, 17 Sep 2026 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658390;
	bh=qqJ6EFj/1fKp7XOlNhem8pQmE71KLv/IfzeKizPndTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLAy/cZ4Kt/oAuhhXJjVxAPm8fJ1Xt2vyGD90s3DK0hbQf2imHpTuVyJnCUgk6C9k
	 +hHsjuuxyMbuYw1Kk/cFg7UpVInIe1Ilutemj3yCZZGx9i2kSLKI4X8+ihTDzKfxKO
	 mK5eEeRN/1sJiVJDkhN+rQm4mgDAMzDwJAWDT/l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0001/1250] drm/amd/display: Set gpuvm min page size to 4K on dcn35/36
Date: Thu, 17 Sep 2026 15:56:36 +0100
Message-ID: <20260917151551.952151416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
index 3b866e876bf4d..9fea55fddded4 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -299,6 +299,7 @@ void dml2_init_socbb_params(struct dml2_context *dml2, const struct dc *in_dc, s
 		out->smn_latency_us = 2;
 		out->dispclk_dppclk_vco_speed_mhz = 3600;
 		out->pct_ideal_dram_bw_after_urgent_pixel_only = 65.0;
+		out->gpuvm_min_page_size_kbytes = 4;
 		break;
 
 	case dml_project_dcn401:
-- 
2.53.0



