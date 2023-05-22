Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0358171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484CDC4339B;
	Mon, 22 May 2023 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784428;
	bh=N8KIOx4h5fPY9jpEtDCyoyEyqTJKZrwTfN1QFDAS1CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbEZbjjIa/6lC01OChslffoouoKQNc3PrPAHJamyc14REF/7qAJbvPEIZ4WdCcvbZ
	 mwy6i+8MT1/iqyazMqjihetDkN+mTumAlEzN6F2MXOTd+PstNwB1OQoi3r2KiRSygt
	 DKHQlugs57pO1BGH8wLwcRuSm6iL9zRGaeGj74IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Paul Hsieh <Paul.Hsieh@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 080/364] drm/amd/display: Correct DML calculation to follow HW SPEC
Date: Mon, 22 May 2023 20:06:25 +0100
Message-Id: <20230522190414.769590496@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 385c3e4c29e1d4ce8f68687a8c84621e4c0e0416 ]

[Why]
In 2560x1600@240p eDP panel, driver use lowest voltage level
to play 1080p video cause underflow. According to HW SPEC,
the senario should use high voltage level.

[How]
ChromaPre value is zero when bandwidth validation.
Correct ChromaPre calculation.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c  | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c  | 2 +-
 .../gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 899105da04335..111eb978520ac 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -4865,7 +4865,7 @@ void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							v->DETBufferSizeCThisState[k],
 							&v->UrgentBurstFactorCursorPre[k],
 							&v->UrgentBurstFactorLumaPre[k],
-							&v->UrgentBurstFactorChroma[k],
+							&v->UrgentBurstFactorChromaPre[k],
 							&v->NoUrgentLatencyHidingPre[k]);
 				}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index 536a636245950..bd674dc30df33 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -5191,7 +5191,7 @@ void dml31_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							v->DETBufferSizeCThisState[k],
 							&v->UrgentBurstFactorCursorPre[k],
 							&v->UrgentBurstFactorLumaPre[k],
-							&v->UrgentBurstFactorChroma[k],
+							&v->UrgentBurstFactorChromaPre[k],
 							&v->NotUrgentLatencyHidingPre[k]);
 				}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index daf3193701909..7eb2173b7691e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -5288,7 +5288,7 @@ void dml314_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_
 							v->DETBufferSizeCThisState[k],
 							&v->UrgentBurstFactorCursorPre[k],
 							&v->UrgentBurstFactorLumaPre[k],
-							&v->UrgentBurstFactorChroma[k],
+							&v->UrgentBurstFactorChromaPre[k],
 							&v->NotUrgentLatencyHidingPre[k]);
 				}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
index 02d99b6bfe5ec..705748a942952 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -3353,7 +3353,7 @@ void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 							/* Output */
 							&mode_lib->vba.UrgentBurstFactorCursorPre[k],
 							&mode_lib->vba.UrgentBurstFactorLumaPre[k],
-							&mode_lib->vba.UrgentBurstFactorChroma[k],
+							&mode_lib->vba.UrgentBurstFactorChromaPre[k],
 							&mode_lib->vba.NotUrgentLatencyHidingPre[k]);
 				}
 
-- 
2.39.2



