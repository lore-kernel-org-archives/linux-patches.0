Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016513;
	b=V28uNINuFlk5Bm0xTWZimsM/9e1yS41Py86X9er8T0D6siSnnB9lfEVPbObkns4vZ5dV
	 g7qPoEIkH45GjM46EXGXEl0kTRN6gFNKJaDmkpFfsoK/9MfX2u74Gbq7qzzUANIq7aClU
	 X6LyvmxeS2lWSRfdVvMepOGw+a62dqn3R9B2j84uE33S9LgkPZPyppbMpEbzVKCBYbG7o
	 7NyT9QG/v71Sm3IUbtycYN1D7KrwsyyhGfyFqxOe5gl2yKay3lIAZyJbakweoh6aNDQRF
	 P3Q4tKoQFE+LwPEFzNnYe2qhroRRpvplKhFRZBgkDKz+cFQ5oAdU7JvdVJEqTII361A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aUaoNB4LcxOIwVqv80UnL2KvfBWbv7GrJgAkh2XhmYg=;
	b=RqbCHkGN65oN/CErrddT6WxAReqmerLj5M13OcKsAWJlBJxDLxj4VJCfe5eUBTKd8bel
	 wv4426IYPvx4DpCbKUDQXDi6kMNxOp9SqgB5yE0agJzSTijMnyJhCTOmyvYA6ef6SIR+d
	 eJBO7Z6qMBZVNEG+y4YoqIcQnwXeC9hOtGrY9TJp3IB03mlvW6Ff6D9zOkK9yMTKOS260
	 JeR3E3JnpgYnhQ38pkMyQlFJ/cLUlgbw/JbEE7N53ZI8WIRZbjdKtOQZjEm7y29ffU9uK
	 KiDFIzFVwubAFXKlM8fUPSeOb+2DQFnxD9wcSxY/WaHGA7EDtLSLPjXwsm78DsPlJtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBkUzid1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C7606A325;
	Wed, 18 Nov 2026 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBkUzid1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0478A1F000C4;
	Wed, 18 Nov 2026 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016513;
	bh=aUaoNB4LcxOIwVqv80UnL2KvfBWbv7GrJgAkh2XhmYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBkUzid1cEBG9PS/74dHtLpPK9mvv14ANq1hgemBmoprGR2fulfKGVMJNtmMP/CGk
	 GCM2aCp7RvHk7rK0Ansgz3zC83rqnMrKAMmMszWDRe4kds0GuYqR2XMk363ocG87EZ
	 RDTFuFpRrapp77RM1/c9rAjrGHOvSCRImKcds9SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0553/2651] accel/amdxdna: do not fail a sync for a BO with no debug context
Date: Wed, 18 Nov 2026 15:29:53 +0100
Message-ID: <20261118150307.653092808@linuxfoundation.org>
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

[ Upstream commit b1da2a6cc13d66c03c364f7b72d5a343b3ccdb3c ]

amdxdna_drm_sync_bo_ioctl() calls amdxdna_hwctx_sync_debug_bo() for every
FROM_DEVICE sync, which answers -EINVAL when the BO's assigned_hwctx names
no context. Only a BO attached with ATTACH_DEBUG_BO is ever given one, so
an ordinary read-back sync reports failure after its flush has already run.

Ask for the debug sync only when the BO has a context. An unattached BO
carries AMDXDNA_INVALID_CTX_HANDLE and hwctx ids are allocated above it, so
the test is exact, -EINVAL keeps meaning that the named context is gone,
and the handle is not resolved twice. The field is written under dev_lock
and read here without it; the context is still resolved under that lock, so
a racing attach only decides whether this sync sees the buffer.

Fixes: 7ea046838021 ("accel/amdxdna: Support firmware debug buffer")
Suggested-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260819224458.257346-6-taimuraz@kaitmazov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 96f8bd46f0799..f4832337ec31d 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1511,7 +1511,8 @@ int amdxdna_drm_sync_bo_ioctl(struct drm_device *dev,
 	XDNA_DBG(xdna, "Sync bo %d offset 0x%llx, size 0x%llx\n",
 		 args->handle, args->offset, args->size);
 
-	if (args->direction == SYNC_DIRECT_FROM_DEVICE)
+	if (abo->assigned_hwctx != AMDXDNA_INVALID_CTX_HANDLE &&
+	    args->direction == SYNC_DIRECT_FROM_DEVICE)
 		ret = amdxdna_hwctx_sync_debug_bo(client, args->handle);
 
 put_obj:
-- 
2.53.0



