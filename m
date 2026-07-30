Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4A2442FBF;
	Thu, 30 Jul 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422390; cv=none; b=PiOB+i/NRFn6W/p1H7Qc6/v8MJ/eHXyUXqqfFwx0zkR0i6QAgoYM+SCyHXQup6fBYgxklgcS7sKvJgFfQ9w2oZD1kQiyS4YmvXtbmRNaDnseWMiuMPGvYFFE0lxrjqHhylJrdGTltdxzfxVZ1rZwyjtzMHtaDjHat6logDNqS1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422390; c=relaxed/simple;
	bh=tNk0Pz249113+5Xn/ijHkhrQIQVqS4T7byyQL8NCpt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GajmKH4hBO4bKqHmM8H7RZ1+QTGD3s/vxvRycMLuI792LZ9WYx2Usnavd/rOkAnRn7DefC3ckSi/0wRfcpfeu7oISIkANEatt/IiXAY3xZTm+xV+VmHKnGRzchJFO1kiTkytekNyBatVE7DJPJQJhcc1s2YEGFhnHrQuz5lV+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly1OXeu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly1OXeu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A111F000E9;
	Thu, 30 Jul 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422389;
	bh=xXqQ2yrcOVTCtdHUFTg+7TqO22aqEa/T8T9UCfRBWY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ly1OXeu7mXxfXdroP6aO9WoM/HAogy/GWirCXzHn0ZNcL1DE0aFblPtsS1EMA1eEf
	 j7/MN2lpDu2gQPVHALYX0wi/AWBEeFSnH/bLjCpSgc2b8HJASLPLgxA93dypYrhE5D
	 bpOs/JjCxtovnqDTo+wPq/tSrNmtTPqF+wIe5JVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 422/744] Revert "drm/amd/display: Restore 5s vbl offdelay for NV3x+ DGPUs"
Date: Thu, 30 Jul 2026 16:11:35 +0200
Message-ID: <20260730141453.266682403@linuxfoundation.org>
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

commit f39283eab44fb7e304677b2aa1d8c38f151b6566 upstream.

Now that proper fixes have been found, let's revert this workaround.

This reverts commit a1fc7bf6677eb547167cb72b3bcafdc34b976692.

Tested-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f64a9be5653689ff43e148cd8a6483077488c8e5)
Cc: stable@vger.kernel.org # 8382cd234981: drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock
Cc: stable@vger.kernel.org # 48ab86360af1: drm/amd/display: check GRPH_FLIP status before sending event
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9427,21 +9427,9 @@ static void manage_dm_interrupts(struct
 	if (acrtc_state) {
 		timing = &acrtc_state->stream->timing;
 
-		if (amdgpu_ip_version(adev, DCE_HWIP, 0) >=
-		      IP_VERSION(3, 2, 0) &&
-		      !(adev->flags & AMD_IS_APU)) {
-			/*
-			 * DGPUs NV3x and newer that support idle optimizations
-			 * experience intermittent flip-done timeouts on cursor
-			 * updates. Restore 5s offdelay behavior for now.
-			 *
-			 * Discussion on the issue:
-			 * https://lore.kernel.org/amd-gfx/20260217191632.1243826-1-sysdadmin@m1k.cloud/
-			 */
-			config.offdelay_ms = 5000;
-			config.disable_immediate = false;
-		} else if (amdgpu_ip_version(adev, DCE_HWIP, 0) <
-			     IP_VERSION(3, 5, 0)) {
+		if (amdgpu_ip_version(adev, DCE_HWIP, 0) <
+			   IP_VERSION(3, 5, 0) ||
+			   !(adev->flags & AMD_IS_APU)) {
 			/*
 			 * Older HW and DGPU have issues with instant off;
 			 * use a 2 frame offdelay.


