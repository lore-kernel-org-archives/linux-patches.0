Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957372590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E4C433EF;
	Sun, 22 Jan 2023 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401306;
	bh=5jRjcoI3mFkJoThAM1/O/uYJJJZs/9Myw6UQASBeA8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/zlJ6fboF04bGBQn4Eo/Ida7E5papTmHsq1FTJsiooesu4dAEimlBOuBFK/zyQJy
	 C3vc863hP5R3SdosTJOVk7LR2rDB2mt0n7xSFJnu43ztNjlq7I0q54YRTVBKO/NdL/
	 bPnI0zD4IRGezwMQhty74+uoNrAjPeLpk365Kc40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 161/193] drm/amdgpu/discovery: enable soc21 common for GC 11.0.4
Date: Sun, 22 Jan 2023 16:04:50 +0100
Message-Id: <20230122150253.754912916@linuxfoundation.org>
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

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 69dc98bbd44160930b6b3ca9ca558f89435d2702 upstream.

Enable soc21 common for GC 11.0.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1507,6 +1507,7 @@ static int amdgpu_discovery_set_common_i
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		amdgpu_device_ip_block_add(adev, &soc21_common_ip_block);
 		break;
 	default:


