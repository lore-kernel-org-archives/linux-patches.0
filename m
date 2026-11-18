Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048924;
	b=FoL4mYCKqH9IAj56VUAu2I3ly0Ida0IFNpZd+ViRQArSb+Bwaw4Y/wbxFkXsY0XRU9RI
	 4SIZO1CkUVkbJQcJEp992pFkN7lIdNeKwnJ1ZCB3UXn2IrYP+Crf7BU1z07cgmTzZXhQJ
	 4KAQkRASxXy1mamPBsdLgllaHusF343vWogAWL3MB/rwMGfCXu7POYO+4OUwoV9uhBuVI
	 /MdmByD2Vy1EC0M07t3qh3ytoiY6eEyKP+r+BM/MBTJRq21haXea5JZacLVsZ5OOCLcWz
	 pF8VNFdvs65KUDL3z7DxbAmVCwxxKfOvSkCfR5MUzKvtQAjbd9WhszAr3EZLloQR40w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QMik1wVvKXDjReX2Rr1+6Te6HqeYaVSWoYM58F+43NA=;
	b=3IPoF/Rxq2tFTb6D8ALYfM4VF5jjdW5T0dtl1rzfJUT0HBltErOXVXg+fZgpLoDrlJ3e
	 2vyoQP/QW/8uei+RLr+aMS08DOV4Jmib66gRUZgXWsYzt4ZJlr5uORbFVLWBGF6vdbSn0
	 xh57T9Bf043Nbi++bBzTuAAobGZJZt3l7YNjFbIUH2MOOC7F2+rBq/7cq5GYQndx75Xq0
	 i9jKIMcWV62F5Kjcos6CJUOLAyo+NNNANLzNqUmV4rYqq0Nrr2qGHQZmRKk0VcPIHPaBr
	 nVs9cNAxKUO8zxnCZQ996Kzn+UX18VDUPKa1zdy9J1sxUeAkfHvDIepQQaVacQNN/FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuruiYTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E5606A320;
	Thu, 19 Nov 2026 00:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UuruiYTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DB11F000C4;
	Thu, 19 Nov 2026 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048924;
	bh=QMik1wVvKXDjReX2Rr1+6Te6HqeYaVSWoYM58F+43NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuruiYTxAo21NL62083SCWfOGoK4btsquEyFm+MJDlfahaiB3wZ/77xf3uLGJbDFu
	 X6fBc0j5y1A19mIysi5mYHIbGHCEfzAFpyXEMiAb1DD3CYcVby0OhtAlDC74FS+Ph3
	 xbV1wDakJWvadpaGN44bWZeh84yfpbMFfuM/fOIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2118/2857] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:52:32 +0100
Message-ID: <20261118150317.664847356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



