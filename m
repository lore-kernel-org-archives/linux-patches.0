Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B2143757;
	Wed, 19 Jun 2024 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803489; cv=none; b=lBXJnaAefxIIPK1XyQxaZgI/3MKLw1Co7rqFb44g0pNwSuZmDQ5pmmSAdpsHaLOR52n9xDJhNOU6Sc7G6QS01/pvye1LFBPKcCxjBWo3l15lNeM6EYmKWpKQJP4Y1IyVgaMOMqSeFHqWmZB3W7Aq/wiyaSJJPoiVU7j/UqGCUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803489; c=relaxed/simple;
	bh=Z7KDLXxmAz2kkcD6N8lfPRwHPzyupQWhWin7WQq2czU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+Cw66gP4WuPmtqUDtyFTLHfad3IYDPfbX1Av4ehY2G9YALbBACAeeW3dWed0Rntv/YCkN/Dn4+/guIDxGuilu4neKCED6ruq0Y1t3WZKo1hFBtE+WMFZn1bh/yxTwvrDJKvFlAbM7ZchP6mBlv0kf1K2fjvbbX44EWigw2IY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Osciyg2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Osciyg2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E61DC2BBFC;
	Wed, 19 Jun 2024 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803489;
	bh=Z7KDLXxmAz2kkcD6N8lfPRwHPzyupQWhWin7WQq2czU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Osciyg2VZ1rRteRm4FVl8aC3UGBhAQCvvetlqnUnOrRPGEWyKI+J6/DF+II/st+fp
	 x8CS96mYYWmwB8BgV+IrY6VdIZdJhm1W78Xx5Q82ip51gg4W490Hwqbx2fMzXi5rTv
	 JNE5fFmD5viuT5Pw1MgtXgMM350GydYER9LaSBpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.9 243/281] PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id
Date: Wed, 19 Jun 2024 14:56:42 +0200
Message-ID: <20240619125619.313334512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

commit 2dba285caba53f309d6060fca911b43d63f41697 upstream.

Remove wrong mask on subsys_vendor_id. Both the Vendor ID and Subsystem
Vendor ID are u16 variables and are written to a u32 register of the
controller. The Subsystem Vendor ID was always 0 because the u16 value
was masked incorrectly with GENMASK(31,16) resulting in all lower 16
bits being set to 0 prior to the shift.

Remove both masks as they are unnecessary and set the register correctly
i.e., the lower 16-bits are the Vendor ID and the upper 16-bits are the
Subsystem Vendor ID.

This is documented in the RK3399 TRM section 17.6.7.1.17

[kwilczynski: removed unnecesary newline]
Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Link: https://lore.kernel.org/linux-pci/20240403144508.489835-1-rick.wertenbroek@gmail.com
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -98,10 +98,8 @@ static int rockchip_pcie_ep_write_header
 
 	/* All functions share the same vendor ID with function 0 */
 	if (fn == 0) {
-		u32 vid_regs = (hdr->vendorid & GENMASK(15, 0)) |
-			       (hdr->subsys_vendor_id & GENMASK(31, 16)) << 16;
-
-		rockchip_pcie_write(rockchip, vid_regs,
+		rockchip_pcie_write(rockchip,
+				    hdr->vendorid | hdr->subsys_vendor_id << 16,
 				    PCIE_CORE_CONFIG_VENDOR);
 	}
 


