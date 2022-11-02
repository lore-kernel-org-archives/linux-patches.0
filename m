Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F17633;
	Wed,  2 Nov 2022 03:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112EBC433C1;
	Wed,  2 Nov 2022 03:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360582;
	bh=NmtEPomvZfIFPZ553zqynoPG4Y4Jaq1jhTqxrWj45YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otfuT/NqD791oNoFSCOniyeCcVm5jsoe5BkbryS6bfv5Xn1JOTNYrV3smrZP/AZm0
	 x4avlNOxhyBU52CdjsLY4jjSPGe3ja2eqQ2oz8HiQM0VxJbCBXVzBNOHAB70seko8y
	 B+4MyAW4GwB/cB8Nv432wSbEX1zxabGZ583UjAgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	llvm@lists.linux.dev,
	Nathan Huckleberry <nhuck@google.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/60] drm/msm: Fix return type of mdp4_lvds_connector_mode_valid
Date: Wed,  2 Nov 2022 03:34:57 +0100
Message-Id: <20221102022052.263342405@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 0b33a33bd15d5bab73b87152b220a8d0153a4587 ]

The mode_valid field in drm_connector_helper_funcs is expected to be of
type:
enum drm_mode_status (* mode_valid) (struct drm_connector *connector,
                                     struct drm_display_mode *mode);

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of mdp4_lvds_connector_mode_valid should be changed from
int to enum drm_mode_status.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Fixes: 3e87599b68e7 ("drm/msm/mdp4: add LVDS panel support")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/502878/
Link: https://lore.kernel.org/r/20220913205551.155128-1-nhuck@google.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
index e3b1c86b7aae..5c932b3fb831 100644
--- a/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
+++ b/drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c
@@ -71,8 +71,9 @@ static int mdp4_lvds_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+static enum drm_mode_status
+mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
 {
 	struct mdp4_lvds_connector *mdp4_lvds_connector =
 			to_mdp4_lvds_connector(connector);
-- 
2.35.1



