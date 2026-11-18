Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029008;
	b=C4lAMdxqGDFpyV83JdKjtJy5mT1Wf5HqGEiFTtnl+qH2PH3ZG/zWkyK9Kw7RePF0VzmM
	 RvsGqsTuo96d7jrJwC1gXYHhkGcWVwrCIoXpmApTXwaa0GFIWzfs1zhQf9arKj1Lfhc7Q
	 GSP0xFzFn+ne1OnpBN1UAPuieD9pad12rAVnhphVl+gVH2g6SWe9+1Kpakyth04YlDxc2
	 4Gc76kWokinf0FQhTw+7oshrB2KsJzihWEUDRsnL18Y0vNvjkvvMdz+Zour7A04biwQz7
	 tRfSUlc6ineZCWTR/a2pLVIK/cNSkSKChknoBoBP2+sRVXk69mj3PgRa+RJQS5l7HQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tjAb7lgtJvyU28PO9nmNisiOEYQxIILtgisLOJwBROU=;
	b=i5rDN9DzsbuoqlXc7ZvcKSx3WXfL2qWR3yDe7wlIl36ndhtycmJvzM0UxNE0OOEU0YXS
	 efZplXEIdiUQUKyE/dcgvohg+50/crwkDydDEVf3g7/U0uL+Ismt8QvyeB6GHxadg2wFM
	 JyoOTbTN3VXQ6o9HAuJXJKLZERxFdi34YWUS16x4CtiZhZTKpl2OeXBMEqQrxxKie3XXC
	 Y2uk5JxpZFFvG6r9Mp8i8bKndsvTFvMkrJwwMzEgeXvwgCWQGNxXOFvt6Msoqbp6KFbEs
	 VUZ2NwRSmMYJwup8CVZgqymECljAdiiRu+ZowerGMvcdYc2egkt5H0Drg1lrIu/NR/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIQXEjbe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE84606A31C;
	Wed, 18 Nov 2026 19:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIQXEjbe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E741F000C4;
	Wed, 18 Nov 2026 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029007;
	bh=tjAb7lgtJvyU28PO9nmNisiOEYQxIILtgisLOJwBROU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIQXEjbeJAdSzb+qKpVt5vHKfuiaeFnzVExycvNYH110qZSF+Kkq/pte/pMK+hTbF
	 g6vU8mx62Ft04BfR4MOD0oYVRsj12R8xfJM9z8BvdbXd8qNtek+mC3FzIHq0idT8/1
	 8GJCd4oqnBB0auKiJ7zo7/oYc1wKJ7sQLFUDz4Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Faure <boris@fau.re>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0196/1756] soundwire: intel: initialise quirk_mask before reading it
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150016.198722693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Faure <boris@fau.re>

[ Upstream commit ee8a8cfe4e8d3c67456e554c988017c252710a25 ]

sdw_master_read_intel_prop() declares quirk_mask without an initialiser
and ignores the return value of fwnode_property_read_u32(). When a BIOS
does not describe "intel-quirk-mask" for a link, the property read leaves
the variable untouched and stack garbage decides whether
SDW_INTEL_QUIRK_MASK_BUS_DISABLE is honoured, so the link may be marked
hw_disabled at random.

Initialise it to 0, matching is_link_enabled() in
sound/hda/core/intel-sdw-acpi.c.
Found by code inspection, not observed at run time.

Fixes: 395713d8ca43 ("soundwire: intel: handle disabled links")
Signed-off-by: Boris Faure <boris@fau.re>
Link: https://patch.msgid.link/20260820212220.226912-1-boris@fau.re
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index d444ca477064f..5843c219ca430 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -130,7 +130,7 @@ static int sdw_master_read_intel_prop(struct sdw_bus *bus)
 	struct sdw_intel_prop *intel_prop;
 	struct fwnode_handle *link;
 	char name[32];
-	u32 quirk_mask;
+	u32 quirk_mask = 0;
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-- 
2.53.0



