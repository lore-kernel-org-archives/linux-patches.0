Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416BF43DA3C;
	Thu, 30 Jul 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422645; cv=none; b=teYR64qzbRiN6M350RYveZB1o/yAHaVLU7CO8Abe2FQ+jDxYXVI/hCW+W+DssSus7LX2hIU9BUSF3N1zGeCoHBqxCRtX7bKU24Ffh+NiW5Dnur5a4juryMTbXte8kqUHaD0OUZtyUAI6iaMeR2uwkhIaCgVZHRZvwRBS9cLrmXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422645; c=relaxed/simple;
	bh=54Gz3fPfYlYdSo4B8o5vFwB1MLK6KuqfwIY3kF9HkNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPvj/x4lQtnCukLJTAYv92XQoNLY9DW8n2CxxTHTzeOYPjCAEQ5WeWVbRaIXi0u1/NpKKbDT/UfciKemwWanycPA36K6XxkxPlwa7O5Z87rp0oQE7RDPa8v6d0k6CU2jeSaGWVSBJpSUzhJeArQLevoWxYQRPHYszBbI8pf0t0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGWtyC/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGWtyC/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EF71F00A3D;
	Thu, 30 Jul 2026 14:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422643;
	bh=OBfH04IvN1yJNk+tLGSukMJSsXwQ4ERnIolr+7fu9dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGWtyC/ezE4ucQTidAWIawavRKdzFjA+8j3tJPzGAHUEW8fmHi0v+vYcqoeuL6dsQ
	 FaNKXfubMPcHjkHCudc/+f+1izClbAtJ6nGPiujw8pDp9WAw01NQVMFCybUqvfyZFZ
	 2XAWObe8nAx5qTqh1gZeZkEnsxcQRRDp+ygVk0Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Leo Li <sunpeng.li@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.1 465/744] drm/amd/display: Fix missing DCE check in dm_gpureset_toggle_interrupts()
Date: Thu, 30 Jul 2026 16:12:18 +0200
Message-ID: <20260730141454.180493666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit fbbaca9e208733652828ea98d00f09f260a7770e upstream.

This line was lost when cping from amd-staging-drm-next to drm-fixes.
So add it back.

Cc: stable@vger.kernel.org
Fixes: 8382cd234981 ("drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock")
Reported-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260723134450.13838-1-sunpeng.li@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3178,7 +3178,8 @@ static void dm_gpureset_toggle_interrupt
 		acrtc = get_crtc_by_otg_inst(
 				adev, state->stream_status[i].primary_otg_inst);
 
-		if (acrtc && state->stream_status[i].plane_count != 0) {
+		if (acrtc && state->stream_status[i].plane_count != 0 &&
+		    amdgpu_ip_version(adev, DCE_HWIP, 0) == 0) {
 			irq_source = IRQ_TYPE_PFLIP + acrtc->otg_inst;
 			rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
 			if (rc)


