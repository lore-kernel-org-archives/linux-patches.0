Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B18626FA54;
	Tue,  8 Apr 2025 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117187; cv=none; b=g6McIac0qEBEcihWD+CaVsBJprSvDgOLpmZ8faOVvSaaNuLsSpu0bd4D6mOXCcT4/hSCqUtbCYaU4kk7v8E6jmOqnL4dO1NtFbYNtR369weYinY98IOhhRrzTwUm3wJvQvEwKzvDxd3ikspCyzaIaRk4C0FMPfFvXyFxEUeZcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117187; c=relaxed/simple;
	bh=1OMiMBfaaV4tc7Fu9pQljQdppz+9jX8GU7xhEy/o3BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp+b3XAwzCiJZ65yNKsruXuRXkYSiH4pVHBDouv9iQoHLms3bD50rZz2Q7GM/7nJi3F3JojjIldsUbIzpKl7YcZjfv7LaZGQZPrf/QFDGMFjVktpsuzhQsSmHOWj1ui4IYJGn22dTO/Pv82mjqHA6FKtNCQESv3wi8mLUOtWh8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBRxp6TG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBRxp6TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DBAC4CEE5;
	Tue,  8 Apr 2025 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117186;
	bh=1OMiMBfaaV4tc7Fu9pQljQdppz+9jX8GU7xhEy/o3BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBRxp6TGekBULsOfGqiiYB2zE6F1OMiN8HqD3cPL+VykB3SbrLGy6XkkEFXk0cs+6
	 xSupgzgnM4ArWw0avU8Cd95edwayuyzZBAF+E+NxRkzDAM8PWfjPE3MI1pNu0KhBlM
	 uQeDX0yKecz+yM5muO1WvO4dE3y1CkECD39/50rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 389/423] Remove unnecessary firmware version check for gc v9_4_2
Date: Tue,  8 Apr 2025 12:51:55 +0200
Message-ID: <20250408104854.951571445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Candice Li <candice.li@amd.com>

commit 5b3c08ae9ed324743f5f7286940d45caeb656e6e upstream.

GC v9_4_2 uses a new versioning scheme for CP firmware, making
the warning ("CP firmware version too old, please update!") irrelevant.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1269,6 +1269,7 @@ static void gfx_v9_0_check_fw_write_wait
 	adev->gfx.mec_fw_write_wait = false;
 
 	if ((amdgpu_ip_version(adev, GC_HWIP, 0) != IP_VERSION(9, 4, 1)) &&
+	    (amdgpu_ip_version(adev, GC_HWIP, 0) != IP_VERSION(9, 4, 2)) &&
 	    ((adev->gfx.mec_fw_version < 0x000001a5) ||
 	     (adev->gfx.mec_feature_version < 46) ||
 	     (adev->gfx.pfp_fw_version < 0x000000b7) ||


