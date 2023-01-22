Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB32D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BEFC433EF;
	Sun, 22 Jan 2023 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401319;
	bh=LBke1HruBG+/WHdArF96ew+buhXlNxs5cAIENF5RsLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vO49MyauqqaibGpTlxOpguxeq1G9AyiLStVOiDnKinLFZ61r0GIgsAAXLLbr8tVky
	 /He1cGNiIJmkkeIAM/78965gPzZQpXd38ljjYl9k6Fp2zy7mvbyYM/LJ0WVaNucqYX
	 P0SuSOiffTS9Kh9wlCVK3wc5wTCFvuHOy2jmBZUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 165/193] drm/amdgpu: set GC 11.0.4 family
Date: Sun, 22 Jan 2023 16:04:54 +0100
Message-Id: <20230122150253.945335841@linuxfoundation.org>
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

commit 94ab70685844227b5c9cb9027a5c4acd3b0e4564 upstream.

this patch is to set GC 11.0.4 family.

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
@@ -2181,6 +2181,7 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->family = AMDGPU_FAMILY_GC_11_0_0;
 		break;
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		adev->family = AMDGPU_FAMILY_GC_11_0_1;
 		break;
 	default:


