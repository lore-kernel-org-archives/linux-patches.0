Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046229;
	b=ACzxiD5psE0gJyNrdk1F3hOb2uy/8lRbdlW7AJMNv8K6PlF3L8t0+THmeSZfJ1HnQ4Fj
	 1d9yBLGlqrFLvdKEmOo9Y9ZYWdIqr8mLXPYgKTOJksdYuZHnc+GLzxZf97YE6AYMLLVOL
	 95v8urozI16HV7ELzWMTAwx8kvBNpSm78VrGRpHD4fG2Y4pnrpQACn0L2WWkE8gKIV5qK
	 6LKbiizfjdXI5z5yNiuVA6xpO1pA2rpAx3kdgdiast5+r62JU5Q7o/HJjGzPBpW/dLl+b
	 9HIGQElA22qZT76b/BAo9KUSYKsaYLmG+NVd5LQvJDJrH0FuvtMauRZ/1AZ1Qc3bbbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKIKQfbUd5oLS/aYr2yoPu7goiCYXPRMA7kJYOQXVsw=;
	b=BIVc6ZEn0n6ImfTZaYujZCBHbmK4a2uAEJMSbSeOoyJD00sNvlDSPATqyzX1t3UlCC+x
	 3k5QYBuUHLtrc+nt/8MWus/Oo7wXM/czBlFd5WisPjxpJuKtX5+ggGq7i/IXLWmmde8Mh
	 8rqjApf2AOWBPnLul3tg0KAITj9JYPYoUtjun5yuZQP/OzIcEtOpSW1S2w9mEJtnHZcqq
	 DTnzkHTWUe1jwY9eJ4792rKhNWHOLxKJDoRXi/nIyEtMp0Mjaza2dyGMjMBqUa349FSRX
	 TtADD/MLzmc29gfvo24cxYW4Mr02w4zsWAK/GwMLF7epcSNJJ2/JlAm/hgVJSa6/CTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO3T7YNr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BED5606A320;
	Wed, 18 Nov 2026 23:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IO3T7YNr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1956D1F000C4;
	Wed, 18 Nov 2026 23:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046228;
	bh=mKIKQfbUd5oLS/aYr2yoPu7goiCYXPRMA7kJYOQXVsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO3T7YNr7FXNXYdhO0K7YYzA8s+sm+LKprajO+46yimd9HFsvFO0XkXKiM3jkpxib
	 RJABKqD1wNVFd3aeC2VOVEl0vfjj4Dxh3NMUwcPDQ4NZfFLl6wS+BdyxKsCEdt/XZd
	 PMKblXirbki4/a3fcShGtaVV2znf/M7R1DjmVwUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1166/2857] s390/vmcp: Initialize full session info to zero
Date: Wed, 18 Nov 2026 15:36:40 +0100
Message-ID: <20261118150243.571667402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4cebfaaa22b43..614ec6c291752 100644
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



