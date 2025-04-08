Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB98221720;
	Tue,  8 Apr 2025 12:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114346; cv=none; b=GnOZSjEEUu6NUZDcta0305aSx+QqjiirV5ycLxwZjcuqhWVy5d12qOA05Nisi41qLD82t3L8gyAVehsb37v5G9KQ4eJ/YbadAjKvqcSu+UJ+7OvNbZ88O8J8qCSs0vxsA9rAsQcxAfdMkoYbNxKPxv7YHGsYKw69EjnbLGB0svA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114346; c=relaxed/simple;
	bh=gizFZNo2frrdVf0ha+UHkYhnRfGQn8k79JV29TDEe4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJbPUP9t3R6yXqLm8/3dMznDzoczNm4N0Tk4y4tdY//raU0LgGjKP1cg7U9rFw0NwdBkW51A7y90p4HpumXXrZk01sHwQsIISsT9vKwdbn+3HY7PBTe/KygqnQcqMyT1hVxfMyFyLPBxc+n9WVdb6AvJEmb//Qcb3io29+AyA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOXBJXKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOXBJXKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED08C4CEE7;
	Tue,  8 Apr 2025 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114345;
	bh=gizFZNo2frrdVf0ha+UHkYhnRfGQn8k79JV29TDEe4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOXBJXKCH15yEGo137IcGGC2nb9ui49lx5t/uPo6exwm+d19O7Ki0TQEU5zJdrlq4
	 o53gRi6bJG1TYFgou2ClRP18QjxdyuAkDr1SKNQ4NGM6FJIXf4qjYfSfUgm9HCE3Vi
	 OTmTu+yXlce7+oLh946PJh/N8kofh2vLdzXwYYnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 071/499] drm/amdgpu: refine smu send msg debug log format
Date: Tue,  8 Apr 2025 12:44:43 +0200
Message-ID: <20250408104852.999225799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 8c6631234557515a7567c6251505a98e9793c8a6 ]

remove unnecessary line breaks.

[   51.280860] amdgpu 0000:24:00.0: amdgpu: smu send message: GetEnabledSmuFeaturesHigh(13) param: 0x00000000, resp: 0x00000001,                        readval: 0x00003763

Fixes: 0cd2bc06de72 ("drm/amd/pm: enable amdgpu smu send message log")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 9f55207ea9bc3..d834d134ad2b8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -459,8 +459,7 @@ int smu_cmn_send_smc_msg_with_param(struct smu_context *smu,
 	}
 	if (read_arg) {
 		smu_cmn_read_arg(smu, read_arg);
-		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x,\
-			readval: 0x%08x\n",
+		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x, readval: 0x%08x\n",
 			smu_get_message_name(smu, msg), index, param, reg, *read_arg);
 	} else {
 		dev_dbg(adev->dev, "smu send message: %s(%d) param: 0x%08x, resp: 0x%08x\n",
-- 
2.39.5



