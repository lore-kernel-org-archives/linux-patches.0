Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7553D9FC;
	Wed, 30 Sep 2026 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790074; cv=none; b=ijPcq609HyGzF/RUO+msNyxAeXcu9FhEwuO4YAy976cIoeQ96hl0l75hAQWnHF+1mlTr9ZWYJiYUcJJIZw88bADxm3cfGA/Zedd7iKHm2PB0JRXL8rpBR5UDLgd/o0VD2K4GogSWg3Lrmm4T83SBOHDEcQ7whvKiz93tCv3sJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790074; c=relaxed/simple;
	bh=7bWwBJcyiWbbpryp8I5LsrT3v9fFl0h9uafH8p3nFQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRT/w/aOcoGenuKwrS/xFdQQmddwoEdWGnj5N/+LIQCK3JeJoeopRlupypP0ZjmErDhKhVXJf2Sj6daNeYD5WzbVvSYt6r8aQd4BX3BEwOs6tIjQpea9EE1vg1rs7XOTrpnITJxj4WXasWxH66d+/SLFEXJcTBVYPdKKW/DA/to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyhUdPYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyhUdPYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921261F000FF;
	Wed, 30 Sep 2026 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790073;
	bh=cm0SyyJcfMN+o3VW6eQoGsE2xsWqR8+p9XUHLW4z80E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyhUdPYTmohVdV9EqwNzdwXpavPNc1ucnF8RboTisloyQZ0ayfSEBaj1MwEq4kCC9
	 sQ1YDoAl90lN5qMbVoD9tK5MRvUn0JjDvi4uBNv6HUoj0UTgraBMPnEo3GXSxDYK2W
	 x+7F4z/njbY3c4jZS0oTIKOKwyvgxpoIRyov+yVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 702/877] drm/amd/display: Set gpuvm min page size to 4K on dcn35/36
Date: Wed, 30 Sep 2026 17:26:53 +0200
Message-ID: <20260930152429.831481019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 9ce3169430f1db035d491481086e2fae2552569c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -297,6 +297,7 @@ void dml2_init_socbb_params(struct dml2_
 		out->smn_latency_us = 2;
 		out->dispclk_dppclk_vco_speed_mhz = 3600;
 		out->pct_ideal_dram_bw_after_urgent_pixel_only = 65.0;
+		out->gpuvm_min_page_size_kbytes = 4;
 		break;
 
 	case dml_project_dcn401:


