Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CB92590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D415CC433EF;
	Sun, 22 Jan 2023 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401264;
	bh=ac0kwI25XGuwsXPun+cGqGasSHTdxqyTANL/TF9nn0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PQtAQGg7/xc5NU5vwLErOX318os3E/5dLVUY9ShxA9VKsfkaUdoKd1R0my8niotR
	 9fZ4qvlT4EE7sC183pDp9hx4KeuOTo0rOyUbcD6DDH950aaXlgGWqoj/T2BvI7PrGe
	 wLsuCx3V78CO2vwvTCctL37ePbGvJRMrHCnXJN6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 173/193] drm/amdgpu/soc21: add mode2 asic reset for SMU IP v13.0.11
Date: Sun, 22 Jan 2023 16:05:02 +0100
Message-Id: <20230122150254.327582511@linuxfoundation.org>
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

commit 18ad18853cf2d8b94cef0112ba94f7a7535a9e89 upstream.

Set the default reset method to mode2 for SMU IP v13.0.11

Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -325,6 +325,7 @@ soc21_asic_reset_method(struct amdgpu_de
 	case IP_VERSION(13, 0, 10):
 		return AMD_RESET_METHOD_MODE1;
 	case IP_VERSION(13, 0, 4):
+	case IP_VERSION(13, 0, 11):
 		return AMD_RESET_METHOD_MODE2;
 	default:
 		if (amdgpu_dpm_is_baco_supported(adev))


