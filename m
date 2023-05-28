Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38E0569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A23C433D2;
	Sun, 28 May 2023 19:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302240;
	bh=h1i2rT2xKkS8lzEDpg23Mmpp/L53UR+cN7hT6jyGgBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXv4X/hXeUOu0QnCeKLilz14ciWkWEFuQI6ro9bDSnYMEFdgfg0YUX408MbK8qWfq
	 l0hI3L/7T3jpVC0i3IFgwy767Wz87dOhjSTmeG8r4bSKwEYerAXiTgnic5R2Kk/JT/
	 mybV3mgNSzB3CB11bmPJD/IYTITZ994Q0dHvq6RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.3 055/127] drm/amd/amdgpu: limit one queue per gang
Date: Sun, 28 May 2023 20:10:31 +0100
Message-Id: <20230528190838.156045541@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Xiao <Jack.Xiao@amd.com>

commit 5ee33d905f89c18d4b33da6e5eefdae6060502df upstream.

Limit one queue per gang in mes self test,
due to mes schq fw change.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1328,12 +1328,9 @@ int amdgpu_mes_self_test(struct amdgpu_d
 	struct amdgpu_mes_ctx_data ctx_data = {0};
 	struct amdgpu_ring *added_rings[AMDGPU_MES_CTX_MAX_RINGS] = { NULL };
 	int gang_ids[3] = {0};
-	int queue_types[][2] = { { AMDGPU_RING_TYPE_GFX,
-				   AMDGPU_MES_CTX_MAX_GFX_RINGS},
-				 { AMDGPU_RING_TYPE_COMPUTE,
-				   AMDGPU_MES_CTX_MAX_COMPUTE_RINGS},
-				 { AMDGPU_RING_TYPE_SDMA,
-				   AMDGPU_MES_CTX_MAX_SDMA_RINGS } };
+	int queue_types[][2] = { { AMDGPU_RING_TYPE_GFX, 1 },
+				 { AMDGPU_RING_TYPE_COMPUTE, 1 },
+				 { AMDGPU_RING_TYPE_SDMA, 1} };
 	int i, r, pasid, k = 0;
 
 	pasid = amdgpu_pasid_alloc(16);


