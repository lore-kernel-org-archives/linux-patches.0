Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E88283129;
	Tue, 27 May 2025 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368662; cv=none; b=cz6hVjRr7HSDPuUk9IO9nigZNJIINOg4nv3ljXEATrIQ5oqkuj2XQqzJQNxXaOv9MNKZdblP+xZ8srVTnx5mGw1DUrnASxexjRYPe4Mx/Nbo30gUQg2dkLBAGzg1NFtdGJMwE7j6rn6zoN2GTlkxnZprN7pcCDTPrGbe6j3VecE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368662; c=relaxed/simple;
	bh=NcFoMqeqRk9aaMeJdhtxBhUbyHqUu5tHVxWmEk+u28A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKAmkoZI/TGl7nwE+CJv1HWXVY0Q2DfsQezOxUisMTTEsI4tbh4iUbobxlxEuYnX1gFRzMW5PytsxlulbAXuZteFDS4xIg3frjbjIyMdRz1vpY2HVIdEniH+4C0x40A0r847B4Wm7m8KpLC5fms/ndaQ/6vr9TbGkuqWXSguuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x23EtgII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x23EtgII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049C6C4CEEB;
	Tue, 27 May 2025 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368661;
	bh=NcFoMqeqRk9aaMeJdhtxBhUbyHqUu5tHVxWmEk+u28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x23EtgII04dFnnZGu1V92dw04nFfPByPwLWDDGULnggzeULs+VHm0K8UEyvo50UxS
	 Hn8jZTuneN9ELVaFluoq2hL6qQUdcV/y6BiyPUfsFhP9i5u7arCuFTBphNhm+Y2Au9
	 GDuO2vf2kOLiVvnyzqFzQ1RB0gHXwJExXFHum2Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.14 748/783] Revert "drm/amd: Keep display off while going into S4"
Date: Tue, 27 May 2025 18:29:05 +0200
Message-ID: <20250527162543.593524266@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7e7cb7a13c81073d38a10fa7b450d23712281ec4 upstream.

commit 68bfdc8dc0a1a ("drm/amd: Keep display off while going into S4")
attempted to keep displays off during the S4 sequence by not resuming
display IP.  This however leads to hangs because DRM clients such as the
console can try to access registers and cause a hang.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4155
Fixes: 68bfdc8dc0a1a ("drm/amd: Keep display off while going into S4")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250522141328.115095-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e485502c37b097b0bd773baa7e2741bf7bd2909a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3392,11 +3392,6 @@ static int dm_resume(struct amdgpu_ip_bl
 
 		return 0;
 	}
-
-	/* leave display off for S4 sequence */
-	if (adev->in_s4)
-		return 0;
-
 	/* Recreate dc_state - DC invalidates it when setting power state to S3. */
 	dc_state_release(dm_state->context);
 	dm_state->context = dc_state_create(dm->dc, NULL);


