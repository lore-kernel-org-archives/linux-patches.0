Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1623723DE;
	Wed,  7 May 2025 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644464; cv=none; b=qJ5rMsLIBJWlYupK6OaliPm1AnRo3y+mimJdta1FGUnrZvmSuGUpV6vVSnBXrzMdDmf6lh4Wx5qvY6SiiauyZmrKNZ7CfJmw7BeCf27Nu+nRKBiD6GZGazXIvG1l0qEnKoknWOsLIdfFMa0+7ijEKWvTiMKxIsBHigIXukVEdWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644464; c=relaxed/simple;
	bh=JSUmcOpcN8769may730Xv0ZboMU2Wd7HWoVDQON3j54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvMgf69GshXdhM6V8En04D6visGAsaCsG77sTs7LUZYY4iqeL4KidKiBVYC/u0om5EGS9ZOyYMNigrAbKaUxzvqQAUW2OCp5BcBE3HfQT+3TyFrHg+l0pnFdRtc9BSjq65SVOuc6iSx6ZvxzaIj2wQQf8/ds/tLVZJd+XYMn9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eEZx4ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eEZx4ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B03C4CEE2;
	Wed,  7 May 2025 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644463;
	bh=JSUmcOpcN8769may730Xv0ZboMU2Wd7HWoVDQON3j54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eEZx4ix9iPMRkmCpxE1wucrnKElkoZxiBgSmXWLyzaFRr3wilzWlVG6AdjcKgXAy
	 ixch7u/dQUdfZXmAIxlxmWkt31fji0AYaztaNL5/LHtqg7P2NU5IzENINUoYVyJVPh
	 iC5y4Fsn6VlgolHOZ+SppEmGQSZuRCdSpWGExCfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 051/164] drm/amd/display: Default IPS to RCG_IN_ACTIVE_IPS2_IN_OFF
Date: Wed,  7 May 2025 20:38:56 +0200
Message-ID: <20250507183822.951367021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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
@@ -1887,26 +1887,6 @@ static enum dmub_ips_disable_type dm_get
 
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


