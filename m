Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC83168A3
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FDEC4339B;
	Mon, 12 Jun 2023 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565957;
	bh=uJAPNVl99DOIMx5QOSlOZnqy0kNtLNA+eKwZc4ilzxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbi5xy9EN96QY469B6/ljDgUPFyf5KoCZnWu3HQMb1T7swgXtxqTUtMBuVqlsFUug
	 V1CrhqQHbUv/FZI8IdEkn/jVYnZvCk/cgNfS+Ii3rYyXKybabPww7/vWkx4uob9l0j
	 jM2iPgP5UPgZLaoOPPvdq0Bji5+5GCF4CKobImwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 5.10 10/68] i40e: fix build warnings in i40e_alloc.h
Date: Mon, 12 Jun 2023 12:26:02 +0200
Message-ID: <20230612101658.901281338@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not upstream as it was fixed in a much larger api change in newer
kernels.

gcc-13 rightfully complains that enum is not the same as an int, so fix
up the function prototypes in i40e_alloc.h to be correct, solving a
bunch of build warnings.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_alloc.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
@@ -20,16 +20,11 @@ enum i40e_memory_type {
 };
 
 /* prototype for functions used for dynamic memory allocation */
-i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
-					    struct i40e_dma_mem *mem,
-					    enum i40e_memory_type type,
-					    u64 size, u32 alignment);
-i40e_status i40e_free_dma_mem(struct i40e_hw *hw,
-					struct i40e_dma_mem *mem);
-i40e_status i40e_allocate_virt_mem(struct i40e_hw *hw,
-					     struct i40e_virt_mem *mem,
-					     u32 size);
-i40e_status i40e_free_virt_mem(struct i40e_hw *hw,
-					 struct i40e_virt_mem *mem);
+int i40e_allocate_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem,
+			  enum i40e_memory_type type, u64 size, u32 alignment);
+int i40e_free_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem);
+int i40e_allocate_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem,
+			   u32 size);
+int i40e_free_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem);
 
 #endif /* _I40E_ALLOC_H_ */


