Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A565F26B098;
	Thu, 13 Feb 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460658; cv=none; b=AnvzFmzUmz9q5WoF4Jwj8qGOJcSwm4V/DPnseBZPf8ByWpzyBTfqwvXObH8UACq5H75AoRJ50DFqvfpQa3BYJPBkwGzf9B9zoeyRw36sMy9sszd5Ndjs8lKqSjq0auGW6l2VHzibU8VqKMk4ie0Zrgq/xmt7oRRR8vsbovLCDoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460658; c=relaxed/simple;
	bh=GaCxtvSH+w9xO2IJ5wzmYaB96R6D9wMvjQ0cttltbYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1kMn+UgQu/UaIBeJDiaSRDW66Er9mUDGIv2QiOEoKX+Xg3lq8WTQDTJKlCMQlg+9ncyol2I1mORzw85s3mVtnCfPTCX0m/iGhjSn5vAb6YhDWkwivDuzrP6ofh5FVtm2+tFAAnBIUnFGC4EwdyP6x0P2sV7ISLOnf4P26GerJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zG8UzY/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zG8UzY/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0A1C4CEE4;
	Thu, 13 Feb 2025 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460658;
	bh=GaCxtvSH+w9xO2IJ5wzmYaB96R6D9wMvjQ0cttltbYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG8UzY/ZPp9aTtzEKv/cj6d0ga+WVk0hq5ZEoP/I48rHn3XH6UsI5r6/7nNnYfwFX
	 OheDsSE2FtNQBZjvqgCLvPHXi89hE1oCY50L0TAYjBMHdtSl8SAd/xx/pIVAPHeddA
	 rrQJw7anKooKjp93lz8HyKB1+vvjMaWRzam48q14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.6 169/273] ubi: Add a check for ubi_num
Date: Thu, 13 Feb 2025 15:29:01 +0100
Message-ID: <20250213142414.008660061@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1462,7 +1462,7 @@ static int ubi_mtd_param_parse(const cha
 	if (token) {
 		int err = kstrtoint(token, 10, &p->ubi_num);
 
-		if (err) {
+		if (err || p->ubi_num < UBI_DEV_NUM_AUTO) {
 			pr_err("UBI error: bad value for ubi_num parameter: %s\n",
 			       token);
 			return -EINVAL;


