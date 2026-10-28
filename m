Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215184;
	b=Y0TgpZMWy88c6n+GMJtkALyDIM48T45ly1jp5fG8TLcBtc0GQ2kbR5CWm9xhcwzewiWP
	 oOqN2m1h2oMr2beTK8DRASoOfu2cC5D0qnioz9bkODwmDXlkY8F2XpvaLHDU6C8s7AhPD
	 6TrkFG4Jb2nZeSY+0Dsu4cIfzo8bY+V5KHXxqM6g+BKzILfVbw6im7Bw+we20vtivAKTe
	 89FDkhEF/uJYRoma6/bJCxdEPp1JRRqYP2fFlSOPwnEkbzGY9VXbOS7BE0Rdbti5UujGY
	 jiqSDQUVo/6jHb427dZO6zzl4f4IMOHZAXHEXk/wOFVQ80/+cUyBLJiGx7C4o8Ni5ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qpsIs3L7YKnPfRugHodpAOQ4eKVZtzEOo71MP5C5UYQ=;
	b=Xw417u1oN+o9IaYcH3FQh8Ja6fifNxEUdj7OOU2wPzhrnqXzsthHJ6N4rkq8+vgG/1Ez
	 iF/na+NW4PwPLxX7WzHF+0x9Mlt9rH6qiE7Q9caKLbfWLh5kUxE3KSgCdbGbgMXuZwmcZ
	 pGvEbyjTRs/4EgKhfGk6eAPVoSzdnDKRd4tCO/e6ES8S8NxFa0fvJEw8XQW/+La9B36NK
	 a9fNeGZ0w+DpXuteb0eZKdNaMq0PznoWPfK3phi1YwNv2g/a2Yp5hNYMD5hWrJN+THUZJ
	 sBNwjjaMyV38B1Rd06ltb5cGptjMkP5bFg6n74VUxG9xJczHQboaAArn5N0iUpEhiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8n7febM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E9B606A31E;
	Wed, 28 Oct 2026 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8n7febM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD511F01825;
	Wed, 28 Oct 2026 19:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215184;
	bh=qpsIs3L7YKnPfRugHodpAOQ4eKVZtzEOo71MP5C5UYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8n7febMtnUshNWBYleDw9KKwdPqhYRrJ9IrSdswk9R4b4F4NJGTX3oNTt8N82SBv
	 F8lnzzlR6lCxHX+lVxC6QlBgrk2frPYe2yXIHkCURG1sNxa18xLm3EWXnIwc0XI3oc
	 8k4b5Xy/7798S+7GRGFPawgbYpVS6/XrVlZ+e/B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1121/1887] drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring
Date: Wed, 28 Oct 2026 17:53:37 +0100
Message-ID: <20261028170524.911680724@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 51f694221047c84fa185be98210eb2c354ffb8c6 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 8da1170a16e4 ("drm/amdgpu: add VCN4 ip block support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fd852c048b46f9825e904a4f3f4538fe9d8827d9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index 2e9ba94894746..608ee2a4d6275 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1769,6 +1769,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
 	.vmhub = AMDGPU_MMHUB_0,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_unified_ring_set_wptr,
-- 
2.53.0



