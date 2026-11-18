Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033538;
	b=Fq6/tZqbB0bA9+3B1buqpbnZ26CwRi06+bWfA0IEka7jrWIkcNdqEbld+KeGR6bWWGfI
	 ASG55nfnP9G5gozWHx8SqV2u+7aHHvBmVOU5WZCB23EyeTwVaFo6fOsdJU8NyP7bGGjq4
	 KqFTpONVSI3PyAiVVKeH64sOZN//VfKa4xmSCdRHTqriJ1d/rjmt6B0dUrEzFn1DG721W
	 kN83jomG3zrkynyhiIl7QK7R41bnCjXEcXl1BjAg9xws1woNtby66M0N5u/ih3GMniOec
	 ulT64HBSM6QsL+oEno+Aatmn7GxHycBG8uC7gjPR3a0DSIfyPQnCLtmj1+WA5PsNjKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7A2D31zcmMPXaGal9UurpYL8C3Q2MIyYDmKcSgeee6U=;
	b=P9ZN8OJIgwgwermIIrSg0clngGHv1+1Napk9OQqGd4+K27IvJ2lmzLOAqGCWUdbz2ikF
	 K+ps0l1AtJBdd6KmFpzdxzzlQad8es5Xc3DLdyFaLJtgNQrVSMX+hBZGS7wN8FgHefxuu
	 VcpyLGPw+n5Qs5HAsSjDHx9A9K8X/+rTg7IuTWS76aBjlUAYXx3xm5cw1Wz91yFYp+9+M
	 qce7WPCTm3MqrH5sEKlmoWLKxt7uFWovOITiuDP3VqwXOlP8CQZmecQ7LELp51sVu+iOU
	 WRC/jiRFSODTMSGezgQYV9NU91KSnih13mXxbiG5xUtNW1uLVPX3OM9Ihc9TZ+v/U1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgxZuHvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8FC606A31C;
	Wed, 18 Nov 2026 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BgxZuHvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CC41F000C4;
	Wed, 18 Nov 2026 20:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033538;
	bh=7A2D31zcmMPXaGal9UurpYL8C3Q2MIyYDmKcSgeee6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgxZuHvmgAl5QrvKc4yfu3qysXNCmns1ZyjECdusdcbop7rjpr3iXzPX6UUOG/kHe
	 eWniCYmzAhyvyUEARPg1ojxc4FCVyytxAFpx1uniSus2pI51VwImrUbutJraSVwZB0
	 xMMuDkXwTZM12sh2PQa9rTz15FL8f4VFtl+uZC7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0050/3318] drm/amd/pm: Use uploaded size for legacy custom PPTable
Date: Wed, 18 Nov 2026 15:11:12 +0100
Message-ID: <20261118150315.411942535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 413d73c1577be..2eba584f628b4 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -675,25 +675,20 @@ static int amd_powerplay_reset(void *handle)
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



