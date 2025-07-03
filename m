Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4FE126BFF;
	Thu,  3 Jul 2025 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554058; cv=none; b=vB/4mq/nAvLR2bBkkICl82l2caAHn/SP8outDap1RT31EaUqoPSpitAbXis0V5ZaSYmSNuR12hlRUNAV8Z1Jt9GPLV6KRl05nCnnFVJ5e75q4IZ3XVWss1WgdH7QPOiCJbC5X15fTW663fCnMadoWFkaRo18c6DOfgJRE5EEn48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554058; c=relaxed/simple;
	bh=nRfjepV6VMl/lm7mem9dRn6WIH3Yxxw6SwwZjKf8bAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Na+fEFg+caR6PyVC8pIUEO4rO0cjLqyoGOitHFB8lX/hmx6eyFFrCblnKHhRV2Fk+CEWmGq1HJDa8yeejHhyutiF9lGamaDw4YvgG0TQMDu7W0eHcfqwO0bhLmehghg6nAa2npaHsztNrnd/XHmgQ+lFRcVU2ML8ySTVKkhuFf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwoSj1uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwoSj1uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF37C4CEE3;
	Thu,  3 Jul 2025 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554058;
	bh=nRfjepV6VMl/lm7mem9dRn6WIH3Yxxw6SwwZjKf8bAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwoSj1uCxDWjDtE9ZxXZ8LQ9rqQB8cORKMp8McDxaG3MkuAhCpEfpo1pwg6Mw71n0
	 +qzf9rRbuzZqWMifVdnk5X1YbF/gbbDGFk9Z/zjgXJ9homy1WeUNzcV+d5PcVoBUiC
	 SKo56Cgmpw6IY0kp1UXBjxa+h9iTvHHTaOEbfMPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/218] PCI: apple: Use helper function for_each_child_of_node_scoped()
Date: Thu,  3 Jul 2025 16:40:16 +0200
Message-ID: <20250703143958.660038094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit f60b4e06a945f25d463ae065c6e41c6e24faee0a ]

The for_each_available_child_of_node_scoped() helper provides
a scope-based clean-up functionality to put the device_node
automatically, and as such, there is no need to call of_node_put()
directly.

Thus, use this helper to simplify the code.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240831040413.126417-6-zhangzekun11@huawei.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Stable-dep-of: 751bec089c4e ("PCI: apple: Set only available ports up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index 7f02fe198d41c..43280a366266b 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -767,7 +767,6 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 {
 	struct device *dev = cfg->parent;
 	struct platform_device *platform = to_platform_device(dev);
-	struct device_node *of_port;
 	struct apple_pcie *pcie;
 	int ret;
 
@@ -790,11 +789,10 @@ static int apple_pcie_init(struct pci_config_window *cfg)
 	if (ret)
 		return ret;
 
-	for_each_child_of_node(dev->of_node, of_port) {
+	for_each_child_of_node_scoped(dev->of_node, of_port) {
 		ret = apple_pcie_setup_port(pcie, of_port);
 		if (ret) {
 			dev_err(pcie->dev, "Port %pOF setup fail: %d\n", of_port, ret);
-			of_node_put(of_port);
 			return ret;
 		}
 	}
-- 
2.39.5



