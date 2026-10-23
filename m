Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774059;
	b=kuhlwpLhL6OxkmG5R19B1h3ZXYB3dPhdV2bp/K/bCkVtWF9LOmstteCj8kudHsTY5OGx
	 roMvA8KNsLhsbEIbSUuxyD6AO1m9czc0MmvLnT/6bPjaEeAWb9R+hl5hNHz+eeRa5M9Gd
	 JF7e6IHq7A8mQnAPl1wOL09aVAoFzp9p7xE3CfAbxdp2W0HeLVgtOcIs0Idywa2/aL5lt
	 DcC9PFcOxxxm3AnxwDw1F7yHiHhtLQ7QDdXbMie373dSe3Gh8TeZzsREE6CuY7U4ZVgHW
	 RMR78G8zhy+B8UVLgxRn1BV15ts6uW4INi98om/DUhaQfasjgvxUMuZmM02bjHg5Z6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8QZ2cy1ZsK7spOvKm+QnxrmyzoHXrSH3yTZ+v9hNsA=;
	b=2/B3UlOyV1XgTONYXzqCwDTw48S0B2D/rlTXY1aCLK1Kx37heVvUaHA6Sbc8Dx95Oxm4
	 rEXugrfIEil0DcvbWq6vxD5BLVbjJcWpt7HfdfLGI8CXSdhrO8EibDcFDGcMAwuEOhnZB
	 f4QuBO6Yx5yYgbmDBi8dJN0zBxZYGLkj5YZ/7Jfcs8RAp0ThZaFiUzMUTbsW/DYsKfld/
	 4/YuKJiA/NwYAjM8tjzB1/QTOR1aoLEkxXWL5PUKrjD8gD+DizUXZST+y/OdwqVtGGh5o
	 GMYF1Rklh/+XyxrPq77RHpznBznCx/I4GQ4/cgrsCibrndjwk+jsR48Y1r+eUvVtOmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ3E9Hn5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA0E606A31A;
	Fri, 23 Oct 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ3E9Hn5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507FD1F01825;
	Fri, 23 Oct 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774058;
	bh=V8QZ2cy1ZsK7spOvKm+QnxrmyzoHXrSH3yTZ+v9hNsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ3E9Hn5YZ25WCvTbesmyP5jDVAeoqITlS5Q4VQd/8mCbjWwbV8cYgm1xemnnuc6B
	 W4MsZ0P3J3fezkTH3DtozGptYoNAEhbzmOpg+CeDmrfWHszP88HrZKt0akaB/pmeMl
	 CXi0st/CNU3oazO6qlIYcM/Tu/ilUo+a91fUKolw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 108/193] drm/i915/cx0_phy: Fix ARL-S host bridge detection
Date: Fri, 23 Oct 2026 18:36:25 +0200
Message-ID: <20261023163716.763234045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

commit 6a8bf59de3ef47ff51face6ea826395a1098baa0 upstream.

Fix is_arrowlake_s_by_host_bridge() which always returned false.
The while loop always exits with pdev as NULL, so the return
condition was always false, causing the wrong tx_misc value to be used.

Check the host bridge ID inside the loop body.  Once found early exit
from the loop release the pci reference "pdev" and return true.

v2:
 - Update commit message (Chaitanya)

Bspec:74165,74491
Suggested-by: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: 3630a47b700e ("drm/i915/cx0_phy: Update HDMI TMDS C20 algorithm value")
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Link: https://patch.msgid.link/20260921090226.946472-1-dnyaneshwar.bhadane@intel.com
(cherry picked from commit 0507cc5a476af0b6d037b19248bdd20dbe27487d)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cx0_phy.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_cx0_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
@@ -2202,12 +2202,14 @@ static void intel_c10pll_dump_hw_state(s
 static bool is_arrowlake_s_by_host_bridge(void)
 {
 	struct pci_dev *pdev = NULL;
-	u16 host_bridge_pci_dev_id;
+	while ((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, pdev))) {
+		if (IS_ARROWLAKE_S_BY_HOST_BRIDGE_ID(pdev->device)) {
+			pci_dev_put(pdev);
+			return true;
+		}
+	}
 
-	while ((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, pdev)))
-		host_bridge_pci_dev_id = pdev->device;
-
-	return pdev && IS_ARROWLAKE_S_BY_HOST_BRIDGE_ID(host_bridge_pci_dev_id);
+	return false;
 }
 
 static u16 intel_c20_hdmi_tmds_tx_cgf_1(struct intel_crtc_state *crtc_state)


