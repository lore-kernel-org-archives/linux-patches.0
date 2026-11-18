Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016662;
	b=z30c9F4dngCFtBDaG7XDT/fRzFgtNJrk5JCbaV7dyHUdomIsgJ/cj+1dB9L6j5dSi6QS
	 HxUGOEjbyTlYyE4Ge4VQunJjRc1om9OdHETlrCROA1RTSItH450ga4tvuPqqOc5Za7wDU
	 t2wflDrlVmiUe2st5+w6gKeV5rm37HMMNmnuQj3KozeX8uFQQVK/OTYpQF8ft2wyW3CFe
	 DDNWewLvL7rAkZRayjvrKOGPjtao4Gutd16gcu3qgOlE9mDkqxyuYfYS/amDYq4Gofayg
	 h4JVPBcx59uEqawLwoMVRHEdIcUcJQqdbJq2LYsqAqHi8UcZYrip9EPss1MCgWHsjZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/JDAwfWTyshcu/xF2AwqN6MAyGpAcUWrge+qNpPcEwk=;
	b=Vs59coPhX7l/B/1pGvNKrBus/nxXlGzFE5JIFbnwB1nOce8XBGqksW3rhy//4GMtAXBr
	 /eWc6O42zp/DoZpdqwnNzkAC4hEkPmbc1vtOvR4xR4IH+wGMNdiE4V/i2hq6c/YeUbW6h
	 r8O9+go5hFeoRrMjDL5OJzMCsPRdm/UmFVrntS+DGwly7ck1hW6aO1zlwT8khfqSGAROp
	 12Wkyz9Zqvh3eLyI6HGMBDJVn+6JL+bC5IvO82FiHGaK3ay5FIA0czEyU2jidzx4YEr0l
	 d//jPNg/db7nV4/QZUDQYnO8jIiceeValR0EiGaV8+Eq0CTBS/6F2UMs2qlnpXVlVxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4AKNbmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5239606A31C;
	Wed, 18 Nov 2026 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4AKNbmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146081F000C4;
	Wed, 18 Nov 2026 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016662;
	bh=/JDAwfWTyshcu/xF2AwqN6MAyGpAcUWrge+qNpPcEwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4AKNbmYYxG30z97Oyf5nJ23qYMN+nP277/raJekO53GdlmW1NxNG6c0Bec2026FK
	 lg6nISbGZtYkzBeBmECWds9NIW6MI/pmNmaTvcmbpzHKRIQDEwTWSmAw1Pp/1JK4IF
	 1THphJe7uNsLWHImpdJfdlpjje9EVc36Af3nXOkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0567/2651] cxl/region: Unregister the pmem region when the bridge is unbound
Date: Wed, 18 Nov 2026 15:30:07 +0100
Message-ID: <20261118150308.151495711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit bb26797c08d408ea7e8d3625045f0fe28714a425 ]

Removing cxl_acpi unbinds the nvdimm bridge before the regions it
serves. A region probe can therefore register its cxl_pmem_region and
only then find the bridge unbound, which leaves the new device with
nothing to remove it.

The orphan outlives the teardown and pins its region and its memdevs, so
a later cxl_acpi bind renumbers the root port, ports, endpoints,
decoders and the memdev.

Unregister the cxl_pmem_region when the bridge is unbound.

Found by code inspection. Racing a cxl_region bind against a cxl_acpi
unbind leaked a pmem_region device on 12 of 12 attempts, and none with
this patch.

Fixes: f17b558d6663 ("cxl/pmem: Refactor nvdimm device registration, delete the workqueue")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260831061120.200790-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region_pmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/region_pmem.c b/drivers/cxl/core/region_pmem.c
index 23d97e3d78b6a..7ab1373a95e01 100644
--- a/drivers/cxl/core/region_pmem.c
+++ b/drivers/cxl/core/region_pmem.c
@@ -168,12 +168,14 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 		dev_name(dev));
 
 	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxl_nvb->dev.driver)
+		if (cxl_nvb->dev.driver) {
 			rc = devm_add_action_or_reset(&cxl_nvb->dev,
 						      cxlr_pmem_unregister,
 						      cxlr_pmem);
-		else
+		} else {
 			rc = -ENXIO;
+			cxlr_pmem_unregister(cxlr_pmem);
+		}
 	}
 
 	if (rc)
-- 
2.53.0



