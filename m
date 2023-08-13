Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F09E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA40C433C8;
	Sun, 13 Aug 2023 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962494;
	bh=sQjGOjl7kF6XaOYv6bioQn84YpwQNUPhMIKSbsvm6m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcSm6/CGZvKnNnQlE8NKKKgLzA8WcWLUDaze7NRXaZv8mSTvMXDu31mSumU++vKgq
	 yzxQqMxKom8d22b1vLAkmATK0lgmShDiucbjyD9GurpvUDg2P+pOalUAImwGDeERfQ
	 EB17+dBnFr7MX2BJ0yAWs0UKBHubbZl6spZdLs3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 049/149] drm/amd/display: fix the build when DRM_AMD_DC_DCN is not set
Date: Sun, 13 Aug 2023 23:18:14 +0200
Message-ID: <20230813211720.286091573@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit 5ca9b33ece9aa048b6ec9411f054e1b781662327 upstream

Move the new callback outside of the guard.

Fixes: dc55b106ad47 ("drm/amd/display: Disable phantom OTG after enable for plane disable")
CC: Alvin Lee <Alvin.Lee2@amd.com>
CC: Alan Liu <HaoPing.Liu@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -184,8 +184,8 @@ struct timing_generator_funcs {
 	bool (*disable_crtc)(struct timing_generator *tg);
 #ifdef CONFIG_DRM_AMD_DC_DCN
 	void (*phantom_crtc_post_enable)(struct timing_generator *tg);
-	void (*disable_phantom_crtc)(struct timing_generator *tg);
 #endif
+	void (*disable_phantom_crtc)(struct timing_generator *tg);
 	bool (*immediate_disable_crtc)(struct timing_generator *tg);
 	bool (*is_counter_moving)(struct timing_generator *tg);
 	void (*get_position)(struct timing_generator *tg,


