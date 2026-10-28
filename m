Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213132;
	b=M+oF+zONXlsJptW/wvxDZa6lSvw9bhIBQhheHAOqP99CKj0Q6oAAR8tlYTLXoURB4Hmv
	 eqEp81k1zTm21J0q1xcdpepYLqgI75D1eNsgQLZsLW99AcOFS8hdXEtNLccbnUk0/AoKe
	 g/r0s8BARJZcWxXKFM3C0MEm82+JR129cWuDJUXztB1+6VhXDHOZpZ6btVB8M7Cf2W6FF
	 uxYItWvuW6KWI8Sme4C3FyNiqawzr85++HJO0HtVmRgKXDh0SBE5FPnZQyUCXnz8KvwDw
	 uNX+LsQcqO8rK54nNglFPHEXxYhQWN+t5ng4b8i3TYga2++BVonCoBatAtZqLkcOcNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/gy3tmUwpPJNojRozQc7I9/W/o1TWSbnqqkBYx0dDaI=;
	b=IaJKHj0zxy+sOM/kG74+tY7Wt4KPfIwKNlASzJFU2w5ILCNHzyzkAlsheSbzZ3kqAx7t
	 tw76QaYYucUxuIhLrY74ghO/vljzCZh1pRobl2m3Pc9Mk/bXNUMGelJ0TvrbUZjBS5Q27
	 iwb4LL7DbDM2lO7HYaOJ/CE+pT9x3IUFJf41x8H9N+dgUIeLQB1fs53gDXLkKm7CZUxZf
	 Hco1YC4hDYTD1Qrd+X/nRr1PT3W687LSfmK9yN1fqSCR1sklUImH7THp9d76erRe9MGeF
	 ixRZIbYoCXJQmd88E1O4Xo7476G8QlDq4YwUl8zCABeDyfWgQ6jW1j3nfwZI1E5Ectw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rKPjmEn/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F216606A31A;
	Wed, 28 Oct 2026 18:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKPjmEn/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDD11F01825;
	Wed, 28 Oct 2026 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213132;
	bh=/gy3tmUwpPJNojRozQc7I9/W/o1TWSbnqqkBYx0dDaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKPjmEn/ycoqO/X8Q9HTeX13nKKn3253TW7LhdAEGvmiZkitDe+4vD0MxYOyBSU/R
	 B+NIhobVCNuDDEet75Bk2bWaU1iCrJqlys8jh3CS4s2zT+8ls0aK0aCSHQfGZGNWjB
	 AU5JobTkzYnQT1muIv6jx9iMaExACamVWNtgM7wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com,
	=?UTF-8?q?J=C3=B6rn=20Engel?= <joern@barelysecure.org>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0399/1887] mtd: block2mtd: Fix divide error when erase_size is zero
Date: Wed, 28 Oct 2026 17:41:35 +0100
Message-ID: <20261028170508.313115302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the upstream local size variable with the existing direct dev->blkdev->bd_inode->i_size expression. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/block2mtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 4cd37ec45762b..9175196110c6d 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -272,7 +272,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 		goto err_free_block2mtd;
 	}
 
-	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
+	if (!erase_size || (long)dev->blkdev->bd_inode->i_size % erase_size) {
 		pr_err("erasesize must be a divisor of device size\n");
 		goto err_free_block2mtd;
 	}
-- 
2.53.0



