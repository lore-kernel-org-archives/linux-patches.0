Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060608;
	b=FX9ph0OZVYClHsJ+6YWjgi6YGVvyvV5duWqIXMm50BNwZ8rcvE2il8lzPW8Fs9Jv4LCA
	 VxxGQ4fiNr1pBLQys50ADpyXRWIP7sCsn5HjipDOVrQKFXsljVvlApcu/t+s8KMeSFoJY
	 u7BTzYDvcT5TzlJWn8qq0WJiESAv6zpEqhanplsHaSG4dcD2XFnaUMHdlU1gljXQrP/3s
	 LosdeLVsXK/wPL3x0FNQEqZ7am5+RV4AiubixOvLaZnzfrQq/HkkM6aEFCzHoMnNoSio/
	 UO5nxcKxMNB8BmEDNJTJCwEV5fzNwJ0FqM/SiJvytd/M8hS/n8ZZl7VOU5zhlC8KHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uv2pjCVpxfObW3WXURjsjtGA5muXIXK8MjZwRHz+vvY=;
	b=bZBIImN7ZSjb717i4/FOazJRQ41COhwKv0gzj8kWBvC4M9azCuLANwMTQV2qN3mwb5Sl
	 RWvuBdkpkUyvKEIIcgROppNcW/2K2AHln6+U8Z3aMx3D/4RBzbQq4XrRs8BQS+kLE8g2D
	 NGhs9UNvXf56cMxXr7yvQqDqdZ7S0FnMM3aAaoRlZtm9nOUw8rgh8FyS/F0fg9yhhAA71
	 oQdv6KFpe8tDlbC+DTmao2WLY2XQV4gijOsvqR7XayQJcynZuUTsoQYuhwov4dN2kyuP7
	 wYCuQwpeB9pC5bKQBf+FV5rVKhWYo+My4jeTL3MBAEGpgX7Y03VvbmdfH7xOSIvhfZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqqvfssg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C8F606A332;
	Sat,  7 Nov 2026 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hqqvfssg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C521F0089F;
	Sat,  7 Nov 2026 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060608;
	bh=Uv2pjCVpxfObW3WXURjsjtGA5muXIXK8MjZwRHz+vvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hqqvfssgj54vJUbY++vJFSt7xGVBX7OfDGtZp3eft/QHtKYi1/ksatxmWtbYiKBH3
	 e+coBXYSGSQxiaWKUVMiVU6nkD9E3K/vwTNYLYAsI5wxmReEGBXIy6zQpllsLsSNWY
	 fheWT6eARYdWiZ9xoPZqOxdj0iyex49wMCFLn9BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0060/1536] drm/amd/pm: Use uploaded size for legacy custom PPTable
Date: Sat,  7 Nov 2026 08:34:36 -0500
Message-ID: <20261107134959.349441810@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 055a40c32f3a2dcd4d1a6f85ff4c231cf35f1b53 ]

The legacy powerplay path used to allocate hardcode_pp_table from
the original VBIOS PPTable size, copy only the uploaded bytes into it,
and keep soft_pp_table_size unchanged. If a custom PPTable is shorter
than the original table, later code can still treat the stale tail as
valid table data.

Treat the uploaded buffer as the complete custom PPTable: duplicate the
uploaded buffer directly, replace hardcode_pp_table atomically, and set
soft_pp_table_size to the uploaded size.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/powerplay/amd_powerplay.c  | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index ec4d070d49141..b1526f80c9720 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -679,25 +679,20 @@ static int amd_powerplay_reset(void *handle)
 static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 {
 	struct pp_hwmgr *hwmgr = handle;
+	void *hardcode_pp_table;
 	int ret = -ENOMEM;
 
-	if (!hwmgr || !hwmgr->pm_en)
-		return -EINVAL;
-
-	if (size > hwmgr->soft_pp_table_size)
+	if (!hwmgr || !hwmgr->pm_en || !buf || !size || size > U32_MAX)
 		return -EINVAL;
 
-	if (!hwmgr->hardcode_pp_table) {
-		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
-						   hwmgr->soft_pp_table_size,
-						   GFP_KERNEL);
-		if (!hwmgr->hardcode_pp_table)
-			return ret;
-	}
-
-	memcpy(hwmgr->hardcode_pp_table, buf, size);
+	hardcode_pp_table = kmemdup(buf, size, GFP_KERNEL);
+	if (!hardcode_pp_table)
+		return ret;
 
+	kfree(hwmgr->hardcode_pp_table);
+	hwmgr->hardcode_pp_table = hardcode_pp_table;
 	hwmgr->soft_pp_table = hwmgr->hardcode_pp_table;
+	hwmgr->soft_pp_table_size = size;
 
 	ret = amd_powerplay_reset(handle);
 	if (ret)
-- 
2.53.0



