Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590901;
	b=NTFjptJdqYiXCHWv0VBMOdvjQgwvGx7CqIxsflXqvOfMj4VPqywgrFV1M3PZGzu4bFsl
	 agjZnD70zsiyvAxuwp5wa1cUBF4eUL7NUlmLMMGJTgynSv1+0dgHEZwL1IttFjH9l9e2q
	 49NeZdfNSmP4g+Ggz/bfaQd6+Ar8jcyogZzGwfg5VTgZTjIkfIj6IQ2uaJ7MUWSgH0/zP
	 Uihri0bC204QZVjvIfNnpoJKYJD5wNnck9OfZB6/e0krT9nXEQokV/3pKOVYpMZ4mxQnc
	 qwzB4RRLs56eUosNXKLqvBUnRI535LKRCWnZWgdnSeOMD+DKfQAfKkRp8+zMaEm9Yig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvid/rODD+IK8kjWYq1t0keY8n3fX/itOqOb9uaKWi4=;
	b=JvINUWWOGKbXNd19SfiGUfK9woCmmIJFWpdTjgOOpD0LEfbX3QD7gCHB8dyCcNe7OC0H
	 QwycI7wYzgkqGp1rZ+PcQ4/kxjyYjsNT7RIYxRNU/1HSz4WrPyLhJW5wMblMIj570FNif
	 fCXWBYcbedofm5VvMqgxAd1kpvTZwxi5aiFSqCAUpc4y1JNLGb0ox9lB1XRCasgWUxnaY
	 dfLcUPGYwfMdktvU8XrSj3crOEsTB2O61rEuDcgGk7BPrCIFl1essm0bigpAVJrNVCAZ0
	 66RsXUCAReHwx3+bf+KhedW3+JOKJFII33GnNuDOKBOQpcx5ykqkP7fz11se2lSu28g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEU9DaQ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E45607EE75;
	Fri, 13 Nov 2026 17:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEU9DaQ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91941F000C4;
	Fri, 13 Nov 2026 17:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590901;
	bh=uvid/rODD+IK8kjWYq1t0keY8n3fX/itOqOb9uaKWi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEU9DaQ7tBeqoV3/NQsTmIDJK4Y6V5CKwaH1dVhOrEFjF9avUic62YtguNBUDVeUX
	 6ADFJ0TIngGPZV7jnvL3LBTvPuvVFyPbHvFdLSkCv2SbId33E/TvCner7MZv0R4cLE
	 VowBg8nGAwVQEF1piEK5DvrM+fHec9Y9a1AyPQdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/670] s390/vmcp: Initialize full session info to zero
Date: Fri, 13 Nov 2026 10:44:15 -0500
Message-ID: <20261113153814.992852072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index c6d58335beb47..4fdc3f1dc8db3 100644
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



