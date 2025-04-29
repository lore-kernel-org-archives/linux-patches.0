Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA332B2DA;
	Tue, 29 Apr 2025 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949206; cv=none; b=sf5rDfqqXBsAV+F6NWBA626OxVVdKmVmmafNOztX4g1s0I/Ej6QNybhUwV8Kl9dp/4T8isZp1D0fiZ/ABCZAIAJjAotXnCWHjR8lTBrzQ75frHXIbMgfGjHnOeBExQFGGhyqwsXBeP0Kd2SM/leResAEAi+bhBzN6D2hMuRfc0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949206; c=relaxed/simple;
	bh=YD8QE4jOl3opLJn0LVtjay7vPBPjLHjFdlD0yvubQSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI4SzdnAoQNi7Z866VxOxdgKjAoCIH4y76wIaWT3cfqLmhOLMGN5bvb9Ztzmi9iCJg8e1vucPSgBKdnsIDui222ifBc4XCFiQgDvKbIcu6YxSY1UzXFOqrtp8LHW5iGBss+/Z8bnuw79TE0e5tAmbwA0C2NAcCJJPbuQ4Vv9i1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAh6hHoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAh6hHoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA90C4CEE3;
	Tue, 29 Apr 2025 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949206;
	bh=YD8QE4jOl3opLJn0LVtjay7vPBPjLHjFdlD0yvubQSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAh6hHoPi0fZ+5JHP8zZM/Hd465UsWrwJyPhs1Xpj59wVfqZJeESgO+nY2eHDaPdC
	 3zAv4zgBkcJewmKvMVx2Dp8O6lYDVsJN2SrMOG/ezBqRIIvUwFTMOGnXWpax/EP6mg
	 AQ94Y1YVhO8Bj5lQsnLkOa8Rorj2acDQMRauJBqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 218/373] nvmet-fc: Remove unused functions
Date: Tue, 29 Apr 2025 18:41:35 +0200
Message-ID: <20250429161132.123443886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


