Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC4215F30A;
	Mon, 29 Jan 2024 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548268; cv=none; b=A/uHjdBFZVGJU1trNHBD994myjpfAm9NgMG+JEkw3IoVWMo9Sb4n7xVcRu2a5TRWzEATtKubLvIKUmuKxK9wA2Ewsd4iqJ3zYcLLYtywEo6dvk1QKIwoWm+ckzCAfsrprwukpfVYpC9zPmAwZDHhDwWFoq/B4yJ3Gt+ysvMjy5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548268; c=relaxed/simple;
	bh=RSK6uK/kxQkvrwwabzl4ZkS4NjD58Ampi+zsVwGFGug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxBVzH5ALwV036EJm4x0TihVt41bR0rLxEhn2WLnNwD/a77l+iLGFarRlu+7GIqfeKKzoXtmfUkd9+ozPpzxMlcV+X+VFVdCcrAE/B79VZM9U7jCE710ybpzk2dk36v0r/LZQNjH7ccCnrPKYfQe+uzPW5+QwG4CuULLDlvZsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1fVmHIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1fVmHIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250A5C43390;
	Mon, 29 Jan 2024 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548268;
	bh=RSK6uK/kxQkvrwwabzl4ZkS4NjD58Ampi+zsVwGFGug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1fVmHIt6OuEyQY1JkMKws9zGLz9b0sH8dGO6Ra6VLXlcrbF4nOddpQhtBKryCp/N
	 e7M6MurQzU8U2Jcez3T0KqnK4t0gmwxLMo/4lc0YfFbUiOejnzXZl404eTFixWOJgk
	 +fyMISAQQzRgNtoCVx8ruMhaBWvD+JQ8UBp51gM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ori Messinger <Ori.Messinger@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Subject: [PATCH 6.7 261/346] drm/amdgpu: Enable GFXOFF for Compute on GFX11
Date: Mon, 29 Jan 2024 09:04:52 -0800
Message-ID: <20240129170024.069572435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ori Messinger <Ori.Messinger@amd.com>

commit aa0901a9008eeb2710292aff94e615adf7884d5f upstream.

On GFX version 11, GFXOFF was disabled due to a MES KIQ firmware
issue, which has since been fixed after version 64.
This patch only re-enables GFXOFF for GFX version 11 if the GPU's
MES KIQ firmware version is newer than version 64.

V2: Keep GFXOFF disabled on GFX11 if MES KIQ is below version 64.
V3: Add parentheses to avoid GCC warning for parentheses:
"suggest parentheses around comparison in operand of ‘&’"
V4: Remove "V3" from commit title
V5: Change commit description and insert 'Acked-by'

Signed-off-by: Ori Messinger <Ori.Messinger@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -684,10 +684,8 @@ err:
 void amdgpu_amdkfd_set_compute_idle(struct amdgpu_device *adev, bool idle)
 {
 	enum amd_powergating_state state = idle ? AMD_PG_STATE_GATE : AMD_PG_STATE_UNGATE;
-	/* Temporary workaround to fix issues observed in some
-	 * compute applications when GFXOFF is enabled on GFX11.
-	 */
-	if (IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11) {
+	if (IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11 &&
+	    ((adev->mes.kiq_version & AMDGPU_MES_VERSION_MASK) <= 64)) {
 		pr_debug("GFXOFF is %s\n", idle ? "enabled" : "disabled");
 		amdgpu_gfx_off_ctrl(adev, idle);
 	} else if ((IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 9) &&


