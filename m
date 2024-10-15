Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D8F1D8DEA;
	Tue, 15 Oct 2024 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993595; cv=none; b=n5aBAl4ln/qbEl5lwRwmUw+xfgp7+yF1j9X0WhMf8Grr9ffZLozBP7NJOqdd8B1zNT3X5/C6zCul8+L++NUROemEsLJDleNzt8JX57crGQvRBKHIwtUzfL3ooVZL36KRydx66/lydCC6u+nHYJRk1R/4eqVb5NPFDq8Ia/Y1Zfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993595; c=relaxed/simple;
	bh=TKjS0dEGNzwTddDAvT/VWnKz/T9Q1QUBucCokR795yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRv+40CXjUpflrzz4bw/6m0zgWcomIb1mSA1WRPdWLOgPIp1KQ3He3gMYTEwTfgwhQBGjD6sZFLdwoHyltcjui3Ed69F8QfmndsZBo0zVPk0gO8PfDSNWY/iPEZlz8utxrMiuy5zggG21Cr52OSO3sgQneWb7VnW4nmoXy/q4xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rA48egv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rA48egv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9C7C4CEC6;
	Tue, 15 Oct 2024 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993595;
	bh=TKjS0dEGNzwTddDAvT/VWnKz/T9Q1QUBucCokR795yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rA48egv+agur+pv+BKC3ufmqyLbEfOfoqa4Sf4nYbOgePVZRTCFGlGs131L+oDSdK
	 5gtScDW8B9FLHm6uKCQw3gNBCzpoHDXPjfNQAONxrV5Gwk/1kwu+rxUXzgejBGreiO
	 5EngQw8vt82V6IZTFabqWq0pa5Ftq2Ic1UQT055Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/691] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Tue, 15 Oct 2024 13:26:47 +0200
Message-ID: <20241015112458.564683679@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cebedffc44c09..811cacacc2090 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1276,6 +1276,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



