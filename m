Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208326;
	b=gg9wsTyGbePjqSB5huVyQOUJbgGia5PlIU52RrN43vn8g6hrJiRHlIIecuA1tXC7A3vU
	 wdt0tQmV8aPYogB8WYVXXv2s74XlSEcB/IE/YTopJz2mYxVev+dzOGH9BAVFlttsI5Hzb
	 DB+YU4jcjecpNBfg13ujg7yInBoDxKv19UUFCfRLiBYMRR2XP3km3ywm85gqx0pjo3oe+
	 1ZwR4Lft0C7Ygsfh99hgRyuE2/MrabhAIrwCOY/xpFqvuM2ke5UwtzTIKRL+oy28CAgL3
	 M7newi6h/Z7URhGujXmLiWTOoYtJbVnai7W4jzMMqqNobBMHxXz6vBXyS0JKYiINTIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gHJhOjXyWmdX7N1PI5P2DTbWQTYSMzazzmsZeexRjbQ=;
	b=KYDvMisJ3oe6wMV6IwITiDtS3CTsux0DfsNVQRTCtOW85igEP8LW1gTfEzoU9qKpLuxE
	 zSmDZXxMDy8cI9xAIsSRbR9qVANBeJ3XdLpMQY17W+11Lt5EfvWA2c+j5e/Dugl/dWmS8
	 7wJ8pYtu+meDjrgPDq7I57JAMI4+X7hoEA1riPJX9JqQo/mSgd7mDGtRlRKuEwlOKrJUa
	 PAzobxKOkIIjQFHREnas4to1Joi487O6X5frCYhJacIzgXhd99FW3vzaQbVBH6sGoAPvw
	 82iG2bImNGguORiwPnhqusPQ1iC1lpEHtX9chWJw0PGbhm0VFIatRrzNT6/F526T23A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iz9C5JVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ADB606A31A;
	Wed, 28 Oct 2026 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iz9C5JVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E4D1F01825;
	Wed, 28 Oct 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208325;
	bh=gHJhOjXyWmdX7N1PI5P2DTbWQTYSMzazzmsZeexRjbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iz9C5JVvqyIz5RPfYXQxAuPruCLJFpdpppFNZtRACQnxWlb8CYLHqCLdTHPxzsGYL
	 1eNxzu2yBVgaMU7qtBb8Gx8cJ2OoVxzBaM4CZH3TuXxRWNx1l4g+rDJdKpLwDTLPNi
	 bw9c3rlq9tyU9d3FTUGLTxnmQgboo8c1ClbE/a04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Teddy Wang <teddy.wang@siliconmotion.com>,
	linux-fbdev@vger.kernel.org,
	linux-staging@lists.linux.dev,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/516] staging: sm750fb: sm750_accel: Provide description for accel and fix function naming
Date: Wed, 28 Oct 2026 17:53:51 +0100
Message-ID: <20261028170005.392470895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit d12dd1e0e3b96b1a2c9ffdb0fa9c115aeb82b569 ]

Fixes the following W=1 kernel build warning(s):

 drivers/staging/sm750fb/sm750_accel.c:155: warning: Function parameter or member 'accel' not described in 'sm750_hw_copyarea'
 drivers/staging/sm750fb/sm750_accel.c:155: warning: expecting prototype for sm750_hm_copyarea(). Prototype was for sm750_hw_copyarea() instead
 drivers/staging/sm750fb/sm750_accel.c:321: warning: Function parameter or member 'accel' not described in 'sm750_hw_imageblit'

Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-staging@lists.linux.dev
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210414181129.1628598-26-lee.jones@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: cc7cd2a92281 ("staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750_accel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sm750fb/sm750_accel.c b/drivers/staging/sm750fb/sm750_accel.c
index 8faa601c700b2..24b9077a634a6 100644
--- a/drivers/staging/sm750fb/sm750_accel.c
+++ b/drivers/staging/sm750fb/sm750_accel.c
@@ -131,7 +131,8 @@ int sm750_hw_fillrect(struct lynx_accel *accel,
 }
 
 /**
- * sm750_hm_copyarea
+ * sm750_hw_copyarea
+ * @accel: Acceleration device data
  * @sBase: Address of source: offset in frame buffer
  * @sPitch: Pitch value of source surface in BYTE
  * @sx: Starting x coordinate of source surface
@@ -298,6 +299,7 @@ static unsigned int deGetTransparency(struct lynx_accel *accel)
 
 /**
  * sm750_hw_imageblit
+ * @accel: Acceleration device data
  * @pSrcbuf: pointer to start of source buffer in system memory
  * @srcDelta: Pitch value (in bytes) of the source buffer, +ive means top down
  *	      and -ive mean button up
-- 
2.53.0



