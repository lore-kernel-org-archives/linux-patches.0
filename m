Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059683;
	b=Ss0dzJJBHWEiuxCxwxYEyaNk1d7tQe9rlPYGqsW79UN9bTnFkFQtFGOWzO2Dtp3iZZ74
	 FOZXd5K0PjA9VQNf6SyS0ZErp7YUlTpI84qeGXXMe+Ct0yCXfPhEdMqHeFqpGimyi2kAj
	 jshX3GdeTJNT+v887mWWmmxNJ1BfkJ1fjo4z5Xo9vLaFCUXUUJtbSC6h2A68s86tzWB79
	 KB8PvBiXzjqmdFd8t2IhlXHo0qsVYOU+Lx+9KHNPnHLOomql4CvDgAxCZBcmSzXk+bp72
	 zou4wJnnzIBtfocLO/XP2IJsoA+DQSqWG6OS8IzVU4mzuMFjwUAB2IQRFVQNPrv4WFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W6x01LYUAMjq6r1envjRLweYzRmwc2ccoY3u2+SGKvY=;
	b=CyY6ILaxwMSQSkFe8SCsfn7xKBM5z78kD706GFMuySFZiETnpzxWN/Z5XWTcXkx8FOFn
	 SWIHyeXifWMB9aBQp3y5RV0kWoX2acq2pbmdi3j/vI1r2BXRpLgjMLJQLYWo+gxJxT7sF
	 ZlA1Y0GeD5f08solUa2sLYjMeoaYqt+c6j1enQQotXIAmlyYcT8t32hifq13XGJwoz74i
	 asQga+S4TqdA9OaftvIeZ53PBeZIVc5W59LdTVWiAk58Ld46mLEwml+HmyOx2osxA+Kdm
	 DDbqJo1jHcoMdqFV4gqO7LTnfG61DR3qoH3KSCk5YliSLuLX0YGv8WjXsrRC35RsN6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJsVg1es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842FE606A338;
	Thu, 19 Nov 2026 03:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJsVg1es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99531F000C4;
	Thu, 19 Nov 2026 03:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059683;
	bh=W6x01LYUAMjq6r1envjRLweYzRmwc2ccoY3u2+SGKvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJsVg1es0K5rfXJMkgsG0uo4KHxPwuiPGjP02EZvmfFVNrJgwzN/+1XCm3lPadrJb
	 AuXJRupVQISt3JN4ehrdIf8E3yjJ3qQmRkkRUxRWrBqDQ9HbrVVZ9us9aUt+CIO4/A
	 ofMJ5dUCc1EriiDA+n0lk8ZJ2OkfbgYzlhAg8sWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0927/1848] drm/amdgpu: reject CS chunks too large for kvmalloc()
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118145955.589104257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit ba4c3c202919405f461a393e823e4b72c8518494 ]

The CS ioctl copies every chunk with vmemdup_array_user() before it
looks at it, for whatever length_dw userspace gives. kvmalloc() warns
about allocations above INT_MAX when called without __GFP_NOWARN, so any
process with the render node can trigger a warning. On navi31, a CS with
a chunk of length_dw 0x20000000 returns -ENOMEM after:

  WARNING: mm/slub.c:6841 at __kvmalloc_node_noprof+0x5a5/0x7d0

Reject such chunks with -EINVAL before trying to copy them.

Fixes: 2098105ec65c ("drm: drop drm_[cm]alloc* helpers")
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dab5f5280406088591645f499f048dcfefab8d7d)
Cc: stable@vger.kernel.org
[ sashal: placed the check before kvmalloc_array() in amdgpu_cs_parser_init() instead of vmemdup_array_user() in amdgpu_cs_pass1() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 536935fbeb672..40146957996f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -161,6 +161,12 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, union drm_amdgpu_cs
 		size = p->chunks[i].length_dw;
 		cdata = u64_to_user_ptr(user_chunk.chunk_data);
 
+		if (size > INT_MAX / sizeof(uint32_t)) {
+			ret = -EINVAL;
+			i--;
+			goto free_partial_kdata;
+		}
+
 		p->chunks[i].kdata = kvmalloc_array(size, sizeof(uint32_t), GFP_KERNEL);
 		if (p->chunks[i].kdata == NULL) {
 			ret = -ENOMEM;
-- 
2.53.0



