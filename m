Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214501;
	b=f1NnH2cr8IWRdHPgSgphQ26buLZmRdFfpIeRZC/K84I/23MOsFVq/f0OSU8KQAfBVvus
	 ek+LPUMVwryk0JEmXd5dsm7vWtL7UN9yPHGjl7Iau4jzgdyyADxsR+vlLvHpDkccpx6z1
	 hOUFlYsVHbmHO7RIoqag+jdpJoU//TYn0rtOmB/tIr3LGKuMhm1x7q0gefrVCAjfQdRSp
	 wg/AAJcUhmyVwoVPoYX1GTG3nhId/t4MIL1Jp/qIqNWvsXcaXDT3bU9f+GmB6nwvJHe0z
	 qSTvJW58oDlOyutjTqUHNNkKTyCgR8IY2i3jvFhOcmfuREV+VVHAPEnZv5V1WI6yCTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=73d7eyT+DEHa/ArbGWgLQnjv7P0rKwJbe/bisI5A6hE=;
	b=FrA7XVcromv3Yr+REgKIwkd68zuWadfPzKfLSqcQeDXi/3bCx6Y1Wem05nFp8mzzd76c
	 x34nwHh+Yeju3BkhprCAvmYZX9qLIdq5elBTctCfrPBQNHPVivPND93aHdNsvpGX4fXy9
	 Vua/FXG4z/ECT+bWSLyKqOIWF+rHJC5JNGB9vRq/5rqza7qxzdjZjty/ii6lpzpeFlLId
	 XZnUoksxP1VWBcOB2Jra1dVATxJqcL+F5fF3uR9Q8RKBFPk0F21OTEIk72HcqaQyRyAIJ
	 EgLyXXKtosieDnv1gC0Qa9WCG3787m2lII2szcqcd3oXkLiArPxz8Ti37liuBpHIgGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwRCT244;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E156606BF8F;
	Wed, 28 Oct 2026 19:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwRCT244
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE401F01825;
	Wed, 28 Oct 2026 19:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214501;
	bh=73d7eyT+DEHa/ArbGWgLQnjv7P0rKwJbe/bisI5A6hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwRCT244/RPb0PHj4X1MsUurzI17bue7NSmO7/f0QtdJ8Pn5PiE2EjHM0fIGnGe7i
	 lxGR8DlP0GvFCoq3lMfEeaYUi8Zy1Mh3Ryrxr+RxrOlBpuhOXXEXHIzKlGZmeTwFE2
	 wq+bPSJkA9YA77eWMJskkR4BvlkN3SNCxXvhb6CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0881/1887] drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM
Date: Wed, 28 Oct 2026 17:49:37 +0100
Message-ID: <20261028170519.466604620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 33cc891b56b93cad1a83263eaf2e417436f70c82 ]

Otherwise accessing them can cause a crash.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index aef76467c409f..4d8912345c38f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -223,6 +223,9 @@ static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
 	    !adev->gmc.vram_vendor)
 		return 0;
 
+	if (!ttm_resource_manager_used(&adev->mman.vram_mgr.manager))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.53.0



