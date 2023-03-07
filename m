Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E2BBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE17EC433EF;
	Tue,  7 Mar 2023 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210963;
	bh=WcbZCsJ8J9LuL+Q8UGYwDq2ZVr+W7WZOWdKqZrNvlh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRjAAX6RtrQwfTVSJUboCyhjqabQ1zhe8xembfDngOdS9h8EFTi9bDq3O4R+WVjHK
	 gHl1dlO96zFnQzTwzYqVV8lsNiY8qFzOoxUSGcSH9nmEj9Ju7RWn2y6yv+i8jsqmrg
	 y5vHW5nQ3ssoIiPkXRct95g+dUXNL4vw+sPJX2CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0710/1001] drm/drm_print: correct format problem
Date: Tue,  7 Mar 2023 17:58:02 +0100
Message-Id: <20230307170052.441210536@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit d987150b539271b0394f24c1c648d2846662adb4 ]

[why & how]
__drm_dbg() parameter set format is wrong and not aligned with the
format under CONFIG_DRM_USE_DYNAMIC_DEBUG is on. Fix it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_print.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index a44fb7ef257f6..094ded23534c7 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -521,7 +521,7 @@ __printf(1, 2)
 void __drm_err(const char *format, ...);
 
 #if !defined(CONFIG_DRM_USE_DYNAMIC_DEBUG)
-#define __drm_dbg(fmt, ...)		___drm_dbg(NULL, fmt, ##__VA_ARGS__)
+#define __drm_dbg(cat, fmt, ...)		___drm_dbg(NULL, cat, fmt, ##__VA_ARGS__)
 #else
 #define __drm_dbg(cat, fmt, ...)					\
 	_dynamic_func_call_cls(cat, fmt, ___drm_dbg,			\
-- 
2.39.2



