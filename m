Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD22D73B9;
	Tue,  6 Jan 2026 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721216; cv=none; b=Y66u7T8u2/Dar3c1lRjqecVAfhTDkd84vVMuY9ql3sFW58wBlBqhhOoHykiDqAMGxkch6psckRMawzqBEg2KEMylefuMVLkjssLRy+yVcSaF5HhKEJkuSRRlYAMgrD1r5o+E9G4sfnp+4W4tidEia4HZlOfsF6q1B0+I4Zmzesw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721216; c=relaxed/simple;
	bh=0wuhMG1OIY7x+Q/YzFEQXWE6XYDWMYlxd6BgrSlW6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KexKW+wTqPMHeR6RnZ4axI8HXzM24MjDwCEJ91GPfM5TPmF0ymJEAApCUVH3GG5X8FEJoxRT1ljGDgdhVux9zn65J1SFZ5yvzfoEhY0sY+Ulu3lw4CXGTKbiqyFj6PJ7R5V/cuM7QP2uXfbyPaEEef0RIMGitvso0RCk45cG70U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cavIzn+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cavIzn+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59540C19423;
	Tue,  6 Jan 2026 17:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721215;
	bh=0wuhMG1OIY7x+Q/YzFEQXWE6XYDWMYlxd6BgrSlW6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cavIzn+TJLKdvoUm4NBhU5RK3W37W/rGw5zFHe3scUx2IJjmzNezxSJenXJxPmTcp
	 OuUddGgi82vzv66bIDUDs+/dayvM2WZx2fCVsDQvDaMS2HPspOEffim663E52HFfDo
	 GNIuyy5ztahGmMb8hgEx2HwQ6wMfQs+mRDeSNZ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 471/567] drm/amdkfd: bump minimum vgpr size for gfx1151
Date: Tue,  6 Jan 2026 18:04:13 +0100
Message-ID: <20260106170508.775781097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

commit cf326449637a566ba98fb82c47d46cd479608c88 upstream.

GFX1151 has 1.5x the number of available physical VGPRs per SIMD.
Bump total memory availability for acquire checks on queue creation.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b42f3bf9536c9b710fd1d4deb7d1b0dc819dc72d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -408,6 +408,7 @@ static u32 kfd_get_vgpr_size_per_cu(u32
 		vgpr_size = 0x80000;
 	else if (gfxv == 110000 ||		/* GFX_VERSION_PLUM_BONITO */
 		 gfxv == 110001 ||		/* GFX_VERSION_WHEAT_NAS */
+		 gfxv == 110501 ||		/* GFX_VERSION_GFX1151 */
 		 gfxv == 120000 ||		/* GFX_VERSION_GFX1200 */
 		 gfxv == 120001)		/* GFX_VERSION_GFX1201 */
 		vgpr_size = 0x60000;


