Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD2198841;
	Thu,  5 Sep 2024 09:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529619; cv=none; b=XZ5rvp6hPlnQgtfWU1zi/BqhV1xE2NOSgY87Vl+C/U/VDOOAtSe1051osledMQi18wRLBB26P41fVoTaFRvx5ry7otzPe/e7YC3eUS0zq39+ljaUilbDT8BIFcjXF7X0Gf/GlI4JXfPTSX09feq5NxQN5ttHTicNSsxJJqqSSW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529619; c=relaxed/simple;
	bh=rrZbMF++nURR1t7b8VyaMHZ/npUitgmIWcNkW/tiHaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4sK9GaPyofX8o+el5aClqjXWdMbDpIs0no6Syz2lWIw+7hjIMyFo68tPqq0KyV406UnNythFbhcrs8dpPN9tyvQY7LLahz2IsQ7L5j4wN7IwEtHQSvkNMnz1TRBnjehNP5n06HvHQDOX9EA7rvaO7CWhIwjR//Vry8eHNowkAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQzUO/z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQzUO/z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE41C4CEC6;
	Thu,  5 Sep 2024 09:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529619;
	bh=rrZbMF++nURR1t7b8VyaMHZ/npUitgmIWcNkW/tiHaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQzUO/z6gvDCOdPO8hOr7MbpMOn1TjdxDjwZiL2RYANrcaPFuvbifaikLAMokB8tB
	 hYsxSh69Yo1dyGVlforkD9TwYoleCbT2KnSTzuk42x2MLHmO4TvZsYAEi9C9xhjTgS
	 qLxPtaRqFnvkvgJq8skl75zlmVl8PDuJMzIiDFAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 089/184] drm/amdgpu: fix uninitialized variable warning for jpeg_v4
Date: Thu,  5 Sep 2024 11:40:02 +0200
Message-ID: <20240905093735.717650339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 9e5da942594034ec377ba8c0caa9c15e1d26ba08 ]

Clear warning that using uninitialized variable r.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
index da6bb9022b80..4c8f9772437b 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -187,7 +187,7 @@ static int jpeg_v4_0_5_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct amdgpu_ring *ring;
-	int r, i;
+	int i, r = 0;
 
 	// TODO: Enable ring test with DPG support
 	if (adev->pg_flags & AMD_PG_SUPPORT_JPEG_DPG) {
-- 
2.43.0



