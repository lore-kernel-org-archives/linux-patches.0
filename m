Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CF5151CE5;
	Tue, 20 Feb 2024 21:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463695; cv=none; b=Q8rASw07GlNDj1ZtZ4UL5XRbiKr8p7Cx9lVnxZcLuOmseng463m55dMUhAY3uFKIcejzrQe4/2JZf+0/56KSrfz9vPTl1ANZeDXF9GxxX5Z7/B063gaRC/u2TgHYQ3yZNZXdvY81Q+yr3NDnlCeyHh/RmmsBiTl/7Tb7lUxLfI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463695; c=relaxed/simple;
	bh=MCuQHp4LLVCk6CpzIG00cSenUeUAKT0qhfnCIjKpYT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul88MfcycRxnVto7aUlKhz4XOPpiV+ub74gWEKPI2MvK9vz57cXnFmVOT7olbSDWgn283dqppN1wUonWnw82fJxh2iRU88YbRV6pIjGVnl1qLm9Hh2QuiLIQCV5FQgNxktPGizfJM42uunjs2HTSzvSqj1V12rFKYd3AAlwvGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epZpEczK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epZpEczK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F0EC433F1;
	Tue, 20 Feb 2024 21:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463695;
	bh=MCuQHp4LLVCk6CpzIG00cSenUeUAKT0qhfnCIjKpYT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epZpEczKdTsPTYn0ccohOQ6fFselMkigTz5RTtU5FX42go0xcAtx6cnPQa9CbexLf
	 nERqdB+a0QzNnMTAAUcf9cRih2zXygag8/YqR0QDz0X/lwa27Sgu4e0zitgnDcsECJ
	 kFBUQ6nM5RtO/4XChFNjx5/X3ULazZo7HBDhRyNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McFarland <corngood@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 124/331] drm/amd: Dont init MEC2 firmware when it fails to load
Date: Tue, 20 Feb 2024 21:54:00 +0100
Message-ID: <20240220205641.493771336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David McFarland <corngood@gmail.com>

commit 8ef85a0ce24a6d9322dfa2a67477e473c3619b4f upstream.

The same calls are made directly above, but conditional on the firmware
loading and validating successfully.

Cc: stable@vger.kernel.org
Fixes: 9931b67690cf ("drm/amd: Load GFX10 microcode during early_init")
Signed-off-by: David McFarland <corngood@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4020,8 +4020,6 @@ static int gfx_v10_0_init_microcode(stru
 		err = 0;
 		adev->gfx.mec2_fw = NULL;
 	}
-	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_MEC2);
-	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_MEC2_JT);
 
 	gfx_v10_0_check_fw_write_wait(adev);
 out:


