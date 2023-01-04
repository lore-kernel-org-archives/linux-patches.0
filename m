Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD0AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA676C433EF;
	Wed,  4 Jan 2023 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848490;
	bh=M9OzY5yiLHSLZnyefPAYocob9L9uO0naltWvhyTEApc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZQQcUrTJnGZS62csLSSJ9YvhOYQ1nV1pKSeRC3Tx82h5ZZnFFWqxP+OCKwjyjzBq
	 1X/Rtiqc/ERF8o9gv3rf2BskCQ7tdc/2zoZNAvqtyzt1NUy3DZ4toEGCOD4Ec2iRly
	 6M8EATO+csNlKPDvAt2G+QCfWcMEbK3PDeJ6oIxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 001/207] drm/amdgpu: skip MES for S0ix as well since its part of GFX
Date: Wed,  4 Jan 2023 17:04:19 +0100
Message-Id: <20230104160511.953759683@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit afa6646b1c5d3affd541f76bd7476e4b835a9174 upstream.

It's also part of gfxoff.

Cc: stable@vger.kernel.org # 6.0, 6.1
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3005,14 +3005,15 @@ static int amdgpu_device_ip_suspend_phas
 			continue;
 		}
 
-		/* skip suspend of gfx and psp for S0ix
+		/* skip suspend of gfx/mes and psp for S0ix
 		 * gfx is in gfxoff state, so on resume it will exit gfxoff just
 		 * like at runtime. PSP is also part of the always on hardware
 		 * so no need to suspend it.
 		 */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP ||
-		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX))
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
 		/* XXX handle errors */


