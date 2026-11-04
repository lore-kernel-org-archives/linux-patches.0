Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829649;
	b=UEGTWAmm3tQcibeFRi3OeEKLk8459tI3tWzAYMUDajgQwtPuuSiaixeJG1/cUy2g0X8A
	 m62vuzEXpgzrB1byKOEOjrlabgJo+uWRI25AZtPLrstj/3I0vCJCOPsDRM6b3jrjSNeGO
	 B8fwv4HWBflR8A38UqCoKvVofrfF3GIMRmeX+KAPYMenP9vqgLPRnAZMX6NGsAzDNFJNQ
	 6zDTNI9SuzrLyDwEHf6h2BJln0EGuDQcBupJDl6vBcbjj4NaHeInwllMG+lKoOunOxDUs
	 gN47Elt/8k4Utfl5fajHnVOHbUQBmGUQIp1gmfor3j+7AbJFjAT+wj51ewTAXPAbuIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XqznazaoQ6dFEj3y89u93PrPg+JLhCPlBGh6Me87yIA=;
	b=Cj/Jm/mVV/n3kLbB+zBtX/S87P/38PYr8SnIuR01+dPSkatdw0QxY2WAmudsqtRUjbWo
	 HrDjuZNJe+aVycAmfbj4ks5dQAje4Btmzg3OvAgyqGGtve6KN/KjWFtzvxbE7DEaI/WdK
	 51zhOGoAqQ8x+E2izpUvrEe4Mc4WRzvjQAnXuUoCWIISugTFAJ2f9jZ44/i0pAErF0ePC
	 58XO9SaKdrFmTpC4LP+XHEfks+x4rZvNLFZO85cRetESHTujgw3vS5F1K5owlzDRoUvZO
	 qb8ATxHc4NEoaQV91DveKiAWMQd3JjYtsadgVWmJ/zrD8i6EzXjf58eHT8ZghW+NHKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M1V6tCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0018606AC13;
	Wed,  4 Nov 2026 22:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1M1V6tCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8064A1F00A02;
	Wed,  4 Nov 2026 22:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829648;
	bh=XqznazaoQ6dFEj3y89u93PrPg+JLhCPlBGh6Me87yIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1M1V6tCm91sK6O29G0m2LolVs4hTO6jhgRjc7wYtLiQELwcwRP0vHKmmgc8ZjSohH
	 fUX9n4HfBEnpL8MTg5ifd8nm3JE4FmE0AWW4ishEppnpvfveANPE0caBpPrbEa0s49
	 n7nje4q/S5tB+sw6gDwZwACE/CrzNTJdrE97oO3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0255/1005] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Wed,  4 Nov 2026 15:59:48 -0500
Message-ID: <20261104211051.008963503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 63cc569284ded..e3853e05aa27a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1366,7 +1366,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 static void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
+	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
 
 /**
-- 
2.53.0



