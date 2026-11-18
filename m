Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048786;
	b=ZTMW0gOLiTy1wmFj584FKbKTETHXAcJYaQlFuSksi0CgLrAbMTFLYKmux3dExbW0Qf2g
	 1RiHnaxuB4Pa3hbmooELljygyj9H4jb73EsykfacjnldM45YNwPI8E9QbgusdIqDcDaYT
	 MxeCdGV/q5/IEVUwQNfAgjaCLzVn3aV+QlOk7J06TZbWGxwOCijm8SzqzzuBXo3wfzVUk
	 caRy/48OoxEToJq2z9+tetFJe3rYFZsgsoQKgpjkN73mAtqq/1oVZ9xMXbrfWaBMPDipL
	 m2AW3CIVfzdO7L2azXvYpm4AwJfplByKYOu8jr/zsUpqZ15U4+C5TBDxB/Hp60CmQ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4da7gSkqzwCO3W/W5+2Qw7IPBxQ4GTGzzf0DkGkCsmg=;
	b=DWez904q6b5KOKhLzFeJPh4ILbUeywyZn/1yHs4YqWZQqngtPOUqzhxvldNAziXLjV1u
	 GqLYT/lsBLteij838QmRSZ+ik/VO5ciPD0zGYv2dywW+k33pLamQbHneQkU+oHnGQ2cfM
	 nsn9xK8e9MPem4M11yHtspRHrh4NfWPVagNg7lbsHY9/kimbZmNa3AZS+A6Iq0qiG9RHn
	 LVchdfWu4tgwMl7Zw29E6vqflfzDHiJA0Td+DpsSBGKlZc5pE+AGD8wdrEOfyo53zA6ze
	 xkhSanFvZbmxs1q0P3+xqbvYQJD6RETQ501PuPJxACTu+EZUQPD7PEjJpFyMPofEtuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEf3XQLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C22606A31C;
	Thu, 19 Nov 2026 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEf3XQLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB05E1F000C4;
	Thu, 19 Nov 2026 00:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048786;
	bh=4da7gSkqzwCO3W/W5+2Qw7IPBxQ4GTGzzf0DkGkCsmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEf3XQLz401QhTM71fKjkoh/EyQW3puVFQ+9ZSFssHksT/+ZrPm5utR/kjvMJvN7z
	 YUqsnRm/6MHfPNUsamlJ32NDwqMAchO1sHKn6moFsJN5pcsyVPsN4ixmZz7PrtW+bD
	 ULUjZMaoG4cw29cyn9SECt+tNbeo4ZYToNv/zClM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2117/2857] soc: ti: k3-ringacc: Correct ring API kernel-doc
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150317.629880136@linuxfoundation.org>
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

[ Upstream commit 45ea6911ad16859d4ce4f25780b0ebcf5660e43a ]

The ring accelerator header labels k3_ring_cfg as an enum, uses
propname instead of property, and gives the DMA reset helper the
ordinary reset helper's name. The DMA reset comment also omits occ,
including the convention that zero requests a hardware occupancy read.

The proxy flag is parsed as a separate parameter, and the pop helpers
describe pushing elements. Proxy access is supported in Message mode;
the listed Credentials and Queue modes are not implemented. The phandle
lookup returns encoded error pointers rather than integer error values.

Match the declarations and document these argument and operation roles.

Fixes: 3277e8aa2504 ("soc: ti: k3: add navss ringacc driver")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260923061658.20140-1-kmehltretter@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/ti/k3-ringacc.h | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/soc/ti/k3-ringacc.h b/include/linux/soc/ti/k3-ringacc.h
index 39b022b925986..2de6031b94241 100644
--- a/include/linux/soc/ti/k3-ringacc.h
+++ b/include/linux/soc/ti/k3-ringacc.h
@@ -57,13 +57,13 @@ struct k3_ringacc;
 struct k3_ring;
 
 /**
- * enum k3_ring_cfg - RA ring configuration structure
+ * struct k3_ring_cfg - RA ring configuration structure
  *
  * @size: Ring size, number of elements
  * @elm_size: Ring element size
  * @mode: Ring operational mode
  * @flags: Ring configuration flags. Possible values:
- *	 @K3_RINGACC_RING_SHARED: when set allows to request the same ring
+ *	 %K3_RINGACC_RING_SHARED: when set allows to request the same ring
  *	 few times. It's usable when the same ring is used as Free Host PD ring
  *	 for different flows, for example.
  *	 Note: Locking should be done by consumer if required
@@ -88,11 +88,10 @@ struct k3_ring_cfg {
 /**
  * of_k3_ringacc_get_by_phandle - find a RA by phandle property
  * @np: device node
- * @propname: property name containing phandle on RA node
+ * @property: property name containing phandle on RA node
  *
- * Returns pointer on the RA - struct k3_ringacc
- * or -ENODEV if not found,
- * or -EPROBE_DEFER if not yet registered
+ * Return: Pointer to the RA, or ERR_PTR(-ENODEV) if the phandle cannot
+ * be resolved, or ERR_PTR(-EPROBE_DEFER) if the RA is not yet registered.
  */
 struct k3_ringacc *of_k3_ringacc_get_by_phandle(struct device_node *np,
 						const char *property);
@@ -103,10 +102,8 @@ struct k3_ringacc *of_k3_ringacc_get_by_phandle(struct device_node *np,
  * k3_ringacc_request_ring - request ring from ringacc
  * @ringacc: pointer on ringacc
  * @id: ring id or K3_RINGACC_RING_ID_ANY for any general purpose ring
- * @flags:
- *	@K3_RINGACC_RING_USE_PROXY: if set - proxy will be allocated and
- *		used to access ring memory. Sopported only for rings in
- *		Message/Credentials/Queue mode.
+ * @flags: Set %K3_RINGACC_RING_USE_PROXY to allocate a proxy for
+ *	accessing ring memory in Message mode.
  *
  * Returns pointer on the Ring - struct k3_ring
  * or NULL in case of failure.
@@ -126,8 +123,9 @@ int k3_ringacc_request_rings_pair(struct k3_ringacc *ringacc,
  */
 void k3_ringacc_ring_reset(struct k3_ring *ring);
 /**
- * k3_ringacc_ring_reset - ring reset for DMA rings
+ * k3_ringacc_ring_reset_dma - ring reset for DMA rings
  * @ring: pointer on Ring
+ * @occ: occupancy used by the DMA reset quirk, or zero to read it from hardware
  *
  * Resets ring internal state ((hw)occ, (hw)idx). Should be used for rings
  * which are read by K3 UDMA, like TX or Free Host PD rings.
@@ -217,8 +215,8 @@ int k3_ringacc_ring_push(struct k3_ring *ring, void *elem);
  * @ring: pointer on ring
  * @elem: pointer on ring element buffer
  *
- * Push one ring element from the ring head. Size of the ring element is
- * determined by ring configuration &struct k3_ring_cfg elm_size..
+ * Pop one ring element from the ring head. Size of the ring element is
+ * determined by ring configuration &struct k3_ring_cfg elm_size.
  *
  * Returns 0 on success, errno otherwise.
  */
@@ -242,7 +240,7 @@ int k3_ringacc_ring_push_head(struct k3_ring *ring, void *elem);
  * @ring: pointer on ring
  * @elem: pointer on ring element buffer
  *
- * Push one ring element from the ring tail. Size of the ring element is
+ * Pop one ring element from the ring tail. Size of the ring element is
  * determined by ring configuration &struct k3_ring_cfg elm_size.
  *
  * Returns 0 on success, errno otherwise.
-- 
2.53.0



