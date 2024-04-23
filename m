Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037FC14885A;
	Tue, 23 Apr 2024 21:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908642; cv=none; b=PEknxv8IqbvDjiONV+narPpyOw8/UEOLj5NO20ZY1BICXZSPpb1U1oZjkqMN+C956rfcM/XaYt4jITIlY4cS8v2+wmKDma+JSZc0rBNzjoxdbSenO18JCMY1cnr5QExfUvc0dfilLM9TfJDYXJYYhjQCp//l/wXaWrz2rQkD0lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908642; c=relaxed/simple;
	bh=nH63focbY266BVPshuIcDLd9iCHbv58BclYd6Hsic+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFZYgI4x+dPwmPEqNk4Zk59FJr3U2zmX+pQcR2Xr4nib/vImL2X52rrgMB8j+6qewSgFdmIq7LpbS/nAubMiu1SlYBXh1LnghfiNhZw4dz4YU/2U7IU38Ni7FG2jZ8IILc4yFNF9eizpzZLq6NcdW9lW0d47hI+JK6ztyXL6D/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOnhH2F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOnhH2F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4ADC3277B;
	Tue, 23 Apr 2024 21:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908641;
	bh=nH63focbY266BVPshuIcDLd9iCHbv58BclYd6Hsic+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOnhH2F9lKZp47ChZZ+tRf82TkzFNVLDP6Px0N0oLF8QPLMmNtxLBZ7votaUS0pHy
	 /oJFgCNuFrp2HX7BdC7Ng5WzuR1TLNB6yypt36YNPxJ3p5LPLFFDzLoOW4WmvHi8Ep
	 XdP0N4z70dccPJWvgiaHUQfEud7AFVs56AhptgxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.6 125/158] mei: me: disable RPL-S on SPS and IGN firmwares
Date: Tue, 23 Apr 2024 14:39:22 -0700
Message-ID: <20240423213859.790033373@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 0dc04112bee6fdd6eb847ccb32214703022c0269 upstream.

Extend the quirk to disable MEI interface on Intel PCH Ignition (IGN)
and SPS firmwares for RPL-S devices. These firmwares do not support
the MEI protocol.

Fixes: 3ed8c7d39cfe ("mei: me: add raptor lake point S DID")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240312051958.118478-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/pci-me.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -116,7 +116,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},


