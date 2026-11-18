Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037353;
	b=aNOQtDwH7nxc7J12hAKdZ/Zv47LqtyRo4qHMry3fuV92biTgF19JWTN0zj3UPj/PYm+S
	 Qg1h0sXySmh9peJS24fbqIBxMboBkQEsfS3meGgf3qy9eGiGDQW/VrFZc/xhsRH4IMNRh
	 iiVgqXsxRHcxadJlcOgWmnuzpn2nV7bHS5fsqIXBzyvGed1uC245aBhvneLNaO08+IpyS
	 fosjIJZkfPK9HGV3w4RV02L1wh3r8w/QRkQnUxyzMXUfX+xhpsdfZC64Et4VHDFS8hyI0
	 jWvYMwyQEuXi3AD8TA+hc7PHJUM1+1P9JjWtur+D68HKdHGuWyNbhwW7MsgrnwOFYGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WZLdicDJeMJoB9fDoafyWG+IsVDAo8gnqxZKyV0XEXY=;
	b=iUU2cw7LgydvuG+BXOUDgfxFKbY7KIkvraPNTX5M4xw8WvGGXb4vAjp9zydXvoQ7uda0
	 fCLgRNPAZGJzRhATPDCQbQ5ThUFNOyJ/hOJy7dZ2+vX0M7amuXUJfyyy+AGBiPvalyslm
	 PK70njcTdQUS3TYkW2mJ21/bbXQtG4vz9T23ej6RWl1uicXBGbqfvipe6VoQGesI5FC6h
	 xp5jbh0d0EC0/+uu7QrFZlxTaLcT8R84tuQc9nsrVoETHXqCA+pBEtNCsINkyT/Xy9Nh7
	 73hyHBBcswVyYJtr+kFybanyPYVMJ3oQpL8q/1e8hf4dl6taVdOcKiHL+QRyK7jcDsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSupm8h2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF9B60A2637;
	Wed, 18 Nov 2026 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sSupm8h2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAABF1F000C5;
	Wed, 18 Nov 2026 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037353;
	bh=WZLdicDJeMJoB9fDoafyWG+IsVDAo8gnqxZKyV0XEXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSupm8h2j/52q2O+a2ZUTuu2Kw8I4B947jCiqLMsbe1mnvF7KsHEY06BhrgSkU06C
	 ooOknAL108zww9fBkLXxK+MQnqh+Fp65DfoPLIjc7ucvVnflnDwKG61dbtOQ5rsEnY
	 Z9QHiPFMj4LFb7Ugt3S0gwNn2RqdHB0APIE0e7cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1373/3318] s390/vmcp: Initialize full session info to zero
Date: Wed, 18 Nov 2026 15:33:15 +0100
Message-ID: <20261118150401.699674655@linuxfoundation.org>
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
index eb0520a9d4af5..db4264f1f998f 100644
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



