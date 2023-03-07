Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749DBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C71C433D2;
	Tue,  7 Mar 2023 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211015;
	bh=/SVtR0+JHOmhMrV2LTdPx4L5lYPsfb4KeJx0JuNTBE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCmh8ciaqDNJpmYB8Gr2vz+WJlejS3mGfM7VeiLj2+jFZ1dASppzvMRM+OwZU5Wwp
	 NP0akEGnoxJQDE0k2iiNmZp3f7gK7aPMYM6gICpfmowr4LyFrUvvbWQE4j+kUceEeg
	 ap/sSMWoLL7MN72aiPxIwMLhqUYvBxV9YRUkgBIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0696/1001] drm/amd: Avoid BUG() for case of SRIOV missing IP version
Date: Tue,  7 Mar 2023 17:57:48 +0100
Message-Id: <20230307170051.823466791@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 93fec4f8c158584065134b4d45e875499bf517c8 ]

No need to crash the kernel.  AMDGPU will now fail to probe.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 7a2fc920739bb..ba092072308fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -380,7 +380,7 @@ static int psp_init_sriov_microcode(struct psp_context *psp)
 		adev->virt.autoload_ucode_id = AMDGPU_UCODE_ID_CP_MES1_DATA;
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 		break;
 	}
 	return ret;
-- 
2.39.2



