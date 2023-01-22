Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBB22590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A7FC433EF;
	Sun, 22 Jan 2023 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401282;
	bh=J7yFB0La2ozGGWC7ogy6DndcNLXZWgEjw1SCgKIn9wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3F/ZLekG70v6LTP8YYUqwKhuLE/sZRbzuDk6pXXdHrNE7yUmsFyL6YHfYNJCn1TG
	 rh/oupRYbFrqkLYVnmJM80rh/Jj9r9hQZ68PM8fVENWODuVB32D11Ks2F40/7v/Kwg
	 XrahTOjwykyuAIGlJuRjvUP3pbffY4pRmOffT7mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 179/193] drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.4
Date: Sun, 22 Jan 2023 16:05:08 +0100
Message-Id: <20230122150254.608883182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit f9caa237372b106b5e70ba1a4bfd4222eb79ec71 upstream.

Enable GFX IP v11.0.4 CG gate/ungate control.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5088,6 +5088,7 @@ static int gfx_v11_0_set_clockgating_sta
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 	        gfx_v11_0_update_gfx_clock_gating(adev,
 	                        state ==  AMD_CG_STATE_GATE);
 	        break;


