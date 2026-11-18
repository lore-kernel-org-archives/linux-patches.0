Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031549;
	b=yHgen52R2W7Tz828JR3kmWE369QZmfspfjiKhJQQy5WdhOsirUr8KseVmHn2Cwjq3PYU
	 F8+NL8+SdcUwrCQT16m1gXrvksjUn3omnHQgLqbaUOPD73dotKKdxUFgjbw4nvm7tkayf
	 3TI0jelGyswZu7iIN3tBnSedqFoT6jeiYEeWUm3GAhXGlJ8htFHy8M1o59yVRVb80l37L
	 etXfuePerjoFyC4Pd77ZOBJ1fgSEap8VBLeRrEWYrNExSj/0Z4qSAVy1sB14n3L8ffYor
	 9zXNELl75ZkssdBjmEq6LffaRz+E9v9HC5J1ZDmoPsO7R6yHofdBD8+Wyto3AmT9/Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jaPFf1Du9BR4k+5+84LHrRk82FP/eXqbdNkB9FXS1Xk=;
	b=nQjDufigymgp39JTwtA2o2WO1iwXIdqXB7p+ryL/Na9u9+QAMe9uveWkzpEU6Ju/NVts
	 4ZelAS7IQhl2sxKzDhfDyeUSWusJj4diooBeCWoJezrqzI3yzZFZvWaLGmTUiYFlDke42
	 RgO6Z/Q4ED/7ZEf9n3jGHy2nE7O+QbYkn8aP24DDjd22ZhF8rx9iabGcbOwEVqywog6ro
	 ZMgJ8tuT7gKVz4xC1R0PWxcmEWIQDiBL+ZNo2mCFVDp9m2D3qhtgfnGIfPwaiBTE1Qt4E
	 75KGIoOzMVXgMLXt9rIJkWm5xrJihwJhtuZ4AIwkMFjkQ/a4afDNJBN/La4PyTE/jug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMisgE6O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D826606A325;
	Wed, 18 Nov 2026 19:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMisgE6O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BFF1F000C4;
	Wed, 18 Nov 2026 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031549;
	bh=jaPFf1Du9BR4k+5+84LHrRk82FP/eXqbdNkB9FXS1Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMisgE6O8TBW+6DlOhkwDIbmoyF8/Pu+W6ctCF+TigZFw6TyxFjF3K8NjVlVHNe2+
	 w2Q7M1SAVvAhKz0OfMme6lacUbXQoemRXXohsOn/t+GQW92H564WjOkYCiCZyhXSeX
	 WSmCi1g2jCGJOOteeQCpdWb7QrzqORbUETp0oZS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1096/1756] platform/olpc: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:53:43 +0100
Message-ID: <20261118150053.844453164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1fe88b1741ff655bb59e4fd78178fe2c557b9185 ]

ec_dbgfs_cmd_write() copies user input into a zero-initialized stack
buffer and passes it to sscanf(). A write that overwrites the entire
buffer leaves no terminator, so the subsequent parsing can read beyond
the buffer.

Limit the copy to leave room for the trailing NUL.

Fixes: 6cca83d498bd ("Platform: OLPC: move debugfs support from x86 EC driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926121250.3258285-2-yaojiale02@163.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 48e9861bb571f..c264c9b888f94 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -269,7 +269,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 
 	mutex_lock(&ec_dbgfs_lock);
 
-	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf) - 1, ppos, buf, size);
 
 	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
 			&ec_dbgfs_resp_bytes, &ec_cmd_int[1], &ec_cmd_int[2],
-- 
2.53.0



