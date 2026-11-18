Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033909;
	b=BIkjyQpQRlal4AuYy5HKv44KF8UQv53ggxsPLRtngaXCHeuPRUM/wVegqUss4dJsbsw9
	 O2nITK7kzII1O78ZAobA5Ca6ewbGzr1dAm1QVw6XMD7tiV26oCHvfmQctaS2om3aOwxuP
	 DdJmz3Z3Ori9YMa3xovEFYyZv62Cm48hE90yZ6eLWmNYbhtUy0B5nqQ2WNxJJGcLL44/l
	 Gl6PDgT1nv4V5h2Z8wGxqyWRfVUQuQwWZkA/KTAOS7gzO2xyPlVTN6U6pURx7W/PgJAGj
	 AgSrX8nGsflnfnDfv09jyT+RvnWlKGosFczFI0YgEMx2IpLtnTtQGSX3Gf/fMhHDULA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4DuGYnOMPR7FfAzFPNauwmRveGDUUBqaJp3kxowJwUU=;
	b=4I8YCwieB0FQlIx0Kc2FLNQM6T6NTvnPy6Z4n5KM2oMSCK0Y0gKTGP37WlkjKdenq//U
	 Z//Ib5vYnc+bv6/UIqINltew4W0SUTIQo1BC6ZrD8bbtYbX0mGkYZVxcqnPry+RYljvw1
	 MfGGVrS+Dk/v3LQBfFcyLjQ4ado0zPC5MR2WHXOMAk3wW/Mq17YH7vWcP5hbcfn9LvwUC
	 gRRUkYUdXdXj4fFOoa6a+jLDvKxk3DMr8Y7qA8mZJpA2uMbaavt7RDvvqjZsGwx9q1f5H
	 suR6RIk3Knj0imO9X0hl7++4XHuixAMsFJV7FeLfSRilDD5q6eHNrtbT461jsi8198A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lc2E+ngK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB2E606A320;
	Wed, 18 Nov 2026 20:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lc2E+ngK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB93D1F000C8;
	Wed, 18 Nov 2026 20:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033909;
	bh=4DuGYnOMPR7FfAzFPNauwmRveGDUUBqaJp3kxowJwUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lc2E+ngKX3DAejNJPKKGCB/RKpnQguvhJseDxT2K4ylrcVJIWPIFjXDB/b6GPHxm5
	 CmkPOaa5nFpyD+jFa9vL9ig3MihoqmN0TuoedR2abcnIr2MkXmZ4HJCdNeoVpl2yZD
	 E5SoGpQ1Y+wnljAvlhSSfNyrhRfriQqkOi6oNXPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0182/3318] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Wed, 18 Nov 2026 15:13:24 +0100
Message-ID: <20261118150320.185183188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c263b93a39a7..a590a2a0e6354 100644
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



