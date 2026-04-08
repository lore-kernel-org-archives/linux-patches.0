Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D3A2641FC;
	Wed,  8 Apr 2026 18:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674147; cv=none; b=cByPA1GuRNph7fpFL9JlXpqDVCL5ZM/IRvjmEJiFrNa3TJ05GfLxcCs+8MxZo6voNyZpMvqNrers2VkYWOGpuw6JIQsggFfMQ/fcz8QIrKe3wduXjB1/zS4/n1mOo7vVZt1u/nwdSyu7voToYcJA+pDBTiWj/E4bmG/vel35MM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674147; c=relaxed/simple;
	bh=LvZYxG6r4Ofvz3acXBbpAW5TzezgElwYdgSqGKjLX2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdPSlGrCcuzwm2OojQVHTtkqo+LpQGgRjcVlpeHWeNwZQOaEjWviMiSU8bqiV79gcML7Zi5QXdWEHX9xIkDiUpii88PoKqmR03woe6bQrxBVPq9xeHZjS8/1SZ0e8u7bBAvyeIEI8VOamW0pZy7bUyFeGC6O357LH4TjBL+KqDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wib+Wi6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wib+Wi6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEADC2BC9E;
	Wed,  8 Apr 2026 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674146;
	bh=LvZYxG6r4Ofvz3acXBbpAW5TzezgElwYdgSqGKjLX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wib+Wi6+XzFumVuCXNohjnfHJXvUIedqixtOesqnF5DNDWQ5VfE+z0WCqie7staAH
	 2wxNdYz7GqzpXQjkalseS4ZkQ+TXGOALEFvltanoPLK4hAJ274OnQTYzkTwL4RoxhP
	 mfAx9NAdn3mz04GhCFaJ0ONmg4zy30q09P8vF4bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rosen Penev <rosenp@gmail.com>
Subject: [PATCH 6.12 227/242] drm/amd/amdgpu: decouple ASPM with pcie dpm
Date: Wed,  8 Apr 2026 20:04:27 +0200
Message-ID: <20260408175935.589949936@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit df0e722fbdbedb6f2b682dc2fad9e0c221e3622d ]

ASPM doesn't need to be disabled if pcie dpm is disabled.
So ASPM can be independantly enabled.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1782,8 +1782,6 @@ bool amdgpu_device_should_use_aspm(struc
 	}
 	if (adev->flags & AMD_IS_APU)
 		return false;
-	if (!(adev->pm.pp_feature & PP_PCIE_DPM_MASK))
-		return false;
 	return pcie_aspm_enabled(adev->pdev);
 }
 


