Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214694;
	b=Gc48oHXWU3xdz0775fdVL4Xt5Ge+poXByONnyOcLFW1ZSwzliDtH9CmzysWAesZGRH+M
	 ZqlIAnuCkoNcyy98Chj9Mo2yknLVgWW80Fc6WOELAVRt2DJdiwZPCUiPLQ5Zjz9QB7EpH
	 BzG4Ha9CsUmrgx2wkQmD+/EFen5MXSZCIuFu6cio7MEsm23yza4rMrCNTHAzock5t9ER9
	 47J7djyUud8xv2Ucuo6VHIR+Kyf/Uv+wT5ajnn2BQy26kJ+3SeOiFNRUuyybHAjO+PQY9
	 9TMGl1jyaIDNEA3cOb0qUgoaQyupZGYO/lwxBaDJ372XgqlIZ4dtyy0kRmV/Av/Tg0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ri+RMlGgGsHoUy25MKXnK9GWHg6k41Rm/PShfFv+bRo=;
	b=n3PCknTh/TUzX6S0ws6SO8XccOH6o6iuM/d2/HBrQoDW2f2f0okR0s7h89VO5L6lwyq3
	 F4RVmTMrDGflwrZoaUufoIAFgci+5+U/700+Mc1CjfQu5FNPijvVh4eugQ7q7dbpqcKsH
	 41aJVa6QkOGgKWsaUOUzjmC5AAvrTt3aD0dlqPrg33qSSuSAiIP3K6AGD0zJuiEdSlH0T
	 oK4ANA6lYIhw4AazzFs6XOFYZBo8FFF5A/WR2Zgv0kEsR8NaJFC1pBaST1GTn1Eb68Vo1
	 v1a8niwfoa3w+H2HxR+8sfeZJU7ZTSBEfMZwgutV2NDfOlZ3VVD3VSjE4jw4Ot8AAfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaG+GaTC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A754606A337;
	Wed, 28 Oct 2026 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AaG+GaTC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB31E1F01825;
	Wed, 28 Oct 2026 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214694;
	bh=ri+RMlGgGsHoUy25MKXnK9GWHg6k41Rm/PShfFv+bRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AaG+GaTCDqQ2ajY/3Tn3Bkrj+Z6Q+Wima2QTvvPnWrXHNrhF8cvszKDKV6FuNz3Mx
	 vC8hdiz9HEXGDJirUyUgkcsfjTezL4b+bXQLJZDjAYodLNygHnH+WwmeLnNKiaU/u5
	 uiKuakUElbf9RMb4+xHbuWwciWqdVwROY1DsUOWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0905/1887] usb: gadget: Support already-mapped DMA SGs
Date: Wed, 28 Oct 2026 17:50:01 +0100
Message-ID: <20261028170520.010748645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 99f638dd49ca80538addec6b3733ddb5784c9373 ]

Add a new 'sg_was_mapped' field to the struct usb_request. This field
can be used to indicate that the scatterlist associated to the USB
transfer has already been mapped into the DMA space, and it does not
have to be done internally.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20240130122340.54813-2-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e5bf5ee26663 ("functionfs: fix the open/removal races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 7 ++++++-
 include/linux/usb/gadget.h    | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index addcff2f77110..bc9c060c9e27d 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -913,6 +913,11 @@ int usb_gadget_map_request_by_dev(struct device *dev,
 	if (req->length == 0)
 		return 0;
 
+	if (req->sg_was_mapped) {
+		req->num_mapped_sgs = req->num_sgs;
+		return 0;
+	}
+
 	if (req->num_sgs) {
 		int     mapped;
 
@@ -958,7 +963,7 @@ EXPORT_SYMBOL_GPL(usb_gadget_map_request);
 void usb_gadget_unmap_request_by_dev(struct device *dev,
 		struct usb_request *req, int is_in)
 {
-	if (req->length == 0)
+	if (req->length == 0 || req->sg_was_mapped)
 		return;
 
 	if (req->num_mapped_sgs) {
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 14090bafe5ac7..ea15f30198570 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -53,6 +53,7 @@ struct usb_ep;
  * @short_not_ok: When reading data, makes short packets be
  *     treated as errors (queue stops advancing till cleanup).
  * @dma_mapped: Indicates if request has been mapped to DMA (internal)
+ * @sg_was_mapped: Set if the scatterlist has been mapped before the request
  * @complete: Function called when request completes, so this request and
  *	its buffer may be re-used.  The function will always be called with
  *	interrupts disabled, and it must not sleep.
@@ -113,6 +114,7 @@ struct usb_request {
 	unsigned		zero:1;
 	unsigned		short_not_ok:1;
 	unsigned		dma_mapped:1;
+	unsigned		sg_was_mapped:1;
 
 	void			(*complete)(struct usb_ep *ep,
 					struct usb_request *req);
-- 
2.53.0



