Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213914;
	b=bZFlVczoHhjyAV+pO7c1ygBU70sNEQ5XtAKnh+aCijqCfce7/l0FfzPfycQXUSARi8B/
	 bDFNQyGHIZgNjEYdoGMAlxUaSTpj+4oiPSF0lqdX+XPwzBm+XMvZCapMiqLc08ZS9CD9k
	 cfwqSlaDpB/MIyuUZtCS5HQFl10T7EWZDET7osOptGXeOhVt7mWAmnK0T3PqGKNPBjYku
	 xG8cmEQgVciWJZoDP8cbqwAfj2s/6WKNaXfFCLUy9oKNcX+qdo9J5y6QwEGLnMCMtTrH/
	 /Ev3FB+ABx/vEUbJMu0rfQwfUP3/Nn5OYIt+yWS+RQaRADV9KF1tR3JcIE11v6et0+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fimjiz/r+BGydb68H/UONSXv6gY7tBOUftNaiaV4CEM=;
	b=GIkc4a0cJSrVMInJ19kQCW3MIhw8tPynhMEpNdtP9njqoCHxWLeakHtuiOnJzXcWoUFl
	 SgV7teL45pqnpcgBk6HktEv60/uZq1xKNBS+ZNnv1r/2qEyDtpaD9QjqXfLR6u4oEAAkN
	 hSyP5cj0iUK/whIhz1XYmc6QBXiGhUdK68m6EoGLeJiUdi0refF2jrYUwa1BLVBCNIaCr
	 gjyyqk5UpYrLO6GZ+i/JCKBAAjkdCHs4XePEzUIO8h9Uf8Rrf8tU26coHvO6l807TPIqL
	 YLyMR0chhkNruFnDhxIAWkIhQjbaoEyiFxQNnwT9+EynlW2acmUnA6Kkd1KxvTsQVTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvZ863kw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBF4606A31A;
	Wed, 28 Oct 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uvZ863kw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6AE1F01825;
	Wed, 28 Oct 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213914;
	bh=Fimjiz/r+BGydb68H/UONSXv6gY7tBOUftNaiaV4CEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvZ863kwZggdRlHVDLoPwd4HEc+8p2lPdwQt83w32jHGFlNtpIzGKU+wF6c95GTNv
	 ZpSG2Ek/SJzGwHYNhz1n1B1b3B37vBvH5IYVgDBTQeK4ZEsY9OVx8rzPefT7XIYyHV
	 eeJ/U5tusNCHak8xBdbWQ4kzp1wdUGU91CjgQdTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0631/1887] drm/amdgpu: fix double free err_addr pointer warnings
Date: Wed, 28 Oct 2026 17:45:27 +0100
Message-ID: <20261028170513.766473066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Bob Zhou <bob.zhou@amd.com>

[ Upstream commit 506c245f3f1cd989cb89811a7f06e04ff8813a0d ]

In amdgpu_umc_bad_page_polling_timeout, the amdgpu_umc_handle_bad_pages
will be run many times so that double free err_addr in some special case.
So set the err_addr to NULL to avoid the warnings.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
index aad3c8b4c8102..da40be587f1e3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c
@@ -109,6 +109,7 @@ static int amdgpu_umc_do_page_retirement(struct amdgpu_device *adev,
 	}
 
 	kfree(err_data->err_addr);
+	err_data->err_addr = NULL;
 	return AMDGPU_RAS_SUCCESS;
 }
 
-- 
2.53.0



