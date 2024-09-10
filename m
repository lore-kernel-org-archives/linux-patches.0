Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309219412C;
	Tue, 10 Sep 2024 10:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964153; cv=none; b=NBehoTmhwGwEx6KS6yL3pgUzN8QPKl7xKuil5aSs3gRUQPeaLFiw3UOcJtGoUFBfjNnqnIr54driRtyYPlrbkewb7n0CijX+hndzlhCg1n77aVPHMWuK1ic4oAoyLvFWVetByv0GAyj0YgMATrK2i2zOJo13Im5wx60csa0Z7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964153; c=relaxed/simple;
	bh=/m5DQaj6kgVwkeBpWipdQAsr/CjYmjizdl1BYJtgVas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I72dX6pJ0dYRASGw1DYYtuUOKq8hz4wXvVVIZDWSho3Gi38HY9Fdi1kfhoaxmzpU//l8XryxRkULht7jFXFgQDAa6ZB1WgWfP+EtxzK2jxzzNYeOzVJ2y/RcA8iM50jd2hL+XsUhofeQRElk6ejGwnkRXOiGhMiFKgcHMRD/2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXg7T+tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXg7T+tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C23BC4CEC3;
	Tue, 10 Sep 2024 10:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964152;
	bh=/m5DQaj6kgVwkeBpWipdQAsr/CjYmjizdl1BYJtgVas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXg7T+tI2xHetvf/8Gb7Kus14G3+zMYTpNZ1EOeRXSWqc76QUJIL3pvim5CjDpFBc
	 0fGQCchFB8JCE/pvbznYWXzlE8J159ouX/dBh7Eo1K9J1qYH4Vo+rvaOaprd9B7w52
	 rlzKh82T/QI3/iRypqjbPMhM8ma7c1gRADO/jiX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/269] drm/amdgpu: Fix smatch static checker warning
Date: Tue, 10 Sep 2024 11:31:12 +0200
Message-ID: <20240910092611.236114599@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit bdbdc7cecd00305dc844a361f9883d3a21022027 ]

adev->gfx.imu.funcs could be NULL

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c81e98f0d17f..c813cd7b015e 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4269,11 +4269,11 @@ static int gfx_v11_0_hw_init(void *handle)
 			/* RLC autoload sequence 1: Program rlc ram */
 			if (adev->gfx.imu.funcs->program_rlc_ram)
 				adev->gfx.imu.funcs->program_rlc_ram(adev);
+			/* rlc autoload firmware */
+			r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
+			if (r)
+				return r;
 		}
-		/* rlc autoload firmware */
-		r = gfx_v11_0_rlc_backdoor_autoload_enable(adev);
-		if (r)
-			return r;
 	} else {
 		if (adev->firmware.load_type == AMDGPU_FW_LOAD_DIRECT) {
 			if (adev->gfx.imu.funcs && (amdgpu_dpm > 0)) {
-- 
2.43.0



