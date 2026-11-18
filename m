Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055513;
	b=GQAI9a57V3hTKgUEaS3tZpWWBnp/GkyXdXX0+mgMuZ6mE6kNfvMwCoNJTvIWg9cx5YcV
	 xDn1kQZF5q+69Bfc2GCS5r9wWMno8S0z9DoBTG+BzZ/LF97NjvZtTI8fgKDN9JMA8ZEOj
	 fEF8XhYvMDFbizOiC04iR/l1BDGOJL+G+JL1NsztugSYUCoCeInWqYBPvSPU8ji6WT3rr
	 tSREf7ad7Baq+WWZVlZms53pMak9b6xl/NL7mg3fXHn2twrAM8Df0UN6MwfO+RWgKXhMv
	 gyacas5O6Jg4kaS6MlGIqpX/5mzO5LcpzDlCONqrTLJNUl1TvvF04JxRvS+E+Jw10dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ICzGht8g+TxPhZCtGGe8TkZCei2Z0dJoY9ojQFoR9s=;
	b=Be/vo3jnJYJQC56ZJZQKlN6zSjLbFSEqTbOMgRxMouEtrIYNTQmOLL+YQkXicy3f+p9I
	 gyUnb2dsAP7+7l3tVtuqbvzHccJRGpDcWWiki9ltiS+L0PClkhZMUhGWM9icFK5kdXFQj
	 ZvFtAMfKz8T3pCZUhopd1J808auA/OaJiGfWrafvmc6a0extxWlUkQ+ejT4WdyO2ebmoM
	 +qgMjks9u3c0dsH945Rto+rZgrdHlqNy9Qbl5/yVsSFvj0CDdc4fQgPDbKaZEGRewZMTp
	 DmXg99CuSQjSe/4L/i7XyZEeraZCWF4JqJHSEJHT6BW33m3P/3xYgCXXFkh5FXVBPRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AI0MNct5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03179606A31C;
	Thu, 19 Nov 2026 02:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AI0MNct5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517081F000C4;
	Thu, 19 Nov 2026 02:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055512;
	bh=6ICzGht8g+TxPhZCtGGe8TkZCei2Z0dJoY9ojQFoR9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AI0MNct58FpUxU7/WE/zlndTgZ9ZvWKWUT05ZxJCqtPITXDLNjyPtwZ4foUjU7Wln
	 0dAVVXmpBvTENtjf5KOLLsIqFblvWGz8YXdO6HU3Vkvd9iwgHDU5i9jmugN83Q45Nu
	 8Mw9JrakUwZjt/aXEEgYUnHHqPGTecXMPrUzI/WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1658/2214] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150118.206192120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



