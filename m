Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024756;
	b=OmwzxYN2K5HZBbMnR5izoPO62skQi3JkSqFiAx3vtkx83WLd3zbNPIVmxjP1b2zkkHRj
	 w3CQXFWTKsE/loQnnGgprIG3+oIG7tKZyzqVaSOXjBmmK0C9nrlQmjVse9gr116dQyAKe
	 lKHZbbMzPOMZqTfNTzUBQAK3q7S+hN1hdQxWFXQbIt9+oV/gUR9H0aF37o1bScOvMA4+J
	 dIf5Ayfx8+DM0mdStnua2PTwLDguKsVmnxzg5YiJqgb5+xN/f/rGrPhJMlgFm0kGnaqOD
	 B6AVxs0WTA+YaB2yr7QbIFsZquPA/n2VmcPlYxgfW+LjnRhlp2cLE4ef/QUVC1y2sEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pMo3zoALKagiDn5A/HdmypTu/vwubkcmMeVFWtUGtrY=;
	b=VIwg/UjR63pDr7QOsB2sTNtdTMz5+h8MFjWZeTXdT3uNuJt+iLoWyfvnF8bl5FP67qyu
	 1auMGAmdMNBwyatT+/xvfJ/EmjrOn5mZCNpMt4jlltdC91j4JnIUXH5aqrxti0ZLXzvjt
	 OeXbPG2E5kYxUsALp6p7OM0CymRESUbZ3+lk2t/WHvZ4x4uvMujnDnaq/6e5H9uQo4oMA
	 cYEi8EoCbwpcLdx5lQzlNNCpK7Pg1pQxCjzX/o5BdP0psZ0HsuT+wZ6bdHYDascedWC/d
	 64A533aVF8DxU5b1E60iVyZuN0PN/IGnbcGKTmjWdFrWfWWnq+LRHewN6GHBawQil1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEOORb2J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ADD606A32F;
	Wed, 18 Nov 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEOORb2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A21F000C4;
	Wed, 18 Nov 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024755;
	bh=pMo3zoALKagiDn5A/HdmypTu/vwubkcmMeVFWtUGtrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEOORb2JjALhGTnOfT1SA0MQqcNtuxcODABWtPqHYRck20rbB8AzNpxyyp/LPRM3U
	 ovnL7+gNedRdhrh2zIVjeXn55sHK3sz0+e4btMXWTlA+ERq1TAnKuf5U3NIMTvzFM8
	 HIzwQaqbJ17MerEMEnEj+7LYxsXj+GAZfIhtf/kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0839/2151] soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc
Date: Wed, 18 Nov 2026 15:42:54 +0100
Message-ID: <20261118150152.772614661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



