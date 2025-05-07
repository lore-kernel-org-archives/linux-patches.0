Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB1B211A2A;
	Wed,  7 May 2025 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643934; cv=none; b=Xx4ATbJ4nGmRLcHWup4Iq/ME7as5pVKuPfoLwdcHUCLcNQUJglm7/4/lu6gY0/yoNlHxiGFLQCB2sy2FcEPRxAAaIs7z+DOwDWGvuuKo5a07jdIV1ZB9EKMTw+UK0Uj5vr6WlVw2KqllrRMoX6q8K9u+/ABfLmCheHSKmhyH5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643934; c=relaxed/simple;
	bh=/kd9QQj1QI2vCXkGmIL8zt5rZAOKwQFdwLiPLHgCWOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7qdhOTtyqUTZIiQ0Y3ATbLE+EbCDAOX4brFk9sMzyofR/l/a9/9ZtHdBxEYn9zR6GzmzzGzUUEwam3BogS6xFbChz3JOQ8BLxBsJZWiWsHNlOe7VvDUId/c76GFTDchVJgl6pt2Xr2ixFqxdK8xyKytMRAePkPF0lfhxiuLLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMJEUBgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMJEUBgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC7C4CEE2;
	Wed,  7 May 2025 18:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643934;
	bh=/kd9QQj1QI2vCXkGmIL8zt5rZAOKwQFdwLiPLHgCWOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMJEUBgvZhtglv99yJc4IExhJJIXgvzK7jqDZQCxz0FJSgUyFavN5RZDP7+FlPJ4y
	 XDp2me/RgS5hjZOCCaAdjGevpRXy2b7Cc3UvVKBWbd+UCY2Fc3f9tLvT7aBEE/aIlz
	 9a4hb2gFf8OxfLFIxSLSfbam05aHHkMxes1Fn+Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 048/183] drm/amd/display: Default IPS to RCG_IN_ACTIVE_IPS2_IN_OFF
Date: Wed,  7 May 2025 20:38:13 +0200
Message-ID: <20250507183826.640193638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit 6ed0dc3fd39558f48119daf8f99f835deb7d68da upstream.

[Why]

Recent findings show negligible power savings between IPS2 and RCG
during static desktop. In fact, DCN related clocks are higher
when IPS2 is enabled vs RCG.

RCG_IN_ACTIVE is also the default policy for another OS supported by
DC, and it has faster entry/exit.

[How]

Remove previous logic that checked for IPS2 support, and just default
to `DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF`.

Fixes: 199888aa25b3 ("drm/amd/display: Update IPS default mode for DCN35/DCN351")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f772d79ef39b463ead00ef6f009bebada3a9d49)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1912,26 +1912,6 @@ static enum dmub_ips_disable_type dm_get
 
 	switch (amdgpu_ip_version(adev, DCE_HWIP, 0)) {
 	case IP_VERSION(3, 5, 0):
-		/*
-		 * On DCN35 systems with Z8 enabled, it's possible for IPS2 + Z8 to
-		 * cause a hard hang. A fix exists for newer PMFW.
-		 *
-		 * As a workaround, for non-fixed PMFW, force IPS1+RCG as the deepest
-		 * IPS state in all cases, except for s0ix and all displays off (DPMS),
-		 * where IPS2 is allowed.
-		 *
-		 * When checking pmfw version, use the major and minor only.
-		 */
-		if ((adev->pm.fw_version & 0x00FFFF00) < 0x005D6300)
-			ret = DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF;
-		else if (amdgpu_ip_version(adev, GC_HWIP, 0) > IP_VERSION(11, 5, 0))
-			/*
-			 * Other ASICs with DCN35 that have residency issues with
-			 * IPS2 in idle.
-			 * We want them to use IPS2 only in display off cases.
-			 */
-			ret =  DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF;
-		break;
 	case IP_VERSION(3, 5, 1):
 		ret =  DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF;
 		break;


