Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA6269839;
	Tue,  8 Apr 2025 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116211; cv=none; b=scp/MbCcVkdd7yPxwBpgeFRZWNDH8CdPTp4UkmAME7PG8i/Ftd/IHjzSs/8jnrAiPizHugHapL9bDj9cB/MXQgQCrY51aVsSqojsiaZpaiIj5hY+cQp9tmQT8ACgnB6hr7sJf26sfaInpoLkj5HOp7kLvVzHmUCP7uyMusr70cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116211; c=relaxed/simple;
	bh=tRvWhDehmHDb+k8pOLRx0GYLVn5jPwTV+yM0rw6k3wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBDBfuCMQHQO4gGEwQ2N0SoaCOkro+2FquC69fw6l0vPStKu9t00zPhmAIhGpi+sG5T5KUONMykaC3QW89cEqb7XayxZPhzspALz5bqe8kVBvUwQs3FzjhSrXmBXo+bojc+Ikv/BiCdreNYotuF+ftAmVb+y0NWX47wnbEmKzKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJXEXtmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJXEXtmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4571DC4CEE5;
	Tue,  8 Apr 2025 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116211;
	bh=tRvWhDehmHDb+k8pOLRx0GYLVn5jPwTV+yM0rw6k3wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJXEXtmpYzal3jkHei2n7ki9LaP1bgaBovxBzAR9eCj8rILfdTeMXLcxO2O6hOqPt
	 tDASUHQH89yl23aa6mCOsuFRLvnJA8g0MRkfdL7F5MXEz1t6MzIjMTr3xt3Hdx0ZwN
	 oK0QEKIMm+nNDmQhtcRBTn/zHYWmsZfPgyCdtoBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lang Yu <Lang.Yu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/423] drm/amdgpu/umsch: fix ucode check
Date: Tue,  8 Apr 2025 12:46:23 +0200
Message-ID: <20250408104847.077130737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c917e39cbdcd9fff421184db6cc461cc58d52c17 ]

Return an error if the IP version doesn't match otherwise
we end up passing a NULL string to amdgpu_ucode_request.
We should never hit this in practice today since we only
enable the umsch code on the supported IP versions, but
add a check to be safe.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502130406.iWQ0eBug-lkp@intel.com/
Fixes: 020620424b27 ("drm/amd: Use a constant format string for amdgpu_ucode_request")
Reviewed-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Lang Yu <Lang.Yu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
index 6162582d0aa27..d5125523bfa7b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c
@@ -584,7 +584,7 @@ int amdgpu_umsch_mm_init_microcode(struct amdgpu_umsch_mm *umsch)
 		fw_name = "amdgpu/umsch_mm_4_0_0.bin";
 		break;
 	default:
-		break;
+		return -EINVAL;
 	}
 
 	r = amdgpu_ucode_request(adev, &adev->umsch_mm.fw, "%s", fw_name);
-- 
2.39.5



