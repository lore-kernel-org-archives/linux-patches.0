Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211317;
	b=VZs9OaS3p/8VyclprtFwO4bcqmOaFA3GeneHypehJJCVYAQXtsIOkxYkfDSM7yUoRVgg
	 4vN59VGaFTV28Nkb3e1iZPdnKW6P4dvxSuiUYnl8VN+pqoQpiJQZHd+qJbXI4MH6JdPiB
	 ipdhgpf8ZWeojvfvefyZl3jXY8qofcjawQHtQRBROnIeRjo1h8lXjyd+cxLGTKpCK+pcW
	 gFwJAC8DMLCX/b3KEAWzM+IxuAb29M1bdNScJyBNJd8q5xVpyk6rFHbt493+eqfL5dNIi
	 HAdJ4MAsX4aHMRVgbhvut+0QtnBJpb7vAgyG6uUg7Sk/XqVRJW1tV9FHS6rVpm0bt5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AtT2mdhBhQq+J83dqvq3naC+LVapZ6hZHSjrNypJD+M=;
	b=Sf1e2UDRIq6AVeDeqH26ujkRJJXAVnFNb3+9WShc0ELMaJtNlOIWddscAPcOug+xUh04
	 tJ+4CB7rFtYbuKGspRFZ+inclBgHX732dBoGJBhGaofJlKHDRpDPUum2p1UNE/5iuDs7S
	 mnlobXWZL7RGax7Brjs09nX6qSMe9lDfYkG7Wr5ajaVHMTqMMe2vZ0I6s0vupRXd9NMkp
	 PxrXJRqlkLPHp0wUuKoYqXp7Ahreopd9mO9Fw/ftD89wv38bijSrPa1FLtHeexA9TB07s
	 OXvdkSnt21bVqXqAgyznOIe+vu4WLBTWlp3hjyA86F+Cw5SLt+Y1wsleUUix7T0WeOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDIA1wrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE42C606A33C;
	Wed, 28 Oct 2026 18:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDIA1wrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB581F01828;
	Wed, 28 Oct 2026 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211316;
	bh=AtT2mdhBhQq+J83dqvq3naC+LVapZ6hZHSjrNypJD+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDIA1wrkXXf3e2oXwf5MW49QzzDMQmsSUy+L+o3tjxUJAlkQ7XObKUTzADgdm4oW2
	 p/n4CbVx5yEX33JbcgU8E8aHhyoXUXy2IpBt9+LEzu68PAtp4o/ajMJSyJ8ThCSIIm
	 9fnzBobKt5wtNKxY5Mrssn/b2bPiEXIMx19fUjuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/571] drm/amd/display: Mark DCE 6.4 as not APU
Date: Wed, 28 Oct 2026 17:57:45 +0100
Message-ID: <20261028170015.546023203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 3a52d587d1fc8e8bf94ba1b07374f7ec91aaffb4 ]

DCE 6.4 is found in Oland chips, which were advertised
as low-end gaming GPUs in 2013~2015 and then have been
sold as low-end workstation GPUs until 2017~2019.

These are not APUs.

Fixes: 7c15fd86aaec ("drm/amd/display: dc/dce: add initial DCE6 support (v10)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-3-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1072aa811ea1e61d5f763e4ec1bc6d24bb61f14a)
Cc: stable@vger.kernel.org
[ sashal: adjusted context in dce64_construct() for missing debug and configuration default assignments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
index bf72d3f60d7f4..6a5c8a4cc32e4 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce60/dce60_resource.c
@@ -1354,7 +1354,6 @@ static bool dce64_construct(
 	dc->caps.max_downscale_ratio = 200;
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
-	dc->caps.is_apu = true;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



