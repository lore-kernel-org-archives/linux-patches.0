Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD037B3F1;
	Mon,  9 Feb 2026 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647287; cv=none; b=M1Wey0zau3O7bBXqZThoOLWiwcdqoRn0AZtnDarGWZBfgE3KllT4bI7ihG5mOi0k/Yx4pTTkvY0bdHFNWCcCQwX838GZ2oM7P5IoaaF7E/4QzdD5++lqTjS9PmOheJE7g0k7eBPEHcXLq+aX9d9ymWUwewBBy0vSxewGy4W+FiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647287; c=relaxed/simple;
	bh=u79mawx8CXjoR36+K84LvrCyOP8k8BUaymXZZS0cod0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pooIuoXDi8M+zsnq/PKfRTSekEBFWDI5cDXr97kKE/DWmoTj6Opb3GWLrP11ew4zBEXdK0iWZyH2VDXufXB9cHBINZMxWhlF51ZCK/qpAgD4Y4XwM6cgcxO8yXFhcqycuccH8j1URqxEJl0kQnlaDSxlt2r0KMHDJtEHQp5HwUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaEBAQxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaEBAQxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36CDC116C6;
	Mon,  9 Feb 2026 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647287;
	bh=u79mawx8CXjoR36+K84LvrCyOP8k8BUaymXZZS0cod0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaEBAQxLs5YmaIQdFnZ2OgSX6mWXGEA+zhHrBGbALhV/292cqlj7UGKYHHuTyjCDm
	 UZynWLpUQLs0+oNt/WL3//4GqyBLgzKQzM4swOIGDktCgm58SLDx9jNAWm64eCHf5a
	 slHZCrERM4+31AWhWu7BF0V+oW5vzcqymtfHtzTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	danijel@nausys.com,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 021/175] drm/amd: Set minimum version for set_hw_resource_1 on gfx11 to 0x52
Date: Mon,  9 Feb 2026 15:21:34 +0100
Message-ID: <20260209142321.242346744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1478a34470bf4755465d29b348b24a610bccc180 upstream.

commit f81cd793119e ("drm/amd/amdgpu: Fix MES init sequence") caused
a dependency on new enough MES firmware to use amdgpu.  This was fixed
on most gfx11 and gfx12 hardware with commit 0180e0a5dd5c
("drm/amdgpu/mes: add compatibility checks for set_hw_resource_1"), but
this left out that GC 11.0.4 had breakage at MES 0x51.

Bump the requirement to 0x52 instead.

Reported-by: danijel@nausys.com
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4576
Fixes: f81cd793119e ("drm/amd/amdgpu: Fix MES init sequence")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c2d2ccc85faf8cc6934d50c18e43097eb453ade2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1667,7 +1667,7 @@ static int mes_v11_0_hw_init(struct amdg
 	if (r)
 		goto failure;
 
-	if ((adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x50) {
+	if ((adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x52) {
 		r = mes_v11_0_set_hw_resources_1(&adev->mes);
 		if (r) {
 			DRM_ERROR("failed mes_v11_0_set_hw_resources_1, r=%d\n", r);


