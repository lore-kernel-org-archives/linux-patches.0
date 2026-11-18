Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033622;
	b=T2C2i2cdc73RBMZAwELOg4bdS1L3osmIigObOEN6aw5q6voRwj8t48Dnmaa7AZvysHII
	 Eqj/M7AAOtLrUTfaHNRDInHBo0lqWZNbuQlxT+8J5HcqYZvs46x2kMwEjJo1WsVbL/BKo
	 vJN4feqV3LuLkl/rA/X+Zb1hSSlaOnNSG9fbFqYTZk3ySGHe3OdzWRYPnKE2UawzlIPAb
	 cQzfleWYsQTP2j1zt3oqnUl/YhbYGxHDoY7c2eMbXWikqF3cXBgdQRzg/nHvlIDZVYVpX
	 6M6m4kKtd2VQz1AvU7cA64UDuPt0c3Zl9pfGwWbfoS3/atzNtj81lv7mD8JilO733yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VAi89GIoBViwqLaIrc6ajIn6/Sdy4s/96pd563X10ts=;
	b=wOrkWseW3p9xmV37QBMv0kfl+OQOE1K0F0i3gBhy3QE/B2zEeoSHSu3c80Srp9Qo7Fjh
	 yXRLZbN6v/FFbpJFospV5BaLrssUcqpK64SM+dQmoJGEgi9Afkg9bao9TVWTHAictPgVy
	 xYbZ4WAs0YBQACbrMp9PjGC58k1UtUzv3gk4sf6yKbc4H/gwhYmQS4J88dIk/8NOJkCf6
	 JQxJ8kqdWa6JShHRhbx8eC/wL0vr4qJ/HAl+s5LgG1hGEUDThWNO5sn8Qr5qFR2GvBMh8
	 iuZgkWY2F/sBWPGh3+Hrk7ZYDN8lxTykwCbLqyYnmxy+ZsTBPMpGuJBP2fw9+1SAUzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEhhuVTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E091A606A320;
	Wed, 18 Nov 2026 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEhhuVTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7591F000C4;
	Wed, 18 Nov 2026 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033621;
	bh=VAi89GIoBViwqLaIrc6ajIn6/Sdy4s/96pd563X10ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEhhuVTiFp2mfFv8XIfA3CtloA2FAjBak/LQFBx6YMho0NRdFh2nDisMe5+ErhJyn
	 Te7YoxhRd0QOzdnITNeegQaxHTU1Xtd4dEXCw1WiB/gGlQtD1adR5CpeP32pro3c7/
	 tnXvUyftIQUUXCn3gALOlLXOVqmGqRCn4eiiVxGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0081/3318] drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine
Date: Wed, 18 Nov 2026 15:11:43 +0100
Message-ID: <20261118150316.521203355@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c24edbd5ae0e4f24e0179e8c9f22a867016177bb ]

There's no need to crash the kernel for these cases.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
index d67d003bada2c..8680a8ebf0573 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
@@ -139,7 +139,8 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				regSDMA1_QUEUE0_RB_CNTL) - regSDMA0_QUEUE0_RB_CNTL;
 		break;
 	default:
-		BUG();
+		WARN(1, "Invalid SDMA engine id %d\n", engine_id);
+		break;
 	}
 
 	sdma_rlc_reg_offset = sdma_engine_reg_base
-- 
2.53.0



