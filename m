Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211413;
	b=z5zuht++/WS1yDRWJlbnk/6bBh5Th2R+2jpqJMJQ0GLFnue8eCC8hR9gdOnuw+wPZSlx
	 ITboFAHnN4uqZK3DorZjFrs4IZXCRzeRvJb447QtSHnwlttITzotvqQ5r5B03q4Q6y8T6
	 gJHRXlvhCDfMAWoSb/ynMfaqjrXK8iOMwJGHgE4EDDH5lQPEhQvzj/JOmL2iNHKx8gmst
	 uUovgQIrU6XA69UyVF8Oz/olAlO/bpwtMPj4BUNiMwW4vrnckO9HHNH3qofGSa010HStn
	 hDH2xMx4npIzVbVEpbPtP+j4pVDQmcT3TP0vHa4NhHIu/3tmMHTPtfj52ah/1bjs1kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ualmab7h67fCS954UpAY6pNKBpqsrPiXaTC/Kc/jLIk=;
	b=ZlvbqTJ7r9mUgPm25bk6Q7ioSomEvTnfFeLxzZXlRX/MxDI+pGf/pE9AU680DOwF6q5D
	 iTbbfHuGcaje2RU/eiVe5LSLhteay5KP0KMBXqqrKO5Tf8RMrDBlZZGXFCtPlhzwiaxfO
	 m+Y6ClEuzB3F53b3oHv0ucM76r747tjkQHtC/XsITRFsrYg6Mxqnz7dKPMYOnmVAGVc5q
	 fwixfnM9443v/JTGV80pR6B8m+MRNOWa/nNsUNplAFp+VIA7ZxrU1a2jvSpsY78hJ2sYF
	 eW0jFWFigy0F9khUkUah3UxV3KyjniJlDHkey1ChRAg1iisE5C79HOAsWshxdKPhckA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AP0m0NRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585E7606A326;
	Wed, 28 Oct 2026 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AP0m0NRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D0C1F01825;
	Wed, 28 Oct 2026 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211413;
	bh=ualmab7h67fCS954UpAY6pNKBpqsrPiXaTC/Kc/jLIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AP0m0NRr0jLxfZxfTt9ZFhEBp4tfkXGwmb5sSOephu8h6eJOsQRMM2fYBQ1af4D4s
	 pwllv4d7pYFjJLIf0N9rCyjDXD60kQaCusxyoHWsUZkfZFHWXh0DmdU+rzO+ZkKHX6
	 HrJ0Oa2F8lMk7aenOObzhFNKPxi1BJNdtxVU9S7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com,
	=?UTF-8?q?J=C3=B6rn=20Engel?= <joern@barelysecure.org>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/571] mtd: block2mtd: Fix divide error when erase_size is zero
Date: Wed, 28 Oct 2026 17:57:50 +0100
Message-ID: <20261028170015.669145456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit b5965c4221165045e19736794ca5f48ae3d67142 ]

The erase size is parsed from the "block2mtd" module parameter and can
be set to zero. add_device() then evaluates

        if (size % erase_size)

with a zero divisor, which triggers a divide error:

divide error: 0000 [#1] PREEMPT SMP PTI
RIP: 0010:add_device drivers/mtd/devices/block2mtd.c:296 [inline]
RIP: 0010:block2mtd_setup2+0x592/0xda0 drivers/mtd/devices/block2mtd.c:459
Call Trace:
block2mtd_setup+0x27/0xe0 drivers/mtd/devices/block2mtd.c:476
param_attr_store+0x214/0x310 kernel/params.c:589
module_attr_store+0x65/0x90 kernel/params.c:904
kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
...

Reject a zero erase size before performing the modulo operation so the
existing "erasesize must be a divisor of device size" error path
reports the invalid argument and frees the device.

Fixes: ea6d833a3fdd ("mtd: block2mtd: check device size")
Reported-by: syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a7b58ba.ac361c09.22ff0a.0045.GAE@google.com/
Suggested-by: Jörn Engel <joern@barelysecure.org>
Cc: stable@vger.kernel.org
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: adapted the size variable check to direct dev->blkdev->bd_inode->i_size access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/block2mtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index c08721b11642b..58ec5d0525ec2 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -269,7 +269,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 		goto err_free_block2mtd;
 	}
 
-	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
+	if (!erase_size || (long)dev->blkdev->bd_inode->i_size % erase_size) {
 		pr_err("erasesize must be a divisor of device size\n");
 		goto err_free_block2mtd;
 	}
-- 
2.53.0



