Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774799;
	b=faHt9sFuFqQ/GXOdGmyqgK+vn+9N5YzcskKb87hByoVhNwfv40Xxyf4esVATk7rqAzB8
	 klHKIHcLVJopbf1HWp8gNrGljB3K7HKmH8bKZbBkDCjlarJanuS/6lAufW2yyBV+cD9BM
	 XRKpo7bteDE/v8zTEnT68APLPOf/mdB9bwc002o0V3PDx+PgqJui82WFIcbXc99eUJYet
	 ajwlrp+z7L2CiijPgIoQh6ywx9Y91kLy6walWl+5tX3LAKil7wMMWtVTkDBeSXMXEG3rY
	 upJ1stHbYG3u23D3xy4NnmnKpTQvDs4jXsm6TdT4w+mrHNgXrQcZPTCx20B6VWdpQHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3y6mWUKrWlaKO8vtnIl/IdiUbQuLWHZQ4msZg6jj2I=;
	b=hVaS/i10xyScR1/lIsvSeCSDYP5m2OZi//OKWm4SVZrG86Qq8OF8KUcmXuLoCXq9bBK6
	 I3v5LZmQjSA1LKHcrOPvcqhloaJ+HXDtV3n/goGr/2+6aqAfUD8+aB6zFH+BkzudwkF6x
	 alxb3DKdtfUF/6Rfj34HY7DP2jXJsTiTFDldVbnIIpNInWdECsMN1GSSE1IFgQgfi34Zv
	 IyhxOXT4DHyg9YMWwEzOUlMnE9w4jB8Hz8eK5LIQjdDpgu4HoiHCJYTzqJx0nB/Yezb6g
	 wW8Q67hsTIXrqW0VpUGjvy9tpGt0sAyqVCPB4CYr4B6zmgyjN2Lq1VrVAa430A6QUmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbziGgQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5FD606A31F;
	Fri, 23 Oct 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbziGgQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184CA1F01825;
	Fri, 23 Oct 2026 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774798;
	bh=b3y6mWUKrWlaKO8vtnIl/IdiUbQuLWHZQ4msZg6jj2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbziGgQHw+IeNVvjRFWlJvAiM4Yv+eWduBpp6PCAE1ztdwPagobZb8qsTjrFmpOa6
	 DLzP0jQELYq+a4gfOHnbrVr7DJ9mVkmUL70bzRdluwYLXX3jjAOZJCLuSoUwsPO+m6
	 gVKujOPRnC9Y8r8ksRrkTMvLXD0YE3N9/7mGxdjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.2 161/242] drm/i915/cx0_phy: Fix ARL-S host bridge detection
Date: Fri, 23 Oct 2026 18:40:03 +0200
Message-ID: <20261023163717.592157986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2341,12 +2341,14 @@ static void intel_c10pll_dump_hw_state(s
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
 
 static u16 intel_c20_hdmi_tmds_tx_cgf_1(struct intel_display *display)


