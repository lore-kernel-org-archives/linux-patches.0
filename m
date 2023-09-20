Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B5828E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB186C433C8;
	Wed, 20 Sep 2023 11:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210787;
	bh=78KAu7mmakuSowL/a/lViX+WtEXHI9v8c27S/Wdlqmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/gS4Jfeggh6iCx0hdivgalkMrr7k2oSZYN4TpX5pl4XnBL/JqvmTBFH8uA9C8SLE
	 qYSb5xyrXRbBaXr8KM5KSs+3Yx7NOqlWDyZh0IM8NIg7T91z1O4Yq9fXOWNqPRtTpG
	 96tIrtuH0QL7uQn91v/C6BqrLPeLVCQfAdTg0MJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 204/211] drm/amdkfd: Insert missing TLB flush on GFX10 and later
Date: Wed, 20 Sep 2023 13:30:48 +0200
Message-ID: <20230920112852.191893915@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit edcfe22985d09ee8e2346c9217f5a52ab150099f upstream.

Heavy-weight TLB flush is required after unmap on all GPUs for
correctness and security.

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1487,8 +1487,7 @@ void kfd_flush_tlb(struct kfd_process_de
 
 static inline bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev)
 {
-	return KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 3) ||
-	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 2) ||
+	return KFD_GC_VERSION(dev) > IP_VERSION(9, 4, 2) ||
 	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) && dev->sdma_fw_version >= 18) ||
 	       KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 0);
 }


