Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36972373128;
	Sat, 28 Feb 2026 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301507; cv=none; b=txNfTsPEIZTbRynVi61fnKjVnGNUeZRThK6aeLDoPZ+2DdrSM6uMeeO0iiRJ+8qC8ENpnWbsLbu5d6CwmivS6YLuiB+A7DmMaIjRA6paXVfezlF3nQtSbEXJ0hTGWfhIlXT8li9oby0LAvEOnmJGP/QK0AOgOcZJY3jNZs+z8jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301507; c=relaxed/simple;
	bh=n11fJxM1zdO1l3kKSRQWSOUtzlFHtSJ7rvoF1B0cTWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8YWuMbINQXwhK2iBZOFNoDqHgfUHnNUTrmlJDfbb24wzZk/aLAF9MYRqy5Wa4G2jCgu1Vzd9/4It/8J5UH8MQhlmycD5/vvEGwBHjGfe1ABaqXJOg+eoj5NZ2FyklMtliFrmt9fMggNEWxSNKirkSHOLQQYLSpVhkeNaJKdNos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLH3zu+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLH3zu+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86112C19425;
	Sat, 28 Feb 2026 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301507;
	bh=n11fJxM1zdO1l3kKSRQWSOUtzlFHtSJ7rvoF1B0cTWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLH3zu+QadviNI1ca2v+/IQ2cQFiHY5E+ibZvdKWroMSKufgau6B+0ieLDdX3bd40
	 sdy6uO2DP45liWXVNeaN4DYrDx93ZE0J69jmyH9i5sYSs+PFVirTEf7vwvh57YzBDt
	 bN9JXwB83IR/vhryCIZ5VV7RPOZVFbI5eUw7TVAGdJexZ6Se/MuIvbKOM58gO55lVD
	 O26n0aw5bdBaA9XgtbbpmJWR+qdqsE6UZg8I6YMmmcrUKK2NjMn3zgw4w10lMKk89E
	 pRUdj9FHWnJjmPKrNDFH+OR0uXy5AURE72JslzglmUazVP9tVu6/S6FEjsEJMAliQi
	 nX8F4GfRtIhMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	stable@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 692/752] net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
Date: Sat, 28 Feb 2026 12:46:43 -0500
Message-ID: <20260228174750.1542406-692-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit d01103fdcb871fd83fd06ef5803d576507c6a801 ]

The ID 1186:4302 is matched by both r8169 and skge. The same device ID
should not be in more than one driver, because in that case, which
driver is used is unpredictable. I downloaded the latest drivers for
all hardware revisions of the D-Link DGE-530T from D-Link's website,
and the only drivers which contain this ID are Realtek drivers.
Therefore, remove this device ID from skge.

In the kernel bug report which requested addition of this device ID,
someone created a patch to add the ID to skge. Then, it was pointed
out that this device is an "r8169 in disguise", and a patch was created
to add it to r8169. Somehow, both of these patches got merged. See the
link below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=38862
Fixes: c074304c2bcf ("add pci-id for DGE-530T")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20260206071724.15268-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/skge.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 05349a0b2db1c..cf4e26d337bb5 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -78,7 +78,6 @@ static const struct pci_device_id skge_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SYSKONNECT, 0x4320) }, /* SK-98xx V2.0 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4b01) },	  /* D-Link DGE-530T (rev.B) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4c00) },	  /* D-Link DGE-530T */
-	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4302) },	  /* D-Link DGE-530T Rev C1 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4320) },	  /* Marvell Yukon 88E8001/8003/8010 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x5005) },	  /* Belkin */
 	{ PCI_DEVICE(PCI_VENDOR_ID_CNET, 0x434E) }, 	  /* CNet PowerG-2000 */
-- 
2.51.0

