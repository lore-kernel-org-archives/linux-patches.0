Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057185;
	b=ECqp6z5ZOR5BizDmXNvBEZHp9kMZCqMMqWAf6TboOLRsdWRMY7b30N+gIPJwfdigoX96
	 jDYFMjPkmK1xssTUEn+Sqd86px+iz7b7yCPiQsZ3PQnUyALBKGYdy7zrYos0V06iybB+K
	 dvS3YL1Wvjvup/lZUy6XVdu+YvHe3yJJnXhrn1CEkeEGN2QISmi37ZPhehVVJZnALm5Nu
	 vpsWjywPum8hdRCwwKtpGAT/oeooa5rAbI6oUIOSb54JgwUB6ZIf2kwPxQL4moAaTg+XH
	 jSdzRcfsyKxbbcFz4RHc6/bRLqfuTuN3TcbB8cMfIk+ljlR2F+yZUCKqAD0t+8PU3Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+O+S9fMQpeKtewj4sr5LUvVqpAbQhqjbYwBBviGcS/Y=;
	b=aXXvaPCjS/ITezN0/DI8OkPfz30gelbDFWDzGOUlOjL8YMf9frNHrWkEjcSNLfMusuCu
	 rZX/SPH79GxNY1bU2L8QQr6sz7H6bydkXS2M+5WD4qAHrQ0gBChnMh7bK0UPlXnscqXsu
	 fU2nD8wix0o7lfSeSYCK08wNIbsk6kfAKQa5GubhhwjtQHXylmSWIdHkYKV6tyYoLnoSu
	 NhZDwvcBbdl2jUV+BbQ07hRy/5EROLYMKYzFkXcrOjHBM/PK/Ns/YyUoB32lHD8NkZJ9E
	 cBEjbybdNLfGXcJQY3xCE5ckQbr9hehF4FvMMy0Q9CNIhko3HcacI8w/grRSHJhhC2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8uTsrbi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAED606A320;
	Thu, 19 Nov 2026 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8uTsrbi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6815C1F000C6;
	Thu, 19 Nov 2026 02:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057185;
	bh=+O+S9fMQpeKtewj4sr5LUvVqpAbQhqjbYwBBviGcS/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8uTsrbi32Cw9WnyR7DxOgKKz6xjFNcet2aQ89IZQXcu7Ev49JOs6xM7UpXGIG+lj
	 Xmfchs950putUVhYPiXgMB9kuHlQ2UZTtuzWKLQMVj0gqXwWbHvHu6lpLyjZ7VScVX
	 yYbyeb9hf1FPH45N/nXGqaRjJFCX1G4NWIPT3nSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0040/1848] drm/amd/pm: validate vega10 profile mode inputs
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118145912.804296908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit bf939f2a1687ef4ab815640096357f8ef5bd5fb6 ]

Check for out of range profile modes and custom params that exceed 8 bits.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 77d9be460c961..62cb6979d5f32 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5218,6 +5218,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	uint8_t min_active_level;
 	uint32_t power_profile_mode = input[size];
 
+	if (power_profile_mode > PP_SMC_POWER_PROFILE_CUSTOM) {
+		pr_err("Invalid power profile mode %u\n", power_profile_mode);
+		return -EINVAL;
+	}
+
 	if (power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
 		if (size != 0 && size != 4)
 			return -EINVAL;
@@ -5233,6 +5238,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 				return -EINVAL;
 		}
 
+		if ((input[0] & ~0xFF) || (input[1] & ~0xFF) ||
+		    (input[2] & ~0xFF) || (input[3] & ~0xFF))
+			return -EINVAL;
+
 		data->custom_profile_mode[0] = busy_set_point = input[0];
 		data->custom_profile_mode[1] = FPS = input[1];
 		data->custom_profile_mode[2] = use_rlc_busy = input[2];
-- 
2.53.0



