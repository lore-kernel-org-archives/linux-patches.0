Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C591CB519;
	Mon, 14 Oct 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919007; cv=none; b=NkJ+et9A4qJmIVPee993ZZ6WV+VhX5PJW68jXBR9dC2tjtDy9rGLOdXqzUtYT81xlOkuyZRw0UVlqcy/n430OrhxGtVI8aLFdOQEo601bHoJZKsnWTrpQ2K0HOXR5sUdYII0gNVYRtTXHR3/6rWKmWbbZvjXZgOJSSobilLE2NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919007; c=relaxed/simple;
	bh=9vaUntTH9IUZc81wavzWFWCa8eJWbD3vw+ohkvMKE18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRCM+n2neXpPSJEQ74ukejlCbYgZMSaEm2PniDYC+UX9kJ5+vh883+XyDtaKSYbOz3ShYQydxc0Dp0AmBUvkeOEKMmlNk6YdmmnYb+Y6HRDqvHrA36CqUjRu4pOREB528hEYITIWTVeacKPqMe4TF9Ph9pbdL/MxmlbU0jzWS28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJw+kuaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJw+kuaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B11C4CEC3;
	Mon, 14 Oct 2024 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919006;
	bh=9vaUntTH9IUZc81wavzWFWCa8eJWbD3vw+ohkvMKE18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJw+kuaQcsfb3VJlZvCbx4oidtjgcHhYYhJjeKVvVADa+9CmPOSIx8AZKbrkWM3QY
	 /JzmcxEbcqRgi2LGPQvC0h2H7p6C3oB1vK0rH2hBE400ITjZztOpkQ6+ecrPTMlARQ
	 UeuSGMaUolZYwTtRgv4klDVpQvBDKFUOFh8rwrhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/798] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Mon, 14 Oct 2024 16:17:20 +0200
Message-ID: <20241014141237.065134761@linuxfoundation.org>
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
index b977431c13b8d..3cec6a145a5c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1175,6 +1175,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



