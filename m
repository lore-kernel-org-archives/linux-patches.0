Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B41F1E7C34;
	Tue, 15 Oct 2024 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993592; cv=none; b=HdsMBhQG7i1BimLk7u7g0CqrojXUftlcc0BfOGshzOIdWKX0daPE2YesNHSKgug3iEf3CTII+WQGCbVXLNNjMjzvuyowMzvvpfnS2y75w6uE8JN12FjvwhSiYXEOH95OXYuT+G27ztVh5RTU1yKwIJlO0n0FVSXMBvik4HaRbAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993592; c=relaxed/simple;
	bh=sAJWTrMgsofLmvkEL7NUmmR3gjX9vSqDfDDVRIlH9vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4uLSw8Y0GhG06XJC8WuO2KmDVa8JglMtksS1udy7Nx3uuq4+x1Y52ZBE8y5jeAMmpr34T2ivM89xV8Exq3hqJp+meillZ4QxVgwnHOXr7qF9SZ2YpX4jD+DmKHGsJo7NBq6rj4DdoS86nxAleQhJnNkfGKl9hJiepuw8Ir0+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW3tG7u1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW3tG7u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A16EC4CEC6;
	Tue, 15 Oct 2024 11:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993591;
	bh=sAJWTrMgsofLmvkEL7NUmmR3gjX9vSqDfDDVRIlH9vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW3tG7u1ibU1UxufivkEOluFNbxDt9aNtloy6WtdDacdzDOXp5XD+lMU6xl1UbKTH
	 ndlvktzYnNvBfYThSb6cZrwiWUJ33KkXybtYu14J+zMti34zkB6pY431a4lvqgh3lV
	 RiYcibmNeg5U0yCTciavA9sCFJZiPQkSVdD1aEHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/691] drm/amdgpu: add raven1 gfxoff quirk
Date: Tue, 15 Oct 2024 13:26:46 +0200
Message-ID: <20241015112458.525633334@linuxfoundation.org>
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
index fb37c0d4b35b4..cebedffc44c09 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1274,6 +1274,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
 	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
+	/* https://bbs.openkylin.top/t/topic/171497 */
+	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



