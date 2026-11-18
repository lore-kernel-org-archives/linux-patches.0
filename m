Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021080;
	b=f587mS7l17Nrywkp2LEnQ9rGDu5ZqSyFfe/XwIUwGyWoFzInQE0BhJXZdGiDINVM+TTU
	 lSHi2DKfivdCSBpl/FbR33//g8kIOZ+QdO8XiXIfqFkj2TMsHdOcFyMKBFlHQP+mMUxE0
	 xSNypW7ZW6I/dnjQdoT7xptBQJqdzy0PCzPBBKDc2ey57/l96YiljfF/08XQLqkeCy22D
	 ZGox15iyE9K7ATCGg8FUkmxycphCeJg0FMNwxCsYQ2xGMsusLCRUVFAqdb1VnRXx8D1Ek
	 Vi9Xa5lziCTZJ/ZrOgfYoYArMn0m7qiWk4t2NVNbWDqPOx1phi+x40SFmg/c5BZR0bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aACPd2xh+vYq4x6HwKdgjpJwrs5LlSlU6wg2oDTWTQA=;
	b=gMa6l3UhCN64MDSYqiYWfr3/kZXBhjdBLKXmBwsmVsAgGAWok3/B9WbWfnZcLMEyfYzB
	 kV8Lp86GJ2fAwl9u+IKjVfKSKaXS2bDKp5LkQ4hygRuQpzU81F+xNPkvB4v9UPAA3pqPs
	 sH5LkLDf7T10JayRh5N6m8QWUCy5y7xavQzD6wUt6/4eA/eeA6n0KKg+LP3v9T1XGd7Zz
	 AIidNdZvh5sVSkQCAsJRd6fMF5vUJbr7VXAmJfFyA1eCM/lXONwKbe+L4ZooRRTenpaTy
	 +euuOC6SvwircH3z/Y1dSNjxUitGCg7KTMVNHQ4gjnZLjx9IeMxgS4fqp0HmDHZ51Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMkQneSm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387A6606A32A;
	Wed, 18 Nov 2026 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMkQneSm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A491F000C4;
	Wed, 18 Nov 2026 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021080;
	bh=aACPd2xh+vYq4x6HwKdgjpJwrs5LlSlU6wg2oDTWTQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMkQneSmV/zWOLgJVrEMx0R4gHcz+FERtxIpxpt8tIq7dFghGaJ68+WJ8GHYZN4y+
	 N6xumfTdEBjKyvCQmrm7sQp9ijhpHPVaDdceiDa/yC9HMNLfZmLvRdLtfNhitrj/xo
	 ugKQaloLuSHnD1dZALuNrXOTl+XA5rqSXirZWHGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2143/2651] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 15:56:23 +0100
Message-ID: <20261118150403.003911665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 9dd8b9a337af844291edcd9139c927d0f7958dbe ]

In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
stack buffer 'buf', but it is initialized to 'count'.

Initialize 'left' to sizeof(buf) instead of 'count'.

Fixes: 9f637f793602 ("IB/usnic: Expose flows via debugfs")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261017185028.1019445-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 10a8cd5ba076e..ece7c6e714997 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t flowinfo_read(struct file *f, char __user *data,
 
 	qp_flow = f->private_data;
 	ptr = buf;
-	left = count;
+	left = sizeof(buf);
 
 	if (*ppos > 0)
 		return 0;
-- 
2.53.0



