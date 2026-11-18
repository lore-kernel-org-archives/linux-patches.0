Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055510;
	b=V+PGGF5ytuW03SEStX1zkMbMeZl67GWGdKUgQgLuoXB90gn9TdptDLa+OMQOO3XoaNOH
	 6Nwkaim8Ag2UnENaSw66P7722ufN2pnofgzireH7h9SPssmV6Ws0FZlcmIoyzH5KU4nb6
	 a9oGJKkcUlzxnFRQ3tIYT9Hng69coHScYCOlhV4zhU9guEIEwI46OuRrwSBU5ZaAGFMNo
	 iz/cnU24g9CeHQ8vfkdxKEg1G++VTtWvtlzAe8uIGECl29sCK3ml05QK2KmEoglMVPjnL
	 PJX6ui1ndI4wYfYK0+F6acTZbQQz3j6gFlj4EKSZTz7FQUo1ZeqFd0GNOeqqE3yNbaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uc6NVZ7nk+UMfTHIkoeOeaU0xZouI89Ji0cVByvmzsg=;
	b=4fJiZrLeEPhlM+w9CGG0R4W2P4v8vc+oAD4APa1hTCNQX0279EIzzGppKp2heY9JlLyS
	 /6sMdA7emSMOWSQAdlI+hQ0kARaHWT2LEZdcQA8Jexecjr/Xwynx9j1rqhruGbZxvXXnl
	 8yAHXr83LXdfwQIEtRAvHAgofbMrY7rh+PIDM92b+92VmyUK9V4nvW4ncrWUy6w+FSj2f
	 R6UrpaBsaGxl2dVtkqx5zavYfDBLnTqr5xhcaq/PiQ/eFPAM8GSWKtNFLzWs2sJxy0Nhi
	 TujOprvONT56B/w3cIUVkmU2Wf1uSrBOCvXjxTJIlGvOLiRngbKoArGfwRDiK+VzNEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3oOHlAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B02C606A32C;
	Thu, 19 Nov 2026 02:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y3oOHlAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB6D1F000C4;
	Thu, 19 Nov 2026 02:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055510;
	bh=uc6NVZ7nk+UMfTHIkoeOeaU0xZouI89Ji0cVByvmzsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y3oOHlAIlkElvKvBUXOmtG/iJUZFiP0lS88TX43/5Wzu7/8UZM1qNe81Qud60ilNl
	 aQI/o6Lg1mDPsfRIViKgNmhe7OnUynPi3lLM19MRYc9skeR4NjY1wfRw6nLiJHhppA
	 yI9Asm541S2EbP41fJLjZmX8Q4vMmxXx8cOagmv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1657/2214] soc: ti: k3-ringacc: Correct ring API kernel-doc
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150118.169844253@linuxfoundation.org>
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



