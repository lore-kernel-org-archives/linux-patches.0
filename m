Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621406;
	b=QZVXQsVQTBOaDFZL/4TjEQmURYcqcYpR4UlWlgGWjT9K0v7Nw0JF1lKaYpXaSabAcR9N
	 vJlgccK3Rt+hkk4JNlPwcxppEPd7gHWE6yf2qqqZsxl+hFjRwMfURTrb9PwVnQuFRc6PP
	 l1ArIXrWSczjqkbDjnXQqFGc9Rboqpn2x1VESn2/0k0EFtP/uTNQNmUFUv1/z6TtPbVzN
	 2XXg4BclBAzYJ2G6inKNR0lcf4YZztUGlMONJWSNykaNaFrhUyrvVE51IgZyD+UYYCOvb
	 hFcIyclJETUMD+i6IjIEB5mTbP2m1uaC8EMQQzZL2P287XvMGgFWz1GfEPcL2MF+3zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lZxgEu1WQBSPTeywWNRwGKNcXYhfwNZut47tsU4aBM=;
	b=i5/PVuNM/lJ/9ZhReo9IZFifRwFSjnVjp+eTrnLRDlPU2uJuRhHHvGP0oWXY/xWLm8gg
	 pjjrwRkpnF6Y7aF3AKNfWLRn0bCT36qoayIwCf2hKkIh8VpCzGL1MqVfGT0LJIe2evH46
	 fjswWyL2jTwjJ+YYdSU3r0Qj3OhUR0yrNCH1/KMyjjf5HCJcQKbOmHsQ5FNFjTDUyR5p4
	 w3MoEGymSb3f17Qs44RV9N6ffVWtAzu72AIC4/uvRdMUN7dxZNIO9j+S1RWKcoJxvf+dK
	 7EnzCyUsI1oF7xmcIwg4wQoGIn6dFy0LDAQrAB8xyge8P5Wh2cZFtxDHulpwLE4mDiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1eVeBoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BB1606A329;
	Wed, 25 Nov 2026 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1eVeBoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2DF1F000C6;
	Wed, 25 Nov 2026 15:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621405;
	bh=1lZxgEu1WQBSPTeywWNRwGKNcXYhfwNZut47tsU4aBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1eVeBoHjpONcH1KZvIYqumd1UaVV9Obz38Ewtyqo9q8I/fjX4ICixzAxT4d1ypGZ
	 IDCcVJ/NSTl4LUfkle6ER9r6FAOMY4llkHdOBYbDtP+YevWLkYzmQpkQKeqFGLD6vn
	 p9PEOg0UPdbnZcW8xrhjDvn6p4AuIDmogUJ+5To4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/990] block: partitions: reject GPT entries with starting_lba > ending_lba
Date: Wed, 25 Nov 2026 15:26:23 +0100
Message-ID: <20261125143827.148552267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7acba66eed481..d88321f6400ab 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -461,6 +461,7 @@ static inline int
 is_pte_valid(const gpt_entry *pte, const u64 lastlba)
 {
 	if ((!efi_guidcmp(pte->partition_type_guid, NULL_GUID)) ||
+	    le64_to_cpu(pte->starting_lba) > le64_to_cpu(pte->ending_lba) ||
 	    le64_to_cpu(pte->starting_lba) > lastlba         ||
 	    le64_to_cpu(pte->ending_lba)   > lastlba)
 		return 0;
-- 
2.53.0



