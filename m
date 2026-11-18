Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057410;
	b=zU7ZAGeeuhcXYHpzJOU/t0iJH1ScGqGhwp23oRcyj+loJsX/XamjqsCOzmJJTgc9kcVn
	 4Fng1higDDLxOuWwmkDH/yYpJtMxexCEJJIQ+JpW5ZteiQFs8kVylTx+EO/XZcmknhyVg
	 A80Sbz8cvMBWInTOraE5q+6KDWjFBLNLfh1yyMaqMp03c4EkXKfkYjHhH7mQFvkCTyQLc
	 nz0JuqkeWpwiwV8Zl+bKh+y6JdcUxM8aPUS8ChW6UmDRk+DKjBSmJb4q+0PM/Lr5SM6U7
	 mAet6+K2ZRj/W6JJr/w9QS81bD0k0moRrc/KQNVhWChUvd0Fp9d4QZGz0Aa3fN4eFQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQfea/nqw0lC/pub2Qwgk+PvJNrnbKfOGXX6vWCnkx8=;
	b=QVgLpGdjDMd/3oLKfBCE/TkUFa2c3dqoalMF4qFuMZ47+EXYiprZcd/5pQsL4+dJ/llH
	 X72+lz/v4869qvdMs2UzqB150dEw5Wap5BKzuMPYOasXCocu6h6wAlCgOYNCkgllspSGM
	 cOramEmUs1uHoy33Q9HbOo7wTMFpVbNROBd+MXa1IrUhbgx1+M36OFJirOwUKTpe/ngI7
	 NptqxaGzqESpyVFIEcnJJ+G+3VQAHIFnVF1FZmLx4b1q1festOjSss/2tc77gTIA6laWm
	 U/q8EJKCZf31b/0f8MBWp1S2uHGicsWgF6zVCIC7Gu0itlSjI0BIMslFS4uFK7/ETcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFtQGrTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5266606A33E;
	Thu, 19 Nov 2026 03:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFtQGrTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362B31F000C4;
	Thu, 19 Nov 2026 03:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057410;
	bh=gQfea/nqw0lC/pub2Qwgk+PvJNrnbKfOGXX6vWCnkx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFtQGrTPHsPw3L7sXMZun6m0YYpVFEQJDb7AlWA1WU6NNdVfbD0v/5R7HOAhDra+C
	 hfjFU+cf//AYDSFGVtaLd1OscTv1Qv06ZDQK/71oiKa8l1GkD+AiCCOHABhUMw3tUD
	 dmdq/hWhgWsVTYffM2vfmz1dmrERkB9vIcM9MoEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0121/1848] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Wed, 18 Nov 2026 15:35:59 +0100
Message-ID: <20261118145916.011625334@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 99143433f7f14139ac373c553ec8e1317d0ae58a ]

The ibmvfc_target *tgt structures for discovery are allocated using
mempool_alloc but in turn free'd via kfree in ibmvfc_release_target
breaking pool guarentees.

Fixup ibmvfc_release_target to call mempool_free instead so that memory
is properly returned to the mempool instead of the general allocator.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-5-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 34a2ac95bff8b..e6cd301e2afe1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1097,7 +1097,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 static void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
+	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
 
 /**
-- 
2.53.0



