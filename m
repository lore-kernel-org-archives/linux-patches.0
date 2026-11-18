Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058926;
	b=KJRYPV5RQ8Rkku/iLxib41de/KVagQ+Lyh6X4mbnBOxdOhDq/6SUGgwzfjzpdODHREOp
	 a5A5n5xe7Wuo4/f/ZwvdRP8fL5mUgCvwru//kSxaNMFKhpaVhh1GR+3l4Czr7YSooSgah
	 Fn1Ut6UEl1A4RWGl8aeIdHiHzNUwFDRz8xf61j/Gnu6s/2PHOGiEk6SUm5D0a6MpLqwxe
	 eb5HFIVzy1c2seN6OnpTdKyDepeg1HvBgJSrbYhinViPvaDcn4EsBbujO1YTaOV4lA/ft
	 1r467DM7+kXmDww9XmzDmms9Mh48p+X3si5gUb1hePIQuUa+lfKCdaHnvRT+XLPWfzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FSAniEusGwNx0mbRh+APogkgjAXT0Vf6vHZjRYgqp74=;
	b=goq8qLKAQZwlEyo7WbhD2x/OpmetvUo+0PJFf6Yob2igQpv++aUSyKOs7mgRgnu15CmQ
	 T+RhjF/5JJTvrpvOhTuWxMnxAqPT/R0jXVRiSK3Q0D4wOZSKhWP+KxNGzHKO9QVn7ts+T
	 RomoeDK90C3Rj2xmRMy3HSZb8qrJCXPYWrzycy6RGpxqaS0aw/A42O+ZS+uW9OZd46qAP
	 AhG/zYseMoZTY+u+iN2qC7V09w5G8VTbx7uSRzHiVYqPQDSk+4yQO2jer2/Hkg9xGX7Mc
	 034DttP8ia/3/NUR8fBibRt0xAzLrfp7CW9jdGzPhVI7pH1ghN8fPmgcUo1sC2t91Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M+4S9/pN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58F1606A31C;
	Thu, 19 Nov 2026 03:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+4S9/pN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D871F000C4;
	Thu, 19 Nov 2026 03:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058925;
	bh=FSAniEusGwNx0mbRh+APogkgjAXT0Vf6vHZjRYgqp74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+4S9/pNAvqJ7VBQ6Jtcpqc3f0YOl1uy5bGSMY9F8848HU5HCBptGQoEGMcoex/WU
	 vE9Qd5PP126sPxD8I5ZdJeDK+xeytESVxK/XYBtgzbV6mqsN/fIQruIE18hQi+fEVG
	 6OJLTLxkEBcW90bRAqs+waHAnNj60ejZnY4HwX4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0658/1848] s390/vmcp: Initialize full session info to zero
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118145943.326830239@linuxfoundation.org>
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



