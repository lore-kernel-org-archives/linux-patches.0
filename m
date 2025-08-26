Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDEC216E1B;
	Tue, 26 Aug 2025 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215805; cv=none; b=OTOeVa+0hYKaT1+zrGiaig5ryCsMVHlz0GlQDbuago/oQ34xkoCH8YpAzWmao6YJOr5Tzj6Ofd1AVCulNTzgzeyBYHhFThLdUy3+lHibDf5U4MCH0bC7AFBVaHfI8jMOBAg1iYaFwN3hjwU0hx4ZlLY1ylai7zvMTgJA9sGVnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215805; c=relaxed/simple;
	bh=M3y1KKPfnxw06+kLUMB8wwAg6Jp1g/PZpF2HxoQfygc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntdqyAZUpCY8IOulW4ErnnLohRZdkQW55bWkt1fTOiM4dE3NfWewWfyzheJYX2mRf9gH9TzNZsmHSnpPjKaSYOt8UNAKx6A6cHVZXZkVMHnMUCo5VMHXrc8qJXYhwdgA8NlJm/2/wHDfZ5k2TrXWpsqvuGS2VQfhwDZOuj/WoCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/eHgGlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/eHgGlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D7CC4CEF1;
	Tue, 26 Aug 2025 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215804;
	bh=M3y1KKPfnxw06+kLUMB8wwAg6Jp1g/PZpF2HxoQfygc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/eHgGlP2zO8LveHX/CDvRgpCA3ILdXuJOeAtiBK+uhGhmP6sRiVYMv2Iqi0EKL9o
	 vi9J53YjsYXO9nhdQ98NUknWB5nQdWHArDrsh9gCHDQ/O+4fVE3wm7HCgeElmxFEs+
	 bDQ9oII3FlfDX8XyuImn3U0aG6Vulkzbgt6eXLfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/644] PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails
Date: Tue, 26 Aug 2025 13:04:24 +0200
Message-ID: <20250826110950.759768815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 7ea488cce73263231662e426639dd3e836537068 ]

According the function documentation of epf_ntb_init_epc_bar(), the
function should return an error code on error. However, it returns -1 when
no BAR is available i.e., when pci_epc_get_next_free_bar() fails.

Return -ENOENT instead.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
[mani: changed err code to -ENOENT]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250603-pci-vntb-bar-mapping-v2-1-fc685a22ad28@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index fb926b300c95..5cc0d2014ed8 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -686,7 +686,7 @@ static int epf_ntb_init_epc_bar(struct epf_ntb *ntb)
 		barno = pci_epc_get_next_free_bar(epc_features, barno);
 		if (barno < 0) {
 			dev_err(dev, "Fail to get NTB function BAR\n");
-			return barno;
+			return -ENOENT;
 		}
 		ntb->epf_ntb_bar[bar] = barno;
 	}
-- 
2.39.5



