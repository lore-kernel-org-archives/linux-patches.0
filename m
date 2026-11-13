Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590119;
	b=owrx2MM//smlL5PYA0W3TIiTUSCPg3yYXWmsIgJkrJaVRD2NsCWiKsqfPSmfyX7NRrql
	 1rvveB2LYo0UiCP1hT26lc4nIUaSR8uDKiTE5Ii1HpNtJZyyIbnTQfnLc/5YPlz2zJc7E
	 tTI96SdxIjJQwRgsmoGcKjNq7iIzLDkPfsjlc4/x4Vh0shxwcvi6lC1tVEK+Bt1MTZLeX
	 b6tdHBE5T70w4e7oWHyYlaFzWJAgNWjkLBTH75A6We9yzXKWPyTE2ffZRo1PqZ5GUkBVZ
	 SCOGp5A6POKT8E3Oldf2ijwuaSCM7AaCXiWRL8tOx5cyUsTFzBtPEKgXepB+z1zGVpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0kGyXt47TmSHhcnur11QKWvZsahJErvapOfw42PeXt0=;
	b=1OVKtjftIaBwL5p/Yqx6N6SOdraC2FavxKpr/n1YZWEUkfunofCqlJcOlDssqLBnV200
	 feBG6WljObFZsH2L2pEJZWtMWsqppLvYJN75YrWJk+pcumyxFjdibvD0pxQ2Yx8TSv/Y4
	 NhOawyZFub6Ka1LDn5bKWDYBoffxGjYnUUluPPb8HQBt4uJtdUSt63FhLqfPUZrAljsbO
	 zWESZDnBGenmdW/LSiW2Zh3LNkYP5u+ZHsN5I2QgIkaQX2jVkXEJ7n83qaf9IIvitwz5D
	 eSZKMl0D9BUv52WLVDs3ZxMS/gFgzAJz3BPgtMmKWWnPEwDLq/rTiBVw6bqLI2771KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFfKxkot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B99606B22C;
	Fri, 13 Nov 2026 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HFfKxkot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C2C1F000C6;
	Fri, 13 Nov 2026 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590119;
	bh=0kGyXt47TmSHhcnur11QKWvZsahJErvapOfw42PeXt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFfKxkot0cNJfPLPOOmYTQHgwm53vmJooBBWzSwu/BXsDjm+MOmumKpXajsi4Ep22
	 eDx+HtxYQwZ2XnISscv21Rlby0wUMDqWBZ+DbUB5ruKbgJL2+aXSnIyinTDVMNy5ew
	 pN1DwHXeSz3PSL8P8rGlSi1dT5ijH/FRmiLSC0rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/686] s390/vmcp: Initialize full session info to zero
Date: Fri, 13 Nov 2026 10:43:49 -0500
Message-ID: <20261113153824.118962791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit f63eb4ee4a30fc5d8de07a229d92310e3c8d560c ]

The cma_alloc bit as well as the response can contain old data.
cma_release will not free the kmalloced memory in that case and
the response code might leak kernel stack data to CAP_SYS_ADMIN
users.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[borntraeger@linux.ibm.com: use kzalloc instead of kzalloc_obj for older versions]
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/vmcp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 69899bb86b3ef..1d07d7b6acb82 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -105,13 +105,11 @@ static int vmcp_open(struct inode *inode, struct file *file)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	session = kmalloc(sizeof(*session), GFP_KERNEL);
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
 
 	session->bufsize = PAGE_SIZE;
-	session->response = NULL;
-	session->resp_size = 0;
 	mutex_init(&session->mutex);
 	file->private_data = session;
 	return nonseekable_open(inode, file);
-- 
2.53.0



