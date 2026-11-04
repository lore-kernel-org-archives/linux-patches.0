Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829353;
	b=eBHVy//dlrgHX6ulBUCbvpyFveUsgS9M32S7YJS21NJ7Z0BGFcD7rwSFEfsdQaO8PNrs
	 xmzI1FocqrLARjei3sZV1AjXbz8M2rst0W23nGI7NWedA9gWjGwvKQlhCsnl4fn56V69r
	 plTvNqlepoK+TKSzj8AQKrSDihYl7p7z+lh3jD0voxt6v5CkzUtau1csQRUF7wfcYRZD9
	 NG6z5x8HTKFf8JUJMTzHoPNq8UBm73/to7NfWkIhde1yUTipKXFTabvpXM962DABW/fbb
	 03LbfDJZ4vFxYyCHO99LnSiuehMww8PnpvLev/ZC9SJll5QKQUSyeE92GsGQJHqLnqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fj8IyQMjNzWewlU9GL52psEm4QwrADRcpVi8c0W9ZU=;
	b=NJrsL3z960maant0UceJ0zJjeA0rthuTI8y8d63/wAgc/NubXmHqmlZOrJnF0QiY3Gaa
	 Nk+HamFUs0yZ0LUti1wyuRlAKp8LdDmhc3wOqRWSz115T0TC+h7zFo5nPU90gaX6VJ/dB
	 ImuB/EcpzFWOuCu2obe11O99MiCMQDVCg1l0gEIocRQNkvj2AN9A7AbppdzCpS3x+fIpA
	 KLVUnwWZ4pWK3KIJzQZwBxJVnX1R/qRjwURpVe6KTV28zFgdfgn+rEMe9y3OidIEQTKUW
	 eVKv8ibzLoarKR+hhTKD/BZwrb++lYg48YXuKypsLuR/GCHI4c/FZaK+3RvhVpKV1ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKRxB68U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA98C60A6F63;
	Wed,  4 Nov 2026 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKRxB68U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2AE1F00919;
	Wed,  4 Nov 2026 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829352;
	bh=+fj8IyQMjNzWewlU9GL52psEm4QwrADRcpVi8c0W9ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKRxB68UTTDdKutz7GJ8pgU0ZwO61p06px2GUJV1QTS68Q/xPTjVXntr8Cg0vVTR+
	 XUM9P0Cj4AUs5L1xRnmy8TRE7YHj2w8fYId7aMg6/qqLCiLfUWFLYQ7l9R1lGpbhAo
	 x6RlbRCVP/KYB7daU4uH+cQ/Krm05GqrWscSnE9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0072/1005] drm/amd/pm: Use uploaded size for legacy custom PPTable
Date: Wed,  4 Nov 2026 15:56:45 -0500
Message-ID: <20261104211045.632146467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5e197c463ed96..05c5e7d19ca1c 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -663,25 +663,20 @@ static int amd_powerplay_reset(void *handle)
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



