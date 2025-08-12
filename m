Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC832FDC5F;
	Tue, 12 Aug 2025 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020540; cv=none; b=srwA9Mp2Q6NYPl54PVwIF6TRBOjN8P4RsLDTzV7V6+wE4hCyJLiiPlART9g5DGQYGXVPH4Lzi82M+Uz7AH/cvShCXK4fv2YFPBwgJRX84ei/hZOwzUyu/E4B94NZxuJabqPbi48vu0n7Ijeq3FQh5zo99XxGRZg1B6ky16ntR2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020540; c=relaxed/simple;
	bh=P/Axl7Dj0bqHP/a8Syjx6k8rKnqmgelR6G+UqfjJa1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqZaWgteJTqR4+2YGzD7Xk/7YJNvY1TT2ZkWDlMcJ3Ac/8GAkRVjAvoYw7oGCnix6iFAItEDPiIOruRtHrK7qZS2PEhiMVu5YGnSlWRFRps3gWq0kXKi9RTi580Q1xxPhjuj+loK/WPMksUW+wERk5GFHmqr8er9seDcRln7ZGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evNPC9l0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evNPC9l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AA5C4CEF0;
	Tue, 12 Aug 2025 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020540;
	bh=P/Axl7Dj0bqHP/a8Syjx6k8rKnqmgelR6G+UqfjJa1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evNPC9l0swFt35ypbR+vXdtzXcDMiN4WhqMcC8/LsY+jbE5TmQxTif5NeAUZ36QqU
	 3UGLGuq1aGSj9hf7eUwEZtf6itkVBQbe7fy1vxf27vQr9cFrf0jo2A/FMTzdQsllqB
	 wTFCWAvheWPzwusmefinsq6YmuNPCEcjwoobOz10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/253] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 12 Aug 2025 19:28:19 +0200
Message-ID: <20250812172953.443003530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a54e4639c4ef37a0241bac7d2a77f2e6ffb57099 ]

There is a small typo in phm_wait_on_indirect_register().

Swap mask and value arguments provided to phm_wait_on_register() so that
they satisfy the function signature and actual usage scheme.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

In practice this doesn't fix any issues because the only place this
function is used uses the same value for the value and mask.

Fixes: 3bace3591493 ("drm/amd/powerplay: add hardware manager sub-component")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
index d0b1ab6c4523..54d191b2dc20 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
@@ -149,7 +149,7 @@ int phm_wait_on_indirect_register(struct pp_hwmgr *hwmgr,
 	}
 
 	cgs_write_register(hwmgr->device, indirect_port, index);
-	return phm_wait_on_register(hwmgr, indirect_port + 1, mask, value);
+	return phm_wait_on_register(hwmgr, indirect_port + 1, value, mask);
 }
 
 int phm_wait_for_register_unequal(struct pp_hwmgr *hwmgr,
-- 
2.39.5



