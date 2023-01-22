Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1392590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD066C433D2;
	Sun, 22 Jan 2023 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401322;
	bh=85kQ0T4gD/QejF0oASW15FZVXbt2jPFPzQ8XZIW3dcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rpj6zwdpA3OS3u9H7f7id534/fvufhL1zb1s2QMWwcYnaEvJrhEYZiyJ659d/aPIF
	 Wipa4OHqOdP+X9Hn8ht2mRzMz3WX1im3w342jpJYUnYCG+7cG6LU2pW94MQip3mFT0
	 0XzDq8UtgmLnzVTQfCnoxxgSqq89HpaUj1k4WJGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 166/193] drm/amdgpu/discovery: set the APU flag for GC 11.0.4
Date: Sun, 22 Jan 2023 16:04:55 +0100
Message-Id: <20230122150253.995420918@linuxfoundation.org>
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

commit dd2d9c7fd7716838d477e257f43facd68c53d3a9 upstream.

Set the APU flag appropriately for GC 11.0.4.

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
@@ -2199,6 +2199,7 @@ int amdgpu_discovery_set_ip_blocks(struc
 	case IP_VERSION(10, 3, 6):
 	case IP_VERSION(10, 3, 7):
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		adev->flags |= AMD_IS_APU;
 		break;
 	default:


