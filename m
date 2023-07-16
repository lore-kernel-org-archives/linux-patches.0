Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE46EAD3F
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F97FC433C7;
	Sun, 16 Jul 2023 20:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539419;
	bh=/i54hYDm4FXHFi9Vdj4DsHr9DFN8wTVF1bea4Uppt5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD76OdiSVmCB/Y1WuelguHXkJCg91q5ZxaMJ3wzLw8/f8j7kxaEfaO/RfAEpWYsFH
	 pZVswIy95arOqwQt5kWOvte3D/WjYWSX+C5VPI2V2xQOVy2JAsc1TpupvdTPb+7h3T
	 YBNhFMf91CnhLX5Hmf/lPjbi4/a3DrG7P5CTIDAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 789/800] drm/amdgpu: Skip mark offset for high priority rings
Date: Sun, 16 Jul 2023 21:50:42 +0200
Message-ID: <20230716195007.475154071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiadong Zhu <Jiadong.Zhu@amd.com>

commit ef3c36a6e025e9b16ca3321479ba016841fa17a0 upstream

Only low priority rings are using chunks to save the offset.
Bypass the mark offset callings from high priority rings.

Signed-off-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ef3c36a6e025e9b16ca3321479ba016841fa17a0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring_mux.c
@@ -423,6 +423,9 @@ void amdgpu_sw_ring_ib_mark_offset(struc
 	struct amdgpu_ring_mux *mux = &adev->gfx.muxer;
 	unsigned offset;
 
+	if (ring->hw_prio > AMDGPU_RING_PRIO_DEFAULT)
+		return;
+
 	offset = ring->wptr & ring->buf_mask;
 
 	amdgpu_ring_mux_ib_mark_offset(mux, ring, offset, type);


