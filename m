Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA15446C9;
	Tue, 20 Feb 2024 21:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464783; cv=none; b=BQQldPsLUmQtXhb1X7Hbx02t6mMCTx8IPuhiwNZdJikh3+weNWiyW/MuNwr8QZVYQk49Hq4KGs5GsnwvNw+RVzPVuGwMKMgtBe3jMccz+o71eBeXP1+sQp1KED4QVurrvTmEgnfY45+e/uC61rq2Stdu2jbDoKKnxdA7IxZDPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464783; c=relaxed/simple;
	bh=SxgGnot2hyZVs/NLuD+F/32Lq4spQrBU+O51jVUaJa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKHxiZ2PDVJtFtF1DOzSSRwj5wxHeJgSgyDZMWFhyeo4QX0ezaWFa81iC34HfoLK+GDAGYQZ48AIO4CxmtHGjKcpsGHjhM2nrrLNiOOpjHS7ZTH2M+LzKkrqS2SIRlYfkVv6o+UWRizNjxRB8YzDSvmjYJ9iuth5KI9P3sVKyoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veXOC0j3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veXOC0j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0E8C433F1;
	Tue, 20 Feb 2024 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464783;
	bh=SxgGnot2hyZVs/NLuD+F/32Lq4spQrBU+O51jVUaJa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veXOC0j3PHhRbRbOjLU6YdUBlBXMcV/zmiQYNFk5ti5XjSpxAEVLJPCCmd+m/Yibq
	 kn0YPQa+kIgQc0iC5TNrDpJPrBB+Lji7/DqD50tXoftfKa0A6ZTNcCbok8QOx4FUtL
	 fITgg2QeUKQCbbPmEiZJEYfBX4K+97CWrOwSX/DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McFarland <corngood@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 136/309] drm/amd: Dont init MEC2 firmware when it fails to load
Date: Tue, 20 Feb 2024 21:54:55 +0100
Message-ID: <20240220205637.392087480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4027,8 +4027,6 @@ static int gfx_v10_0_init_microcode(stru
 		err = 0;
 		adev->gfx.mec2_fw = NULL;
 	}
-	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_MEC2);
-	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_MEC2_JT);
 
 	gfx_v10_0_check_fw_write_wait(adev);
 out:


