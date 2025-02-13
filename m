Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D673526B098;
	Thu, 13 Feb 2025 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459534; cv=none; b=bnZwvtG23Fki1PkxPQ6ufwzIM74xRzBE4OL5mcAeEG5QBKPgu5b6jnlK8DjmHJEN2OOHLQgHxQNoiwZsW3w0WCrN4KOdw1WcNWJVqhhuTT8K4+tS8orcfdbETmU1EfOpf/NP7lPZkrU9nudeEdYDxbCFnTSOl72+zMo8c9/nIII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459534; c=relaxed/simple;
	bh=tMMxOekovSeU5PaUYbphi8WyD7+Tp5WAHUV0sJmJh5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa3DtLztSrtu/R/2sA81n9lfZXTHO0ovxKY5YffEktIRs9/79gQF07AUqf5mQvDMYLh8fhaTc/yHFXF6EH1B0RQ4891605yjCNUIUEaTtZcKIbQiSFeXoIN3u/X8GF8+I8cvqC9hOWL24NcAXrUqvMQyO4Iv0Jv4xCY2iwGPj1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww+fyb93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww+fyb93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470D6C4CED1;
	Thu, 13 Feb 2025 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459534;
	bh=tMMxOekovSeU5PaUYbphi8WyD7+Tp5WAHUV0sJmJh5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ww+fyb93+q5Uxl3/xMQ0yt0vlQedvsxnzk37SdQM+kpszFurT1gcVJdtZ8O+m6LF7
	 i/wnhfyflZgD9eYQEFQGKhIjXKRksrbVC/mjNxGRnUo0q6pysMbiWNMmkL/k050ImU
	 +oMwhAzeZESfYi8s9fLg9atjBVUEtC4OJF+Rqijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.13 293/443] ubi: Add a check for ubi_num
Date: Thu, 13 Feb 2025 15:27:38 +0100
Message-ID: <20250213142451.922062598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


