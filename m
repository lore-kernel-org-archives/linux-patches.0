Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC70022F0F;
	Thu, 18 Jan 2024 11:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575676; cv=none; b=s4Ct05ytRQ9Qr6V64hsaOxQLbzWfY4Jqo4gtnTlhxdoPLYfICOOfj+C1li1412AtyJpWAS+lwWGK7PkdKhcEV4I1K/Sdlo6i4qFKbSnW2xQi824RbfkJgTBkqLF7UfGOSQ5kFzCwcF8FSHDj/vnePv6/o1Xbt7o+NSVs6WlA988=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575676; c=relaxed/simple;
	bh=7Fs+DBRQxp6jp3YCjn3KpCvk4C1PDKGXp3M/J/HWp7M=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=d2XRJfAkGHcqSTv2IVYFQIAAp0gxm1CPJr+3OvYdahP1k/u33qJw7MwoLQwzrU8PxnfNY4/b9LwYB65FLXZpitmgjAkB+EbTvumNWhSpTgEJmRL8kfQDTAEYgiEOrY0lRRiwmM2vtDIXJWkfdgKQdHFyZ4kb2YwIVAm49vloOe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERcbkg5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERcbkg5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EABCC433C7;
	Thu, 18 Jan 2024 11:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575676;
	bh=7Fs+DBRQxp6jp3YCjn3KpCvk4C1PDKGXp3M/J/HWp7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERcbkg5SVb3hXG94RVLuEGq+yW3oFQlaALrhyYEDseRmEJ+h1nxHLPh3V+IO0OGo6
	 dyfWeTA3tJnWXKmeOJgKYsBu+Wi+3P5HOPC8LXcG0ddvWKcIGxpR1/Nx5Jv4PlHTAB
	 W0BTZKl21qr62XhLE92EugRw3fVSzdIW4imFzv8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/100] drm/amdgpu: Add NULL checks for function pointers
Date: Thu, 18 Jan 2024 11:48:45 +0100
Message-ID: <20240118104312.526904492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 81577503efb49f4ad76af22f9941d72900ef4aab ]

Check if function is implemented before making the call.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 2eddd7f6cd41..811dd3ea6362 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1411,9 +1411,11 @@ static void soc15_common_get_clockgating_state(void *handle, u64 *flags)
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
 
-	adev->nbio.funcs->get_clockgating_state(adev, flags);
+	if (adev->nbio.funcs && adev->nbio.funcs->get_clockgating_state)
+		adev->nbio.funcs->get_clockgating_state(adev, flags);
 
-	adev->hdp.funcs->get_clock_gating_state(adev, flags);
+	if (adev->hdp.funcs && adev->hdp.funcs->get_clock_gating_state)
+		adev->hdp.funcs->get_clock_gating_state(adev, flags);
 
 	if (adev->ip_versions[MP0_HWIP][0] != IP_VERSION(13, 0, 2)) {
 
@@ -1429,9 +1431,11 @@ static void soc15_common_get_clockgating_state(void *handle, u64 *flags)
 	}
 
 	/* AMD_CG_SUPPORT_ROM_MGCG */
-	adev->smuio.funcs->get_clock_gating_state(adev, flags);
+	if (adev->smuio.funcs && adev->smuio.funcs->get_clock_gating_state)
+		adev->smuio.funcs->get_clock_gating_state(adev, flags);
 
-	adev->df.funcs->get_clockgating_state(adev, flags);
+	if (adev->df.funcs && adev->df.funcs->get_clockgating_state)
+		adev->df.funcs->get_clockgating_state(adev, flags);
 }
 
 static int soc15_common_set_powergating_state(void *handle,
-- 
2.43.0



