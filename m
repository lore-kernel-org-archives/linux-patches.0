Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C221E51A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRp/BIkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3387C433C8;
	Tue, 31 Oct 2023 17:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771893;
	bh=7cOqsuz18i8YjqyuKG4ojYZVAazoe5zhtpiFgMofdDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRp/BIkEiBKpvyzFEB22eXqfuwRZz+LZh5Jjm2mTGDX4yLCotjWtoibjYEECcGG5f
	 LpjvUaafhmFuj5V9Xq3mwTCIzZUYSpEa53jDhy9EPFBw8Gc963Hg3clul+ddVUrgqY
	 lNdPJT3xI4bpxjdi3xvhBq/CFvyeQAGBPErpM7r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Paolo Gentili <paolo.gentili@canonical.com>
Subject: [PATCH 6.1 28/86] drm/amd: Disable ASPM for VI w/ all Intel systems
Date: Tue, 31 Oct 2023 18:00:53 +0100
Message-ID: <20231031165919.488951590@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 64ffd2f1d00c6235dabe9704bbb0d9ce3e28147f upstream.

Originally we were quirking ASPM disabled specifically for VI when
used with Alder Lake, but it appears to have problems with Rocket
Lake as well.

Like we've done in the case of dpm for newer platforms, disable
ASPM for all Intel systems.

Cc: stable@vger.kernel.org # 5.15+
Fixes: 0064b0ce85bb ("drm/amd/pm: enable ASPM by default")
Reported-and-tested-by: Paolo Gentili <paolo.gentili@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2036742
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vi.c
+++ b/drivers/gpu/drm/amd/amdgpu/vi.c
@@ -1147,7 +1147,7 @@ static void vi_program_aspm(struct amdgp
 	bool bL1SS = false;
 	bool bClkReqSupport = true;
 
-	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_aspm_support_quirk())
+	if (!amdgpu_device_should_use_aspm(adev) || !amdgpu_device_pcie_dynamic_switching_supported())
 		return;
 
 	if (adev->flags & AMD_IS_APU ||


