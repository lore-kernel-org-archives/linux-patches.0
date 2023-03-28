Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ACD8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256E3C433D2;
	Tue, 28 Mar 2023 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015552;
	bh=gW8uhhCpLmrfuDx7bKrO3SEtcopxPKe54PQDpo7KqIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKZlhkQ2mP4gpjf5o2VqcINcSwWIGb9zMzVKl8N51RSsLVyDsG840O+OX0qOdZ9sZ
	 RxK5eT8N+abL+f81VCX9KnowmaI2o8/M7u+O6Jz6mQZ4MsxKsUTglk1N40Whroj3mi
	 fmTYf6WCc2ZhYhLTNhIUY+cYnCCkkcJdYJ0Ge1QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/224] drm/amd/display: Set dcn32 caps.seamless_odm
Date: Tue, 28 Mar 2023 16:41:27 +0200
Message-Id: <20230328142621.050691631@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit f9537b1fa7fb51c2162bc15ce469cbbf1ca0fbfe ]

[Why & How]
seamless_odm set was not picked up while
merging commit 2d017189e2b3 ("drm/amd/display:
Blank eDP on enable drv if odm enabled")

Fixes: 2d017189e2b3 ("drm/amd/display: Blank eDP on enable drv if odm enabled")
Reviewed-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 26fc5cad7a770..a942e2812183a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -2142,6 +2142,7 @@ static bool dcn32_resource_construct(
 	dc->caps.edp_dsc_support = true;
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
+	dc->caps.seamless_odm = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
-- 
2.39.2



