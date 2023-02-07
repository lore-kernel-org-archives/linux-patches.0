Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B202C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC195C43443;
	Tue,  7 Feb 2023 13:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775325;
	bh=FQoo1cYxT9+xUFmp7j4fTzAWcNSiimY92euimoOaADs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgAwanx7dBNiaUIjfBfcNuSKZOqoS0hv5r0g6Rfik/M+cG5duIZMkyPISSCKul5kl
	 NvWChSnyWBdYoFwHWaMHvY6nNHiRFInXviJgRzbWnlFY8lqfy4+DE2MQtN9SBxDGqt
	 eKmKEeXZ0IKPQcw731xAxssM2q0IVc326QwuqQ7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Graham Sider <Graham.Sider@amd.com>,
	Mukul Joshi <Mukul.Joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 183/208] drm/amdgpu: update wave data type to 3 for gfx11
Date: Tue,  7 Feb 2023 13:57:17 +0100
Message-Id: <20230207125642.759741948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Graham Sider <Graham.Sider@amd.com>

commit ed8e793c65e4c6633e8577e40d574da8a56d2e0f upstream.

SQ_WAVE_INST_DW0 isn't present on gfx11 compared to gfx10, so update
wave data type to signify a difference.

Signed-off-by: Graham Sider <Graham.Sider@amd.com>
Reviewed-by: Mukul Joshi <Mukul.Joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index b9b57a66e113..66eb102cd88f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -790,8 +790,8 @@ static void gfx_v11_0_read_wave_data(struct amdgpu_device *adev, uint32_t simd,
 	 * zero here */
 	WARN_ON(simd != 0);
 
-	/* type 2 wave data */
-	dst[(*no_fields)++] = 2;
+	/* type 3 wave data */
+	dst[(*no_fields)++] = 3;
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_STATUS);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_LO);
 	dst[(*no_fields)++] = wave_read_ind(adev, wave, ixSQ_WAVE_PC_HI);
-- 
2.39.1



