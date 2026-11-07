Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060600;
	b=NX/42+/9LtE8wrNkOstBxePJ5Uz12Z4ujjbhW9drGgSxQozK+X3m4ACvdUENlMLaIQDG
	 +/wCfOrzpAAyvGipe6YBJb//b6RvddfZCP1rf5mvjrdfhWKbAFgbvjCvv2NoJ0Kiu0L+g
	 KJsq+vERsO+9h8qBBD3D08LcfzXoA8bxZS6Zytdrg01VwnTIxuYkIx7mdiQHDMHOqT8ol
	 o7sjlzatP1f5O14hiWjIa8QAfSMJvRJZTZ62/3f89ZhgFLBw8ci2JID3KfnAx9Y4KotwZ
	 nOJh9PWzQ7LtU7nWhcXmyBAYmHDVk+SR36yQUud2ay42ha5/WBfL7gJqgXXuiEH7YyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JopUB3oMdwyskrDshWil864cbxJLXTMRhKiH51AUFJ8=;
	b=CNz/0NbzCwp/uKVkb1S5TQjQngFNomcuLqDxok2a8Y7Ub7DZsWKj8RV6wSDlry0wLTLa
	 dG8zmmA0Y04qJ5/2PpbkFiwTrvD8CSReCX2TyeJPs2zXnFDfCs0CqwGVsE5A+BGRPICgY
	 E62A0k2URWwhWY+8X1017nFClWYw6Y56SmDvWt9DnJ3rS3rO2fLcGykO9tlIY4knNuBll
	 u2nGqULX83kX/H5GXPaw1/92mphRIZIUqjMUQrKYh803Cdi0g7IbIKmKimG0nyk1yWEDV
	 ptqOa3At7dKCWKl95yZ6KDI/MvJdgrvWaz2LXGMIpKA0koxJW/YJX0+NQY4L59ixAHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lh+Y/aie";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86C606A326;
	Sat,  7 Nov 2026 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lh+Y/aie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B9A1F0089F;
	Sat,  7 Nov 2026 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060600;
	bh=JopUB3oMdwyskrDshWil864cbxJLXTMRhKiH51AUFJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lh+Y/aieQar0wDuFhE/ju2m5ZqetbmruMI6pZLLspwTBzsyy0FmzSEtXkF76GVVp+
	 CstRaYsYR+kG7QD7mzdWsmXWyGfANVTFyr89CHcMc0jMmuyswPTzZ+IoJgV+MThHVy
	 o9d3VwYmViFRxjVPB7p8qZuc5CfhAnUEftkcQ350=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0055/1536] drm/amd/pm: validate vega10 profile mode inputs
Date: Sat,  7 Nov 2026 08:34:31 -0500
Message-ID: <20261107134959.207595482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6aaba0b3613d..84c777fde62f5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5406,6 +5406,11 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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
@@ -5421,6 +5426,10 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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



