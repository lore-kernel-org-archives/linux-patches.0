Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016507;
	b=DMbjX6Nj3gOQG0xP2wdGHcFNRVR5tKfYS1MATIzDJT2tlis2bVPAT6BqpVzPbXPHeKAD
	 9y9eh5SvP3Am5Or1fJsLOFgbkdmWZpmjEoFyFghAr7fspJNq4iDL2KT1DUASZF/rHfaX6
	 6hg9C3lPDznHe2v8HsDBQfmqzcMFjVW5FI4GpIgxH1qNKZW00qlCBsmIjrYkmRnA2RTfN
	 PAG476fce1G3RNfxfT9v5NadfTbKw5Mek3oIp48J+el9WEZgQG2fDltmlr2gM01MUmumJ
	 hBucRrTaL7sO6hNFJnPIsZxOuS70y6177C6jac0e9zq0cII0dU3nqOc8Q7YsMrOAxYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vEIVECBae2lzv60+09FoD++nVR3PLiTcOBRZhzgcEbM=;
	b=GZW5t2XzoMxNL/66bTos6rYGCjGQqca6GQGjCtYwuYb21EYO5K0jqwekRc5zKtugRIpg
	 7NPNQy3AGEalQCD+Jbv4b0sh3Dn3vXvrC5fek0C471/gmKMEGNzCG9+T9YvZdiaz3VlP+
	 sU5zFbu6DxJo1sYTpGK0r3t/r84hYJrXHzkclH9bFRU7443b8oNR2g9ZBdU1hT5tDpBKT
	 doVbMLseqI2jt9ElhzkgKjtiy/HafVQtqUDYcDRFqGdDHRKyTTI7CIY7IPRa6qT/TmCx9
	 L1wUv0m/aAcL85dJBDfxHtDAFyKgK6jrkKo10idEzMsVPpVfqqZqPpq0mf3JMr0ObdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn2QFJgS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68D606A31C;
	Wed, 18 Nov 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vn2QFJgS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1F01F000C4;
	Wed, 18 Nov 2026 15:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016507;
	bh=vEIVECBae2lzv60+09FoD++nVR3PLiTcOBRZhzgcEbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vn2QFJgS+573NRhOOlL9nmTYMn07fej1prd+nRux83urZrLuqEK2LuQ8MVRmXSKtt
	 uFblSKO/exXT9/zb20apJnAooyZeKnixbTVih11shi8zjtE0s1ODJvdkADEcz7Fc1V
	 QLZVHOlvxdVmjWYpHzbmp8wrJ2xhRdVTDdZ/kveI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0552/2651] accel/amdxdna: do not warn when a sync request is rejected
Date: Wed, 18 Nov 2026 15:29:52 +0100
Message-ID: <20261118150307.618159872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

[ Upstream commit f2751f8754ae7ca0bba1a9536e153c8cc3aa4aae ]

amdxdna_drm_sync_bo_ioctl() answers a failed amdxdna_flush_bo() with
drm_WARN(). Both of that function's error returns are decided by the
ioctl's arguments, so SYNC_BO with an offset past the end of the BO
splats and taints the kernel from an unprivileged caller.

Log it at debug level, since the same caller can repeat it.

Fixes: dbc8fd7a03cb ("accel/amdxdna: Add expandable device heap support")
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260819224458.257346-4-taimuraz@kaitmazov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 07651ecb2fcd4..96f8bd46f0799 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1503,7 +1503,7 @@ int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 		amdxdna_gem_unpin(abo);
 
 		if (ret) {
-			drm_WARN(&xdna->ddev, 1, "Can not get flush memory");
+			XDNA_DBG(xdna, "Flush BO %d failed, ret %d", args->handle, ret);
 			goto put_obj;
 		}
 	}
-- 
2.53.0



