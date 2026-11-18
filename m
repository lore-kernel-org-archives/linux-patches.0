Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053142;
	b=HFF50uXhwBN+Zacbk0aNOGPReiIQnckAhYPQ4m3eNFd1Qg0E2lhFTaly8J+P9c2BJtBk
	 KkXxihC3SOwUTZR/cdIw/ELBozuqpJPVU7VVu4JqVmMnHC3JLFqKld7esY/s6ZAbJF/XT
	 9XBiKEbGhSMrfxhq6Tn1+GPmLbR+bc87ypVApyaN1sZBQZR1sqNUnF6iHeTVcSGT1rhjL
	 pVUcMODT/GSpRCBdlQiNkWqJZW0HXj2eBqMWi54OrQ8lPAfvtwn8pqtzKpW5mhTspg0iM
	 GTOn/TOEOH5RMi9x1NFtdFIhel7hgPrL4qJ+kEbrXwXI6XpF2c9n3lIMtUXBWHOCkGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKfoWze+GVgYC+Zc2ZDW066XQCxtzWjDeuGFWEcXvRU=;
	b=0niyaTy4xj68LEO0QBYFjcWSJIdU46JJOEbpDzWQXgvIQGnH/dL01UDngR643R4mQUyV
	 f69NCWX1UEiszE9qQwE8ihHUJjvH1p85+v0kW53684tfhIyCnRhmtY/KS4f66lb6oYA5q
	 OBiq4NRMhwrIGEFsHglqN2UKqVxVF15Igw5ZAWGYbCAqcHZo1kOuI05eYxKmydBShwgAC
	 +KQQvDQsQQO754ePFr4VqI8V6XvlU+MKYvHfi3T1xhF9aeKxyVmn/+IXSH/Nn6Frc1FD0
	 gqLctjB7xhDMw7qOHo/yaxgMHLuNTrop9b/WYkh6ujBtfzvDXhCKinoOrt8VhuEr8Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKds23Sp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C434B606A320;
	Thu, 19 Nov 2026 01:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKds23Sp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF21F000C4;
	Thu, 19 Nov 2026 01:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053142;
	bh=qKfoWze+GVgYC+Zc2ZDW066XQCxtzWjDeuGFWEcXvRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKds23SpoZrTRySwG0deKCM1s6qlTHXDNyR0psCzTLJUWl+uRuJiXuxdIh2tl9mDK
	 VMMkaSfY5TK+o8GOX3OsZa4FsNM3hpKhwvAY+4dgvp6RNBtHcdHPc7QZJslNt83Awx
	 dboYcffgMs8do6WtYs6Gnkl9GkFItOdos+BHKuSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0814/2214] s390/vmcp: Initialize full session info to zero
Date: Wed, 18 Nov 2026 15:41:30 +0100
Message-ID: <20261118150044.101132447@linuxfoundation.org>
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
index 9e066281e2d05..d8a348fd9a640 100644
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



