Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CA72BAF7;
	Wed, 25 Feb 2026 01:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983077; cv=none; b=TTd1mtQDjqoimkU94n4V3BcYiNutCAyjOOxjAW+CDO5TBomwC5IflS8CJ7LUPBYIlsYOS06tWV8mTATITi4MirTwDGV7eoHA1QliHeXy5T5vylqjy7Rg8uKBNmXeOMhWaLoL42mCrh4nXou+y+D2iYy2jNrHkfaaUzNUpMplH2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983077; c=relaxed/simple;
	bh=yc0C+otxbZMrbUtDiVejUeFERJvI6safT3kM4Akdggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGVXmavPclAF4LE0jXf9zLGRofvjkbu52VYnQPDmU51EBuiZJStWxP5kiYDGiuSOQBrf5VmxafHRuOZoIjUw2skjsaiR+agoOUN2EOM7HszWu6OdYzbug6euL4SCYUvT+IPoRXc+4cW1mCvnPAQ+nZwQSphRlLb21pp06wjZun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELfr+s3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELfr+s3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6747C116D0;
	Wed, 25 Feb 2026 01:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983077;
	bh=yc0C+otxbZMrbUtDiVejUeFERJvI6safT3kM4Akdggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELfr+s3GGDLvB/YsRzHWe92LpvNdIioNmwGyWu8OL7Xv3gpGyzbdQ09px2mrTXsz7
	 Mz7aSvbTDgTX2+UGfhmzP8z+QLkdXGwBBPzDtlRsQoXqoZMpIF4ykdHcWqkK9ww6+8
	 wgZnjnPloJpT0EvLJwfCRKmrAd4k+g3hhQNXrC/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 238/781] drm/amdgpu: Describe @AMD_IP_BLOCK_TYPE_RAS in amd_ip_block_type enum
Date: Tue, 24 Feb 2026 17:15:47 -0800
Message-ID: <20260225012405.545678057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit d8ccbb5e228b093eba19027a281274e7faf2da4c ]

Sphinx reports kernel-doc warning:

WARNING: ./drivers/gpu/drm/amd/include/amd_shared.h:113 Enum value 'AMD_IP_BLOCK_TYPE_RAS' not described in enum 'amd_ip_block_type'

Describe the value to fix it.

Fixes: 7169e706c82d ("drm/amdgpu: Add ras module ip block to amdgpu discovery")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/amd_shared.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index 17945094a1383..ac2d3701e2bdc 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -89,6 +89,7 @@ enum amd_apu_flags {
 * @AMD_IP_BLOCK_TYPE_VPE: Video Processing Engine
 * @AMD_IP_BLOCK_TYPE_UMSCH_MM: User Mode Scheduler for Multimedia
 * @AMD_IP_BLOCK_TYPE_ISP: Image Signal Processor
+* @AMD_IP_BLOCK_TYPE_RAS: Reliability, Availability, Serviceability
 * @AMD_IP_BLOCK_TYPE_NUM: Total number of IP block types
 */
 enum amd_ip_block_type {
-- 
2.51.0



