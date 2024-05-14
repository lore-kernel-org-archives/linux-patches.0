Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E434205D;
	Tue, 14 May 2024 10:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683069; cv=none; b=g0YPbUYee7IJLhfHVM2Q4UZMrqE3mqA7hT5FYJz0JLkwrf7KdRy9dnnFIFdHDRpYrBu6W08L67mhPNQ1rOpCF48TyoAIA8DgQnrudG0CUn3ll5pAnnTKwmErXuY+I2wbT2KNsz/LM/nDFE5yD44O9ON9awCOXMNysCjFB3CAwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683069; c=relaxed/simple;
	bh=6pwAItDthvPIXvKBD310uiOf/xEoNrXJb8dcrI4T5rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peyhR6a3OFB91IRfpXf3g72U2hOxhMVelVnAbl8R+NLgVhRaYxIgWr0qAcA/KdIHsSxH9SGbbJH8d9wvsiDHgvICioJdkKBiezvnpNei3pdahumx8lXvwCNVF52x2edMjZXatWK53BhZz3OH/zw9KohDewb8AzV1n7gy+zkpTXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUmfOvjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUmfOvjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AE1C2BD10;
	Tue, 14 May 2024 10:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683069;
	bh=6pwAItDthvPIXvKBD310uiOf/xEoNrXJb8dcrI4T5rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUmfOvjQsMN1+pDYTZAgMF0HvhntNkBpkw0c7jqDB9pTULirOOXpQYG7t7JBGCxPe
	 j/lEF76d2O/6fnfD66fjW1n2q4WDL8tZ7wXrNvtxbJqmoq+1MShijuBjokC53CQMh4
	 XwtX3F4X40Jc21geerFTa8ErdfPhL4Mno1yANpwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 161/336] drm/amdgpu: add smu 14.0.1 discovery support
Date: Tue, 14 May 2024 12:16:05 +0200
Message-ID: <20240514101044.682156612@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 533eefb9be76c3b23d220ee18edfda8eb56cefff ]

This patch to add smu 14.0.1 support

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 4f9900779ef9e..ff28265838ec0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1867,6 +1867,7 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 		amdgpu_device_ip_block_add(adev, &smu_v13_0_ip_block);
 		break;
 	case IP_VERSION(14, 0, 0):
+	case IP_VERSION(14, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v14_0_ip_block);
 		break;
 	default:
-- 
2.43.0



