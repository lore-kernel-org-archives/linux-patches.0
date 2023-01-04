Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BFAAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A980C433EF;
	Wed,  4 Jan 2023 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849638;
	bh=77Y/fKw5+sCoJcuGF2qllAqjhim4poxFL2Dp7ppYt4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7skiva5WburHw3Nw5kSxBob9d27ob3IrJQgr7rAK0YhC8H4wr6nNjIaYKXEWSxaH
	 9uv7GaRfyPe62d8ICa0IKyvYslUNNjz6zWdj2DehtekNDsun/UCVXdLnzyH5gFfljU
	 ttJvTLGfgJIXLcBoBphvVZGe0AzyplD1O5bQ1lVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 169/177] drm/amd/display: Add DCN314 display SG Support
Date: Wed,  4 Jan 2023 17:07:40 +0100
Message-Id: <20230104160512.798886030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

commit fe6872adb05e85bde38f2cdec01a0f4cfb826998 upstream.

Add display SG support for DCN 3.1.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1511,6 +1511,7 @@ static int amdgpu_dm_init(struct amdgpu_
 		case IP_VERSION(3, 0, 1):
 		case IP_VERSION(3, 1, 2):
 		case IP_VERSION(3, 1, 3):
+		case IP_VERSION(3, 1, 4):
 		case IP_VERSION(3, 1, 5):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;


