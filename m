Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF01B1A6192;
	Tue, 30 Jul 2024 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357656; cv=none; b=YA1Vz7puN3bNMq6fzf02Vm2x67cfNfiSyPdF2trZbSZIE1/Ntv7Epk+rAw5y/G1qwggElSK4gcwqC6IRKNTzevQCUzbVjS9q2LipnMEWGBtOeHyHOh3dGuquEHKhWDrD/OeDjdXvgFAkfuRzBVbLTymQHm6d0Me1uhGs+TDJZkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357656; c=relaxed/simple;
	bh=oRjM1XhENPjFU0LCSYqEVhTUEhuMN2YZOmKlo89GERc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgXTWI44rg/sNbwrC7Wh5zUjXTfukrZEdkyUE8tYwBTN1A7E1E+Vu5r6s5cMoQfSzfHixMhBkfkYl9c7gyytA2OhC8gaBMXfYLNgjYVWNcXtHm97kTbP1H3xiFgxN6UJQZ81uAbYT4GOekuOE4v38OYR3whvJbsDE3CyEtnztYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9r3ZIcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9r3ZIcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DF4C32782;
	Tue, 30 Jul 2024 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357655;
	bh=oRjM1XhENPjFU0LCSYqEVhTUEhuMN2YZOmKlo89GERc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9r3ZIcZxzJo8037WZ2Utrs/OF5p2R1wR8XqDR+Qplug8JgpXjbeD9+0zIRxTsFjy
	 xm0j5lC9c8jwPMlFEGqamGdgVxJfFkthNR98/regqpcitoLnLt1xocpZ5pXCNVlxfF
	 PN+UrehN6mxgtkrmuyVvvaX7MWPnk1vjkZOGjNA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 276/809] drm/amdgpu: Remove GC HW IP 9.3.0 from noretry=1
Date: Tue, 30 Jul 2024 17:42:32 +0200
Message-ID: <20240730151735.496143817@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Van Patten <timvp@google.com>

[ Upstream commit 1446226d32a45bb7c4f63195a59be8c08defe658 ]

The following commit updated gmc->noretry from 0 to 1 for GC HW IP
9.3.0:

    commit 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")

This causes the device to hang when a page fault occurs, until the
device is rebooted. Instead, revert back to gmc->noretry=0 so the device
is still responsive.

Fixes: 5f3854f1f4e2 ("drm/amdgpu: add more cases to noretry=1")
Signed-off-by: Tim Van Patten <timvp@google.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 08b9dfb653355..86b096ad0319c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -878,7 +878,6 @@ void amdgpu_gmc_noretry_set(struct amdgpu_device *adev)
 	struct amdgpu_gmc *gmc = &adev->gmc;
 	uint32_t gc_ver = amdgpu_ip_version(adev, GC_HWIP, 0);
 	bool noretry_default = (gc_ver == IP_VERSION(9, 0, 1) ||
-				gc_ver == IP_VERSION(9, 3, 0) ||
 				gc_ver == IP_VERSION(9, 4, 0) ||
 				gc_ver == IP_VERSION(9, 4, 1) ||
 				gc_ver == IP_VERSION(9, 4, 2) ||
-- 
2.43.0



