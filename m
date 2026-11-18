Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040386;
	b=GFnyZeQOq+FHTTeAOCj4ZvqUojEVxfFK8l8i9Ra0YrX3KmZR6Oc8EGxuXkYAF40jVzan
	 sU18GgGFqFKxuLKgp+sNCtQ/Nmj5KdctkoqHCfEjTeNAMIpJr9Yrvj9tXTD3pZV+Mmxmt
	 42uCfqgbph9lwJ3nG5OfcBmT45//Ql0ZcUC1iz/qrNileISD1Z0QikvW7RZj8FEDS3aOE
	 EKR+NNbniDILrIZPaMaRIiIDMQdDvuDNYYehnwUQ3cmNfQz96mYrvaqrINKp6aLGZulT1
	 jBokbDFsWoCZh8WRz5jgLMbvxoKridlWzp0APH/KZTWzfOTketffElor6XFRq3B4+BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qKPfL+GOywVbFSHhDk46PnE/FoZrM3RTh2fV2vT5MHM=;
	b=j1k1tkXl0nwSBaaSFYgnAfPLu0kI9ovKEdGnXXv2Tp14jMNg0UmagVMdhWAtgrSyLAar
	 G1ypOLQtEdQdfE4O+/sEgF6wjF06jB8781O9xolc1pztdJ5drL6uvlz0odOkJz2AIogvv
	 wDnDAUd33rWEmp2g83Q3ZhhzcPPCfbE5t2f2OHbohznCrSk+IiMzSSFoLhk18KbVK7l9Q
	 WjwQYU3rUsOOU+rT9c2eF2evL0/R+QZ0Y4OjBf09OV/W4FrGehn2YSzn5ea9xRTIBVw4U
	 nyQwTMumg6BvMJvuSwoQcJLePUUeLOZiCO+7qrqeEHN3t125Dg7qQu26rjjWjZYaoTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nF2KBOa4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4D606A320;
	Wed, 18 Nov 2026 22:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nF2KBOa4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACCA1F000C5;
	Wed, 18 Nov 2026 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040385;
	bh=qKPfL+GOywVbFSHhDk46PnE/FoZrM3RTh2fV2vT5MHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nF2KBOa4TuWsjLsOkZ1hSpP7OUb+ATfyUtHm1YIlPHrCilobewYOrQBo7+RBDo0zj
	 UvLTPMBHVL05u1+2cLMLCpz2/AVCpAO8NY0A0KI20sd3Vw/2aiwUq9oasiGHyGwRDW
	 3qLsJN0w57zm/Mdgy16LrOc3VLxkkoV069P4dgvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2437/3318] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150434.562935245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6c4e6e8f5cf95f7e0d4f04928a9ae70e20c73d4b ]

The heading for k3_ringacc_init_data repeats struct, so kernel-doc
cannot match it to the declaration. Its three fields are also missing
descriptions.

Use the structure name and describe the firmware handle, device ID,
and total number of available rings used during DMA ring initialization.

Fixes: d782298c6f6b ("soc: ti: k3-ringacc: add AM64 DMA rings support.")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260923061658.20140-2-kmehltretter@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/ti/k3-ringacc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/soc/ti/k3-ringacc.h b/include/linux/soc/ti/k3-ringacc.h
index 2de6031b94241..7b7fc237c08f5 100644
--- a/include/linux/soc/ti/k3-ringacc.h
+++ b/include/linux/soc/ti/k3-ringacc.h
@@ -254,7 +254,10 @@ u32 k3_ringacc_get_tisci_dev_id(struct k3_ring *ring);
 struct ti_sci_handle;
 
 /**
- * struct struct k3_ringacc_init_data - Initialization data for DMA rings
+ * struct k3_ringacc_init_data - Initialization data for DMA rings
+ * @tisci: TI SCI firmware handle
+ * @tisci_dev_id: TI SCI device ID of the DMA controller
+ * @num_rings: Total number of available rings
  */
 struct k3_ringacc_init_data {
 	const struct ti_sci_handle *tisci;
-- 
2.53.0



