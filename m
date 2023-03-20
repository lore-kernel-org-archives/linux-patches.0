Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068591C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B05EC4339E;
	Mon, 20 Mar 2023 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325259;
	bh=KDyJvZwQ6Jbby6eTS7ddgA4tlvl/NbCzVlisNvgM2vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFp8slA+AkJD8bPCbdEmFQ7O0XC5N5qQvnrdTMxi/N6oRCkXcyw8HVfGHBgd+nRi6
	 ixepnmD5h9Uc2KSpOLnZfsboVrNY6cKtNNw/5f/8k7EKFW1N+p4wKztWbPk4cMAFz1
	 bD6200UaAgVymBl7ZuDvJEAMrOR907C69L5To/JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Robert Foss <rfoss@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/198] drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc
Date: Mon, 20 Mar 2023 15:53:19 +0100
Message-Id: <20230320145510.109759326@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 0d3c9333d976af41d7dbc6bf4d9d2e95fbdf9c89 ]

The returned array size for input formats is set through
atomic_get_input_bus_fmts()'s 'num_input_fmts' argument, so use
'num_input_fmts' to represent the array size in the function's kdoc,
not 'num_output_fmts'.

Fixes: 91ea83306bfa ("drm/bridge: Fix the bridge kernel doc")
Fixes: f32df58acc68 ("drm/bridge: Add the necessary bits to support bus format negotiation")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230314055035.3731179-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_bridge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 6b65b0dfb4fb4..288c6feda5de2 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -447,11 +447,11 @@ struct drm_bridge_funcs {
 	 *
 	 * The returned array must be allocated with kmalloc() and will be
 	 * freed by the caller. If the allocation fails, NULL should be
-	 * returned. num_output_fmts must be set to the returned array size.
+	 * returned. num_input_fmts must be set to the returned array size.
 	 * Formats listed in the returned array should be listed in decreasing
 	 * preference order (the core will try all formats until it finds one
 	 * that works). When the format is not supported NULL should be
-	 * returned and num_output_fmts should be set to 0.
+	 * returned and num_input_fmts should be set to 0.
 	 *
 	 * This method is called on all elements of the bridge chain as part of
 	 * the bus format negotiation process that happens in
-- 
2.39.2



