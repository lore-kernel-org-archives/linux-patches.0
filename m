Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C713D8A4;
	Thu, 13 Feb 2025 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458035; cv=none; b=ReILDjrD24LEYDn8s7GCXei0ISwGppVJrLW20CcRaLRujvAETnQd0B6OV8GjCnCtzPmG2efKC5LUg5fv+2GnloTEpyQtukLQx2u6Y/3Oq9IUcdU/Q+qDWdnlfRKggeLkS9FlP/mt46Tr/5c/tUUEnQtgs5mL5oog1IVVp5F+eeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458035; c=relaxed/simple;
	bh=y1z3XLTsJPjsQRRreAYi1ECW8Pr7A8fFVeBiJIuNRPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZCw9TMBiZuCZZVZbZLaaXT8djcy+Pf2ksY00pgNk+pg9lj6fTW7GDzbk3i/HDeGJ2MAqfe5AhdWv1K6fGXcToYWoyuTjR4+2xjbo9Hbw0luFy6IHcOILMXyg2feCVmlo0KS0NkqpRrq7SjzdDF/5E2FyoLLQmhOkK95Ne3gIig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bDbORWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bDbORWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65540C4CED1;
	Thu, 13 Feb 2025 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458034;
	bh=y1z3XLTsJPjsQRRreAYi1ECW8Pr7A8fFVeBiJIuNRPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bDbORWXCPPMfsfnFRfWyO/4puvuiluJG7mJPH5jOnSBvLdhs845nP0UFQtpmmSmM
	 L18u6N8M7L1HZX6FoAmvQiB4c5nBhRngWLmVvUJq9yMHatw9TIm0oyKr6VJq5teVA+
	 7gYeoos2QBd3C/WzX0FtjfQXY0H+YznIBg5ud41U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.12 265/422] ubi: Add a check for ubi_num
Date: Thu, 13 Feb 2025 15:26:54 +0100
Message-ID: <20250213142446.767490068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 97bbf9e312c3fbaf0baa56120238825d2eb23b8a upstream.

Added a check for ubi_num for negative numbers
If the variable ubi_num takes negative values then we get:

qemu-system-arm ... -append "ubi.mtd=0,0,0,-22222345" ...
[    0.745065]  ubi_attach_mtd_dev from ubi_init+0x178/0x218
[    0.745230]  ubi_init from do_one_initcall+0x70/0x1ac
[    0.745344]  do_one_initcall from kernel_init_freeable+0x198/0x224
[    0.745474]  kernel_init_freeable from kernel_init+0x18/0x134
[    0.745600]  kernel_init from ret_from_fork+0x14/0x28
[    0.745727] Exception stack(0x90015fb0 to 0x90015ff8)

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 83ff59a06663 ("UBI: support ubi_num on mtd.ubi command line")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/build.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1537,7 +1537,7 @@ static int ubi_mtd_param_parse(const cha
 	if (token) {
 		int err = kstrtoint(token, 10, &p->ubi_num);
 
-		if (err) {
+		if (err || p->ubi_num < UBI_DEV_NUM_AUTO) {
 			pr_err("UBI error: bad value for ubi_num parameter: %s\n",
 			       token);
 			return -EINVAL;


