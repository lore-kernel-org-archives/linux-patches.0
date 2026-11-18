Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034902;
	b=yJQmPrupH/Uzn6suCEIHnsGIerZy0XViEdIo1UGsorP8hJcyRU4ORjXMjVYDMtaBXTEs
	 +j/P+XoJLSQCqRD8exD7O8uT2U/6iJlkOIYaJxoxo2GoGtuv7GXfcJjbl0imhMEp/6gsR
	 0gCKeQo2FT18XyaQYs2oXAn6N3We/f5DxVSdXxNA+OBBQ/MDWMUIK4MfwjW6GBrw1P7uY
	 suuIid9icRdEE3WHquOAyzVr6LH1WWNfjvEA12yiwmiyasrWbaFLTEUz3vPjQPEKExBKL
	 JaZCSF9+AFg7yuNkCuzEUn5b1WlYW49mJ6VTBqDKM/blXEr8e8v7zm1R7Z+SLsnebtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FG05hVlCReKM7GBUYW4mAl9B92ZgC1cPXf7WLuGy9FE=;
	b=fdfz/JDO9Zf/tdE+kHVGyA4dNRHOWAem0fQwWaV8VIGEPq6um4D9eVPfOMeL0JtxNllj
	 hfMKdXvt+m99q1PJcw6TUYeCtjukqcw/TuDyuFQZneZjL3e7PNqToGi39tGTvwobpWn/i
	 tltJAwLyxxZ/YSoX11Ps+0Pq5QFsUtiGRXJJuOXq+0xWW3CFBnpVbMZQNCusqw0s6HZww
	 EFFuAxSXcdkzSbE6N1Jf22tWVjjewcIm4F6UTmjirS/YkbdMBK3q/9fAGPV0LtbvbISyV
	 uWXcP6Nqa9VVFTDkL10odeVG1QVvrXKuqmfEwd7sv/YsJMaJF1ud183n47/l6JecOGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/tGNWUz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C86606A31C;
	Wed, 18 Nov 2026 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/tGNWUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CBC1F000C4;
	Wed, 18 Nov 2026 20:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034902;
	bh=FG05hVlCReKM7GBUYW4mAl9B92ZgC1cPXf7WLuGy9FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/tGNWUzkb6oDM5h6QfHblfoUkZqicSVhO+IYexY1VQxJXCk7ys5+HekXAxOE3s/M
	 g9nCtObiuMNEg56W1IqjcnLvUJTtuMolHnN8XwRZHczA0Qug+M2cCEAwKU3EGh8Dfj
	 g0JtWgjM6AAgzSg/fDiHUeIZPJhx39NGps23USFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0488/3318] drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc
Date: Wed, 18 Nov 2026 15:18:30 +0100
Message-ID: <20261118150331.626692874@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit c883d0a132d430ef7ebb23fd94323be94d0fbdb8 ]

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1

But ffs can in theory return 1 or 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)

using properties of logarithms.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4f18c56630383c14bfc6b2d65f88f2f895d2121a)
Cc: stable@vger.kernel.org
[ sashal: Dropped the GFX12 MQD manager hunks (v12 and v12_1 files) since those files don't exist in this tree; only the v10 and v11 changes apply. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index 2c9e88d147cb2..b5dcc12397301 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -197,7 +197,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index 5a31e8d7798f8..0a7bb58d965f4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -251,7 +251,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



