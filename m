Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833551DE89A;
	Tue,  8 Oct 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393429; cv=none; b=QVsJJ4VIyXr/+LHbkNyH6M6Ve6/22QE51iGdXtobuS8iZbNvApTE0qf4vJu4bqEAROIWndH+P3Qma/i0xtrPhs8HyztnqV9Pe7W8Mc3qLtCwI8Pb43OnBptBOE1CptdGdCydPdzbD0Ahce1ZDB9gnXmNv2Tv1B0wKYkqIU8oubc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393429; c=relaxed/simple;
	bh=FUO+z758MnlDP0Nx/H1i/HRuWeTII0X1lgJJytgpy7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fO35Cjue3pMle/j04qjLNYTLOnvIJS0h1LjIZWcvFHvBDRtdRWWjgsSU5Ls/qILau/gQbQijy5n80yYR/5SHIF1cYfYcrLbnTzqDUVIpooD3YstvJSyp1dezoaZX6fgytQmt+wUQpXt8XaUxhI8eI3TZLVCt+Hz1Sf3sAclS5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJTiO/iF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJTiO/iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE60C4CEC7;
	Tue,  8 Oct 2024 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393429;
	bh=FUO+z758MnlDP0Nx/H1i/HRuWeTII0X1lgJJytgpy7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJTiO/iF5ea2ODDKVs2Xu4t2h9/LJOTGAobv0kAqvB4x8IV8c7hBfNz7pQiUHKZf0
	 yxAIJv5V7hNE2oH1D5lkI/+gpU/5rHCyNvJxZBGKIWPa+tycm25rHYu/HkfEXlKJRc
	 1xkVJZ6m3Ki+vTVcTaD8txWevp3wTYx5LHGQE/hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/386] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Tue,  8 Oct 2024 14:06:34 +0200
Message-ID: <20241008115635.291798340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Peng Liu <liupeng01@kylinos.cn>

[ Upstream commit 2c7795e245d993bcba2f716a8c93a5891ef910c9 ]

Enabling gfxoff quirk results in perfectly usable
graphical user interface on HP 705G4 DM with R5 2400G.

Without the quirk, X server is completely unusable as
every few seconds there is gpu reset due to ring gfx timeout.

Signed-off-by: Peng Liu <liupeng01@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index c28e7ff6ede26..00e693c47f3cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1174,6 +1174,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



