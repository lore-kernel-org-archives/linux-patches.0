Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2185619C554;
	Mon, 23 Jun 2025 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714065; cv=none; b=L/84UFoZU9nFHDVcQwdDqPFuOgZmXqdUsZxOnFhYgBGaQhFbUaZQq8ILiu/qWuerqpT6klfp7cfT6dLvhoKudBHGd/xXRBs0ukrSMp5IGvPzSrsXOHLSIZOFJ0pzko1DCgvHw4kxgsrLYO8Xs1O977fVzIQDMYuWnKwORqFfK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714065; c=relaxed/simple;
	bh=EMVdhpdbS5uLBcwSZhhH5BeK1iWSpG37wmu4eqWtm40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y35jNW6s1saqoW0PjuibfD+V89Kr2xEdbZwPGx2K03D3HIiiLg8cts9sS0BrpHlYRHrJq1nS05JyEkjEBRaiwZliRm5sSQ5oHF7Jf4/N75BoXyb3IZaMVRmJUlCMkkST5zCwSujTW25wOAMaihASsiocMxYEuB05WcvXv7GR+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJOdpzLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJOdpzLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57887C4CEEA;
	Mon, 23 Jun 2025 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714064;
	bh=EMVdhpdbS5uLBcwSZhhH5BeK1iWSpG37wmu4eqWtm40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJOdpzLPcEYve/Ngu1VjoNtjctrJxzclN9vRLaNVGRYWTNBGWnP4t5kghhE9WrnWR
	 +k3hhf+z7RKQzUSDLLxTFyN4xquN0N1EV1OnijnBGIbLqUYc+sGVC1Q0ZmwaEU3FZV
	 9X0hpSAHdB/hBo5HyWxWE0njhoiuOpvn4SlglToE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH 6.6 111/290] PCI: dw-rockchip: Fix PHY function call sequence in rockchip_pcie_phy_deinit()
Date: Mon, 23 Jun 2025 15:06:12 +0200
Message-ID: <20250623130630.292727267@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -275,8 +275,8 @@ static int rockchip_pcie_phy_init(struct
 
 static void rockchip_pcie_phy_deinit(struct rockchip_pcie *rockchip)
 {
-	phy_exit(rockchip->phy);
 	phy_power_off(rockchip->phy);
+	phy_exit(rockchip->phy);
 }
 
 static const struct dw_pcie_ops dw_pcie_ops = {


