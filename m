Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B99239E63;
	Mon, 23 Jun 2025 13:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684882; cv=none; b=R2SwNqEahUr0HZepVKAOOe+8CKp0yV0vGwaBnm3b6oD9hw4mwTf7OXVn/ItHuLPThC0M/5BIRPuSk8yCEfFowV6LreQLpgX2EFD4sxxLGfyXVQYR1GV+0GfhQRNnocoZq/Ez2N7tJTRFdFQyvZhVIGR8NW3MexiUNG8S09ieem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684882; c=relaxed/simple;
	bh=cjJIpmXlCK/xtythgxRb8h4AnfHFnXbCFyXyWt1ZQyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF7bpfJJPAe0jDCif8QNx+GWQ800LZ09MeauOdkdfHuD92m2yxzN0Uc6QWxFIFy0QTfjodc95g9OvH88DazAfAyMqIPeBgsAUs2lSVCxfrC9iDF51FyDZedUBPADfebIcHOknkEUxBrvzMXhymWeXVtFTCRgS5A3nYnOBm0mB04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEdJBBgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEdJBBgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E6EC4CEEA;
	Mon, 23 Jun 2025 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684882;
	bh=cjJIpmXlCK/xtythgxRb8h4AnfHFnXbCFyXyWt1ZQyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEdJBBgsc5QpsNUGyhc162bZHh4dgws3oavP29Y7PT2GQXyAOsZblPmZ7qukShW4B
	 L2HZAgAtQ3P/1sGHJwuJB2JLswfhjN3aKPys6hHBEZYKsQLmehc52BZdSrsTP+ploy
	 NngPe1ev0GUWxsDXEH9dNGuiDT64KmZrXKSrWGX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 6.15 186/592] PCI: dw-rockchip: Fix PHY function call sequence in rockchip_pcie_phy_deinit()
Date: Mon, 23 Jun 2025 15:02:24 +0200
Message-ID: <20250623130704.705687261@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <didi.debian@cknow.org>

commit 286ed198b899739862456f451eda884558526a9d upstream.

The documentation for the phy_power_off() function explicitly says that it
must be called before phy_exit().

Hence, follow the same rule in rockchip_pcie_phy_deinit().

Fixes: 0e898eb8df4e ("PCI: rockchip-dwc: Add Rockchip RK356X host controller driver")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
[mani: commit message change]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org	# v5.15+
Link: https://patch.msgid.link/20250417142138.1377451-1-didi.debian@cknow.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -408,8 +408,8 @@ static int rockchip_pcie_phy_init(struct
 
 static void rockchip_pcie_phy_deinit(struct rockchip_pcie *rockchip)
 {
-	phy_exit(rockchip->phy);
 	phy_power_off(rockchip->phy);
+	phy_exit(rockchip->phy);
 }
 
 static const struct dw_pcie_ops dw_pcie_ops = {


