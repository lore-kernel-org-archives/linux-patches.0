Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051245;
	b=bV0cTXfKeiob9SGqB+FVuO79ThsojZecmWkknRRKwH2SlVujIZ38wh+NEtBHkDd6tIUG
	 oP6vAfWGwu79Y0ALWQe4+eZKQdAw2dirUdywgLhqeNV0ABj2i+Ti9kc9nrMJIXj9+teeR
	 cI7KbwiFwPi5/W5Fi/fXY+o1+yEGGgeTfkqK9cJE2WaP/q0q4Ci5G0w9DHEOO98ApVarb
	 be/jLtm/tHG1zMObFvjubYOOOj3FZAP+f7BbMloVHGC1PF5X+PTlMeOfP+4tWplMBu0yM
	 LCojwyXEH0aaqxGQxG2N6AG8PMw/RMdNogLrRhjDlRQgOPhwhfYVbWXBAswAMPsa9zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hAj6lqpRNsf11mS/fkHxhkGMXg8vmloIEqro4r5up3M=;
	b=Ds3XFDK95HEtHNhOrd6CgqxlNTB84oKHPFcypozImnEiLwgU4tN7XbjLaREbIpy71/t2
	 l3XhEI9KBd9CT9Ls+OvPSj30N4OkD9I7HQ/SJLJgpSpKbsZ8kDcHZv2mG/2lpsupKNhMT
	 wp1T+Ea4n6uMurKacag6ImPmUuL/4+KayYCe7pQls/DdgH5Kh0cBetWLJi2cnqQTOTf+Z
	 Y4BcSV7On93gj8GdQh2NGsJOuzyWJ1d9nQNDPVRLFZk4d4GwtOtkEryIOSk7S42a7V18H
	 4Et9BPwHSrsXQkOzaLJWQypBp1KI3GeT7bxaKCS0EI0MijnSrdwS/XqVhg+SKqQOWFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0k86xJqb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA919606A325;
	Thu, 19 Nov 2026 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0k86xJqb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465D01F000C4;
	Thu, 19 Nov 2026 01:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051244;
	bh=hAj6lqpRNsf11mS/fkHxhkGMXg8vmloIEqro4r5up3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0k86xJqbOlnMb0olmQoOZVLrfF/FH5KTMknEw/44AMbzF7YRGGJ6l59Q5H4uiIl3P
	 Qqc+8M/bME6MG8lsPi57xS2iidHTZo2+XG/zAv2sOfpGU/K4oSOmdlU65gQFLiYJSm
	 xePJarhOKGFlDX9Om1yf8QMLCifOtdPnDQOphv1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0141/2214] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Wed, 18 Nov 2026 15:30:17 +0100
Message-ID: <20261118150015.818746984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7ef35dee56e77..a8736427b246b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1352,7 +1352,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
 static void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
+	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
 
 /**
-- 
2.53.0



