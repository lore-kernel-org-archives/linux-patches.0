Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7508476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3792C433D2;
	Tue, 28 Mar 2023 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015244;
	bh=K4dqawcdJ7Iq9ocUZNJ0MTYNikEE5mF91OiDpTB+z8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ef9Rad0oNgr0BYUGoVV+LnXb5VfG0WYJgfJqYRlIEMyY+kOFyF/R6J098XgrBeftC
	 ZRp6gy52mjxZ5b/OyK3JBvJesLRRdaB7tiealUb8XIxNKFeZKLc2FgrA5G0s65m/Ko
	 Jrbk4wJ5/erBMOhyznLhsioE6gcgsKp2Dmgli/Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 218/240] drm/amd/display: fix wrong index used in dccg32_set_dpstreamclk
Date: Tue, 28 Mar 2023 16:43:01 +0200
Message-Id: <20230328142628.791757481@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

commit 4c94e57c258cb7800aa5f3a9d9597d91291407a9 upstream.

[Why & How]
When merging commit 9af611f29034
("drm/amd/display: Fix DCN32 DPSTREAMCLK_CNTL programming"),
index change was not picked up.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Fixes: 9af611f29034 ("drm/amd/display: Fix DCN32 DPSTREAMCLK_CNTL programming")
Reviewed-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -271,8 +271,7 @@ static void dccg32_set_dpstreamclk(
 	dccg32_set_dtbclk_p_src(dccg, src, otg_inst);
 
 	/* enabled to select one of the DTBCLKs for pipe */
-	switch (otg_inst)
-	{
+	switch (dp_hpo_inst) {
 	case 0:
 		REG_UPDATE_2(DPSTREAMCLK_CNTL,
 			     DPSTREAMCLK0_EN,


