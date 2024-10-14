Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18CA1AB51B;
	Mon, 14 Oct 2024 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919003; cv=none; b=oUH0OPCjz5mo9dAiAHIabXRw2T/t9Avh/mOaWcurRWESCOdAZia9xdMDURIB4zKGYIQ3fWW7vmq1XUCQrGLKuVb9TOlfGHeWy+hO4/wvTe7A8YdekxVKe4oQr+nAGPRP1XK/F2Kpj26/tlbVUMuaKGk/xI8r1mYxykRkT7fMPuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919003; c=relaxed/simple;
	bh=jFIaRfBB5SH7KvCrDb3Z/Hw23Iq6/dv4FztrYlo/tZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFq8eD1tnBQyVgK+WTY833SCzqYxL56fPz2YqSo7IdG4nQwHMe7+2OeW+ewUB4A3LuVcMcH3XuHxQU2OetzIEelgYHLS03fDKYeEJhq/zoqq5v5TmXcMroEq8JaHkt+QeRd+LJQZ0AmgOBKH0Y/DnUd5zA5a2zjBOayPXl1/7v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Seyh4yrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Seyh4yrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE99C4CEC3;
	Mon, 14 Oct 2024 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919002;
	bh=jFIaRfBB5SH7KvCrDb3Z/Hw23Iq6/dv4FztrYlo/tZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Seyh4yrPW6Z2tIcYV7sKWIX6Z1+fXXrAvIi95YVtnlPr2oLcNrCtlGk4qdirhhUnc
	 18034gvl6QAgdTdZhLFcJmQGAW441NEbRt/VHPIu7f2jCb3hCXBFDhDTUW1DLY0rUs
	 ieiG3cUyKz2CnEsM8y7qvE2wXwwnEe0rz1/2Dq4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/798] drm/amdgpu: add raven1 gfxoff quirk
Date: Mon, 14 Oct 2024 16:17:19 +0200
Message-ID: <20241014141237.026465926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Peng Liu <liupeng01@kylinos.cn>

[ Upstream commit 0126c0ae11e8b52ecfde9d1b174ee2f32d6c3a5d ]

Fix screen corruption with openkylin.

Link: https://bbs.openkylin.top/t/topic/171497
Signed-off-by: Peng Liu <liupeng01@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 6a1fe21685149..b977431c13b8d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1173,6 +1173,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
 	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
+	/* https://bbs.openkylin.top/t/topic/171497 */
+	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



