Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704261;
	b=QAGzZoc1sNW7W9otQ6e7Eky95h2+2I1SDiYiSlRl+9zmAhJxwyghihMNbvE2uKiKcb/j
	 LaLXFWTkMnoLYafEW1WgJ1QLSvzS/v+nUGsHIpzKi5Vp0fhITDlAXv/5DpV3ZSBBIeL7U
	 pW2cO3BKNzjldWEjScfvhU7zV2+I+b5/YvJZFRRQXd4QjC94uDKckG07Yl2md1817Brck
	 tutO8xkRzdzG+wh+4MGozoXD0TtalMQ3KUcYTckBuvSNLQmZoRDwsL38IjSxPUuIyR7ZR
	 /bmoD45KmC0GiK0K3+hOexAT7lYxHMVNwjRgQtc3guHGCZxfK2jrXk0Rw4mUp4f2Qug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4rpiT3e5To7FpF1nmxwYBm9wNIAs/NnFo/d6ryE6LQk=;
	b=FnyjuQpg8hiU1ULctvlWZiHy8pds3dZSWNqH/uFODbxkBJpluWPiUXGRljew5MbpxQXx
	 Z+mOfPL0gxcL4+Lunh8sLz3N8wQc/lQFhQ6aynx1RPkgcJIrXcaBrqwAgwXTf8QpC17Z8
	 GbqXJVgizFJc3lGd4luCTCD1c122PPXWbM2g6EUA3dwVjOO8CNvFbcR0/3TbjN/wwP2Px
	 2dUfE0RndUITbZMMceYHj+rrl4ZMCOu0ja2doX24IZ04hmPrIfhdasICJ0wWo7bRI4hNi
	 rhVn/6p8oRNtnc5Zyk0QjpBBijy4F7OKIoyWqUwwsVnPwH+FHDgjZv86d2xh/M2yzZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKyU+vTE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61329606A321;
	Thu, 26 Nov 2026 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKyU+vTE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512BA1F000C4;
	Thu, 26 Nov 2026 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704260;
	bh=4rpiT3e5To7FpF1nmxwYBm9wNIAs/NnFo/d6ryE6LQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKyU+vTEu0vl+ZIkWUCR1ErpaXCwXgj7RBzP1E4WH48N/BYu9GlkZ4OMJ250mdaXZ
	 vpZh3guGwAgMrN7plN5t9QoAhMlzXXZ0yXrjxTIbRwhHcHnHftLobnyQbjJbHcspMr
	 1tG1UeAvzwVmk/ksc9YnfBI3KwJEDiB7wD2YihPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/265] block: partitions: reject GPT entries with starting_lba > ending_lba
Date: Thu, 26 Nov 2026 15:36:33 +0100
Message-ID: <20261126143609.489376607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 7e3801d12ebabaa3db6e2685ccc80b6e6f6d1ff7 ]

A GPT entry whose starting_lba is greater than its ending_lba is accepted,
and the kernel creates a partition with a bogus size. The bogus sector
count defeats the end-of-device check, so I/O through that partition is not
confined to it and can access sectors outside the partition on the same
disk.

is_pte_valid() only rejects an entry when its type is NULL or when
starting_lba or ending_lba is greater than lastlba; it never checks that
starting_lba <= ending_lba. For a reversed entry both field checks still
pass, but efi_partition() computes size = ending_lba - starting_lba + 1 in
u64, which underflows to a huge value. That value also wraps in the
end-of-device check in blk_add_partition() (from + size) and does not fit
the signed i_size, which turns negative.

Reject entries with starting_lba > ending_lba in is_pte_valid(), matching
the head-level check against last_usable_lba < first_usable_lba.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261102080442.3775061-1-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 2de016565ae55..64f98bbc4bd63 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -463,6 +463,7 @@ static inline int
 is_pte_valid(const gpt_entry *pte, const u64 lastlba)
 {
 	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
+	    le64_to_cpu(pte->starting_lba) > le64_to_cpu(pte->ending_lba) ||
 	    le64_to_cpu(pte->starting_lba) > lastlba         ||
 	    le64_to_cpu(pte->ending_lba)   > lastlba)
 		return 0;
-- 
2.53.0



