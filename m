Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68434CF9;
	Tue, 26 Aug 2025 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215120; cv=none; b=YxaZH//gk8VjZdDpoX9AGTaE6Ky9dn1py9Shv6tEtqTbTejYgyNEH/PEdbJxPEKSarnwiXi6pKHlheCUp2Qy+FqYF86nNaoMN78V4ykYD8G1VgiM05pJvMx3/zYr3vZiq9h6xWQIGvRQqQcJSBhkPd04eS/pR+v3A2L4cifDP1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215120; c=relaxed/simple;
	bh=fbCkmGkEkqUczUEcWuW11lAzXm/urUlBmIiKds5k+hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuuX6bGKTTl6Y8Ok1U+LxjrRUs1Izg3cDxmsbynWDVNogfwlE+OB5VoUSTE1cEL29ia9EuUKqKKYP4SKQQJIjEFDffS0v5JLnMvhQJBC6VW/grz6l3qUQe0UqbX6OiSfypQWwq9nbzO9h0mc5vui2HA5LL/z9IyiO5adHrZ5T50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ht03M/Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ht03M/Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12161C4CEF1;
	Tue, 26 Aug 2025 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215120;
	bh=fbCkmGkEkqUczUEcWuW11lAzXm/urUlBmIiKds5k+hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ht03M/HnhHVJ5boQ2W9dJqiW17K1Hjabz1kUMlfm8NT5roHSqrXnbK8hZta9ilrAn
	 SKhxuYWKATZRfoeNUgYbgy7q2DxQVf74x3uWI3vYsPyOCuMySq23yXaaK9VOuVTOEc
	 kMKpAGWnckVWy+4IQIass6EPG3s5rL7lVSQckp78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 395/482] mmc: sdhci-pci-gli: GL9763e: Rename the gli_set_gl9763e() for consistency
Date: Tue, 26 Aug 2025 13:10:48 +0200
Message-ID: <20250826110940.587699016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit 293ed0f5f34e1e9df888456af4b0a021f57b5f54 upstream.

In preparation to fix replay timer timeout, rename the
gli_set_gl9763e() to gl9763e_hw_setting() for consistency.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Fixes: 1ae1d2d6e555 ("mmc: sdhci-pci-gli: Add Genesys Logic GL9763E support")
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250731065752.450231-3-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -953,7 +953,7 @@ static void sdhci_gl9763e_reset(struct s
 	sdhci_reset(host, mask);
 }
 
-static void gli_set_gl9763e(struct sdhci_pci_slot *slot)
+static void gl9763e_hw_setting(struct sdhci_pci_slot *slot)
 {
 	struct pci_dev *pdev = slot->chip->pdev;
 	u32 value;
@@ -1125,7 +1125,7 @@ static int gli_probe_slot_gl9763e(struct
 	gli_pcie_enable_msi(slot);
 	host->mmc_host_ops.hs400_enhanced_strobe =
 					gl9763e_hs400_enhanced_strobe;
-	gli_set_gl9763e(slot);
+	gl9763e_hw_setting(slot);
 	sdhci_enable_v4_mode(host);
 
 	return 0;


