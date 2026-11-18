Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016126;
	b=oQaV9UvplmOqdgz8rrRVAvZowBfkpTYpQnMav6iQmKgZJynpZ5BD1c+T/bMicjFWPrTE
	 R/26pd46/eK4wDk2KfgZ9sAypFUhoupnT5clCtYNslCnVdPZFk1Vv19fdR7a4VJt08Fx6
	 f1MicXiHcPXNPszEjkRbEAtShXFXe1LXsPZ4QyPjuoQpW0JttJfKbz3JtzxcxuplSF8Sh
	 GWakDaHCSWoME0jx5LBPeLFkEg3yArTI+wNLXHr+7Lp2csYP6jJYhHJsKDPb2t2j0M7Ij
	 UWwVS8BNvmXBWqAPXJ7enNyFnSv3BbyLMMdBX/X1LoyBOTkTK5rDCQMI0+nQqCiAuHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJCs21WomckdYX0o+8C74o1Jbb8LWcNQTN6yLSHL1qg=;
	b=Vts8qFmD+tFMuAXOSswz0e1QvmG3sVgJqURzlIC1R/+b6Uxsa2m1pXVm41C5b0UgaemI
	 KZSzgB2OSBNq1UJNNdIr+2UfaWyfOvsdgdW7cEtXYc71cwwWOiVMKon5k/bEEXfptbnfE
	 Ex6Ohk9b+WWc+rWhGDaZYIbYYi2rP0tbperAqKSPU4ZJG5KsFvTbkaHLz73eGPLHQMS73
	 bAMni/LK3lyLe/ZVyr/XjhvXEF0XdEWX86AvuNFPtJPWnhiHqOufBVzUAnOQMoBOFrNNJ
	 XXG0s5k7naYx+cDhgyeSncyrSbs5l8QK/siTHdK63Ftt5SO86AR6+rWG/NMP7H8pkdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pk/ePCQy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E82606A31C;
	Wed, 18 Nov 2026 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pk/ePCQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEBA1F000C4;
	Wed, 18 Nov 2026 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016126;
	bh=MJCs21WomckdYX0o+8C74o1Jbb8LWcNQTN6yLSHL1qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pk/ePCQyRsgvDDeX7Kj/zSdSQ0eaP6D/2oQn2lB8LYDjf2pHeGwUicc8GpL4QR979
	 RmIk9h8jp1FIVOcGgum2NwFafBMySYO49YgNzxMnL2Ba1mQPPfnZyDjXaq9SPf4w2G
	 TCVV1E9ItwaPb3zPhz4BBxu9KWBB7U3UqDWxCK0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0417/2651] accel/amdxdna: Disable BO import via flink
Date: Wed, 18 Nov 2026 15:27:37 +0100
Message-ID: <20261118150302.847565891@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit d0c0ffdba93a589f78a67c264f8a4b4998e103c3 ]

Accessing abo->client in amdxdna_gem_del_bo_usage() may result in a
use-after-free when the BO is imported via flink.

Disable flink import by verifying that filp->driver_priv matches the client
stored in abo->client before accessing the client.

Fixes: 3cc5d7a59519 ("accel/amdxdna: Add carveout memory support for non-IOMMU systems")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260902180955.3999242-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 3f05fa8811af1..08e22829f72da 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -697,6 +697,8 @@ static int amdxdna_gem_obj_open(struct drm_gem_object *gobj, struct drm_file *fi
 	int ret;
 
 	guard(mutex)(&abo->lock);
+	if (abo->open_ref > 0 && filp->driver_priv != abo->client)
+		return -EPERM;
 	abo->open_ref++;
 	if (abo->open_ref > 1)
 		return 0;
-- 
2.53.0



