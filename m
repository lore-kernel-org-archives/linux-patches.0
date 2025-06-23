Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7E9218AC1;
	Mon, 23 Jun 2025 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715171; cv=none; b=G/cdVtFGWOIW342HuSaKcEECfagpzRb8dc8TQz0VCUPWWIXdSRu5zYQSJrOJNTjKsM4/xT3wJ0ek2bBQPkvuOV+3271IQZhGiWIFV3+G37OXvDP3YQ+Q5Yu6re8azPl5LsbYyFAHh3RC0ZBQ3FKJUGec48XXfskRv70yyHyjOW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715171; c=relaxed/simple;
	bh=gxYpF7Et4d0HBwxQ2MCyCUrOoJ7lIDgECAt12083sIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdB1ZksY+FRJJst4aAyPpOj3jTuEnTgKI9O+A/ywGv7uLWqeX12czltzNVCuByr1vctVHuKWv2h4p2xDhxYWF5ejXjU3vlOal2+YSUrlU3utcId2WVQVYW7r7eNFjSfEdCgDxbmxhirY5dj23oQCfj1sS40ic8YPKchbTb+Nkag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEnK19a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEnK19a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B3BC4CEEA;
	Mon, 23 Jun 2025 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715171;
	bh=gxYpF7Et4d0HBwxQ2MCyCUrOoJ7lIDgECAt12083sIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEnK19a/sTrrExPMAWivTQSJtf0nD4apMtAXZFM+Dpj58naxzPYlBA/FfMifBL4ag
	 TkEQytnqN/B6QteAXcuJVWF1LI63dzrXHh827hZlb2U+vpNL70EmqSnb6Lg5pK4pVa
	 umYkU0FoLWqAODfzWkpYd9Qvxk0+S/fCTjegKJg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 5.15 257/411] PCI: dw-rockchip: Fix PHY function call sequence in rockchip_pcie_phy_deinit()
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130640.114086998@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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
@@ -178,8 +178,8 @@ static int rockchip_pcie_phy_init(struct
 
 static void rockchip_pcie_phy_deinit(struct rockchip_pcie *rockchip)
 {
-	phy_exit(rockchip->phy);
 	phy_power_off(rockchip->phy);
+	phy_exit(rockchip->phy);
 }
 
 static int rockchip_pcie_reset_control_release(struct rockchip_pcie *rockchip)


