Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060819;
	b=4YTPXmLmLEAeMbz7XgOV7r3pJKM6lHPZpsOT4HFtwTdUup7fQ+cBYZtkcni9JmW/jNbK
	 ATF79inGITCvnp9FEEBIrSkPnG6iP2EalXBJ/z+LvDg5BC646x63d0FXmfP81aKBlrA8N
	 n2nn36ZRZ/iUb7mAzsIj4PSHPEdDq9oStelw7KGCS2LnWadV/fpsV62a/r60ytlPUmiAS
	 8fML80ZqWVHewVUUxiBzAVVhDwY8bP8qy2kzmP5tC8xE9cx7NhOoe/NHV4/6KLjOfCpoS
	 Em33C6CVw0AI9KLBDsK69vN7VV1Lo7q5C3z2OWZIU3LcLggW+b9F5uJQXz9BMp3vmIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JzmeyIRBJ2zrBcYufh6DcdQMD/F3OdQy0DUngacz1A=;
	b=0khuZK7rz8/0s2j5PdbiMBG5o0HMDdV8aqI+NpTzcT3eetKnzRnRHGwZD2rcJdGTq5Xc
	 1ikvfxvMr2V1khMuaq0y1jVMGu0b/q/J/qT5H/rULN2n+kKZDk+bRRpTiGj/Kp2VJJcq9
	 E2qJ+B5MbEZc43uAfs9HKas+AdYCZ2AXT2F+QlUC5+mlko31W5+nZk7vVn0LlHYLj2leM
	 3jdOa9rPmUdB7/kObUoCjsnbFobqdYqQT3Z6zf2KFPIP40EL/H1bgAtCeGu2NahBW6Y+X
	 fwtb/7NFtLU9v3lc39A+2hP+3FXbzEqEQuiyetMNT9wCK6iCbDAhJXMciai9F3RLjTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOD6QII4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FF7606A326;
	Sat,  7 Nov 2026 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fOD6QII4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489351F0089F;
	Sat,  7 Nov 2026 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060819;
	bh=7JzmeyIRBJ2zrBcYufh6DcdQMD/F3OdQy0DUngacz1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOD6QII4aq39cM1uCHNLYAKv3APmt/6Ppb0v3Fv6s0le6nzOv74dnF6QcRonLrcTg
	 NOARAlyIF9Unskrxy7SFEX1T91KUISsswuWRhL3ZTU9i4YV4gm1fa+nS8x8dQYO4ja
	 9FL8HIsJZxM6QqAHeyu9p5PolgnzPj6TLLYkX2wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0217/1536] scsi: ibmvfc: free ibmvfc_target allocations with mempool_free
Date: Sat,  7 Nov 2026 08:37:13 -0500
Message-ID: <20261107135003.751101852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63cd0bab785ba..f73d6d49385c3 100644
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



