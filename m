Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53F3279345;
	Wed, 23 Apr 2025 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422319; cv=none; b=OvbAkwzAekmJW8dG7gUcVHoTS/sN5zg11DWm9nEwxGX3QeKfafCpKO4cSn3Q74OXnPqA8CZyZiMT4AIzO98GvdwYhX+irCFtHmryNUZ2Uo5L/xCnatIJ+tbKzoyNdKVppT85z4ulGC9GaoMGS+HdGiaL2qXaLngN6mohqfRAK/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422319; c=relaxed/simple;
	bh=r+K/aRIOvf1YpC8iX1/l3Dnmx4A8TxWlSjftD/p6598=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WogvGB7OHXQ2+eo3IT+O3q4R/rMmoRh7L6UEcBfsV/eA5kFLrjMcoGdmQrOhMraG04ccWjP70zOwTgIrnIvxAXbSs5FfWOuTGivcF3aB0AeOON6+ovbR3CSW4ArRu4xfQDXSJZkxiYheqPB08XaKTLpc7YsigiTbN+PK4VWeCD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC1xNhfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC1xNhfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6536DC4CEE2;
	Wed, 23 Apr 2025 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422319;
	bh=r+K/aRIOvf1YpC8iX1/l3Dnmx4A8TxWlSjftD/p6598=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC1xNhfENkTdEBBfhYS9xpe+xVdOzjhhbWcirrATm0FgpfrtAhK3kUwk0WRK4jBo4
	 xnM3115hhW9l73cM84Mb7IuPWABXorj5Jvwx1GX9ts6m+lL40sSEw9S+l5lPquQ+C8
	 9Z1T6jQ3Tbm6WSzIoTWeObG4p66NjRMbLqk5tYMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 276/291] nvmet-fc: Remove unused functions
Date: Wed, 23 Apr 2025 16:44:25 +0200
Message-ID: <20250423142635.707619635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 1b304c006b0fb4f0517a8c4ba8c46e88f48a069c upstream.

The functions nvmet_fc_iodnum() and nvmet_fc_fodnum() are currently
unutilized.

Following commit c53432030d86 ("nvme-fabrics: Add target support for FC
transport"), which introduced these two functions, they have not been
used at all in practice.

Remove them to resolve the compiler warnings.

Fix follow errors with clang-19 when W=1e:
  drivers/nvme/target/fc.c:177:1: error: unused function 'nvmet_fc_iodnum' [-Werror,-Wunused-function]
    177 | nvmet_fc_iodnum(struct nvmet_fc_ls_iod *iodptr)
        | ^~~~~~~~~~~~~~~
  drivers/nvme/target/fc.c:183:1: error: unused function 'nvmet_fc_fodnum' [-Werror,-Wunused-function]
    183 | nvmet_fc_fodnum(struct nvmet_fc_fcp_iod *fodptr)
        | ^~~~~~~~~~~~~~~
  2 errors generated.
  make[8]: *** [scripts/Makefile.build:207: drivers/nvme/target/fc.o] Error 1
  make[7]: *** [scripts/Makefile.build:465: drivers/nvme/target] Error 2
  make[6]: *** [scripts/Makefile.build:465: drivers/nvme] Error 2
  make[6]: *** Waiting for unfinished jobs....

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fc.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -173,20 +173,6 @@ struct nvmet_fc_tgt_assoc {
 	struct rcu_head			rcu;
 };
 
-
-static inline int
-nvmet_fc_iodnum(struct nvmet_fc_ls_iod *iodptr)
-{
-	return (iodptr - iodptr->tgtport->iod);
-}
-
-static inline int
-nvmet_fc_fodnum(struct nvmet_fc_fcp_iod *fodptr)
-{
-	return (fodptr - fodptr->queue->fod);
-}
-
-
 /*
  * Association and Connection IDs:
  *


