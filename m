Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5882590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B6CC433EF;
	Sun, 22 Jan 2023 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401253;
	bh=J9t33HKzg4/e4xaFphcgItC3AhLRHPx6P+H0GfIvTYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suRjuyQ7byDfZaRqkEgxXnnGXYhvz5A90ykMHTUjm3QaIaM9zOn4b6eGLjh7IrL1A
	 jQcp0jWBBNBH8wPoB5Q9cy5RDvEaB3+0rPw2MD1fRh3xgXIoVAYm03+7Ar4jDXRKVz
	 XWU4WW4dYIQupa2JctZa62vTXoFVrruXa31k/dIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 169/193] drm/amdgpu/discovery: add PSP IP v13.0.11 support
Date: Sun, 22 Jan 2023 16:04:58 +0100
Message-Id: <20230122150254.143279560@linuxfoundation.org>
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

commit 7c1389f1b1228b96e621815e63eaa2e89b9f7511 upstream.

Add PSP IP v13.0.11 ip discovery support.

Signed-off-by: Tim Huang <tim.huang@amd.com>
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
@@ -1638,6 +1638,7 @@ static int amdgpu_discovery_set_psp_ip_b
 	case IP_VERSION(13, 0, 7):
 	case IP_VERSION(13, 0, 8):
 	case IP_VERSION(13, 0, 10):
+	case IP_VERSION(13, 0, 11):
 		amdgpu_device_ip_block_add(adev, &psp_v13_0_ip_block);
 		break;
 	case IP_VERSION(13, 0, 4):


