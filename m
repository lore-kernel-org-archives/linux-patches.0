Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0762590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117FBC433EF;
	Sun, 22 Jan 2023 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401269;
	bh=zwmA8yf0VtU92YAl2WKjw36/tee5dFo26ahqyzaaq1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFly6b+bgznJnBw39nR+Sobx0rqnwLd4Hj7wMaqBYIdaNC/PyWxzO8fndthmEpMuZ
	 bLmDvEKArqgIiu/L/o7ixiNEtCPMAXHFRoyf6wjsyMpkDh9y9fa4vQ/SJ0ZzgV5vmx
	 oNXN59gYDT/eiEvlZ7qucdNV/9EElLaTUxcSStcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 175/193] drm/amdgpu/discovery: enable nbio support for NBIO v7.7.1
Date: Sun, 22 Jan 2023 16:05:04 +0100
Message-Id: <20230122150254.421701313@linuxfoundation.org>
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

commit 7308ceb44663f40bf9e7373c3b1aa4f7f433d625 upstream.

this patch is to enable nbio support for NBIO v7.7.1.

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
@@ -2258,6 +2258,7 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->nbio.hdp_flush_reg = &nbio_v4_3_hdp_flush_reg;
 		break;
 	case IP_VERSION(7, 7, 0):
+	case IP_VERSION(7, 7, 1):
 		adev->nbio.funcs = &nbio_v7_7_funcs;
 		adev->nbio.hdp_flush_reg = &nbio_v7_7_hdp_flush_reg;
 		break;


