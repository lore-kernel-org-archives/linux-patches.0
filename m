Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042958;
	b=tH04Ure+LhoNG1azWr0HOefk4faOcvxiF/lpwDMZlxLOVbFxRVEAw0dKijLyqE94Uiaw
	 G0NPFXLjz2NgKaVje+5OGKhi3wMqSwo+bJcEu8ofKIo2bMitKhzFoPrq4kVoeKJuAhido
	 +FdaekqRSs3lLC+4sPdh5Jvkvq4D8G3bUqmO/0ewzaWVmbiWxU2wt2PsbipyHUXul17T3
	 r/2UZlz+SC1Lm5yqIA51urQa/SvNNmNrO6UFKbhmkOrWuba5/6mUtjYWdTrm+m78fEivB
	 kjBk0QtqSTfSMVHU+sad+gBAwp9KMoONyI1PcWGgBz22NGDUuMUk1dauyGDx/ZFPK+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dBA/BITgcOfhNb85X7VsZcrQd5JsnNlC3LqbzzPv6G0=;
	b=VulSRM/JNAK90eFbCdfujdW1F8SDnEsozu7KWR0I3tHBJ1yJCcM7Thpf2tB1b4v5eHf2
	 /LoL0m81IR76yMpQozcIxm2vC0CPSQAyCkJDQCLnawAuRatxYY7op7PUb9iKCNGVQLi7u
	 RMajovlvhkNYpYklA+IQiFQvWiyEK9eHh7mTa4Fhx3ObtRQrajBub3WnFgPdSXGiYQNMs
	 2ukClJL5khYlrvkgvDuRpMGQL17GxPuvfgS3NTjz5JAClLTBCLGyDDgismtdheP3l63Ff
	 xviYrzXktNtqvJ8PNwtmeYHMAtP3kcPoCqbB4FhPaFg0mj88AGuokxEVH6LeTKjW7ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I43m44Wy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D8606A325;
	Wed, 18 Nov 2026 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I43m44Wy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7A81F000C4;
	Wed, 18 Nov 2026 23:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042958;
	bh=dBA/BITgcOfhNb85X7VsZcrQd5JsnNlC3LqbzzPv6G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I43m44WyhYBxaY85xbTk7U9RtB/vWosl3jYDdith22RWuA1uiB3HSldG5F7kFK1s4
	 9RZHrilNjA0Gj/6sj+X5cYcgNq1L4KACn1F+CfVncC9KHOZC+0RZ/H01/Hu0LYJdrl
	 938SP+5sTZHySB1KVJpIxHvLq5Xq51y03EeRkDC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0040/2857] drm/amd/pm: Use uploaded size for legacy custom PPTable
Date: Wed, 18 Nov 2026 15:17:54 +0100
Message-ID: <20261118150202.780590663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4494d963e356..7952371721d3e 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -676,25 +676,20 @@ static int amd_powerplay_reset(void *handle)
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



