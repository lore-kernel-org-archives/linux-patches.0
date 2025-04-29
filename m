Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA9A2AE72;
	Tue, 29 Apr 2025 18:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950381; cv=none; b=YoEYcWF6FjKSWNFH/axgpexN8IPDdZa2J2cxAOxZpY+SisfNp3mj82xxAR/tuKHFMiK1PHSGmOSNYLjpWBI6jnCGPRHs6mn0jUpliVv/18eQcKJ1b/VmJgEwrgg/wo+wZlJpx/I2IM51hERx30HFtqij2Z5YXgWbNjJgURNfyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950381; c=relaxed/simple;
	bh=S4CYA4iDjcl00tIBduB/w5LDtBLeDP7hsy7k4lGpe6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRXflzR9+NS5+HXnTez6CDhEZy+JV2+OYAtQ3mIP4j9WJqioc8bo1IFTZJ6ehxTVatUBHhDf5frrSlzEzqtxVI7ZgTayL9RGFgIB0Gt6Qid15yT/cgsE3sH9yKyjyM52KOdC5mmaE666QVCKlbpVnNJLGPo+1F/WvA7fQBh+zXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZMAYMD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZMAYMD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571C2C4CEE3;
	Tue, 29 Apr 2025 18:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950380;
	bh=S4CYA4iDjcl00tIBduB/w5LDtBLeDP7hsy7k4lGpe6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZMAYMD2YlNoFG04GWMCe4eUbTfJLKkM6YQqHIgzRiIMgIdjyy6nFUv6Z/dJ4Dk8g
	 s/eJgPIjqBrA681erAQk5LvkFST1iZhIykAwgj8fM/RGBJpybCZxncbqZBJdM7GJ/b
	 IAERtb/2/mnhWoXRldk/hZy68k4MA+omoXKkzFBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 078/204] drm/amd/display: Force full update in gpu reset
Date: Tue, 29 Apr 2025 18:42:46 +0200
Message-ID: <20250429161102.613170174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

commit 67fe574651c73fe5cc176e35f28f2ec1ba498d14 upstream.

[Why]
While system undergoing gpu reset always do full update
to sync the dc state before and after reset.

[How]
Return true in should_reset_plane() if gpu reset detected

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ba8619b9a378ad218ad6c2e2ccaee8f531e08de)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9590,6 +9590,9 @@ static bool should_reset_plane(struct dr
 	if (adev->ip_versions[DCE_HWIP][0] < IP_VERSION(3, 2, 0) && state->allow_modeset)
 		return true;
 
+	if (amdgpu_in_reset(adev) && state->allow_modeset)
+		return true;
+
 	/* Exit early if we know that we're adding or removing the plane. */
 	if (old_plane_state->crtc != new_plane_state->crtc)
 		return true;


