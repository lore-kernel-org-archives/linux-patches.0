Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08A282E1;
	Tue, 12 Aug 2025 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022282; cv=none; b=uW0O4yIPrNNySa9N9KsXN2I1Rh9Tk5X4gMFdwpUgyNCz9XBEvZd4pOGp+aDbPGPixik0jyLur656gNTwwItUuxZ4mK/CZd1dhWRuN2CAkxRE251xZNmpbDjLXy9E7dAQ504+FKY2biRZc6UEPgrtyUQjWqtYFc2ehht59RDLDTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022282; c=relaxed/simple;
	bh=NbDeLkuJQuEsZURzINZlr33Wx1tegMfwQx4uwT/ILoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APBoO477ZietwIXWDuw71pNc+cgPPimLn3HN43rNLw691J+ZBKFr79IBTStTMuXB0/rpUmi8Hvi8YTg4oRDniduW4G65Vl8VISDeam5eKitbFgUzuNzJ29uVZB5M6pJ32O1Vp4bD3Ry9F4cvTbLlEII4G+jC2AeiMFrX4OCiYck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t934R09u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t934R09u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A97C4CEF9;
	Tue, 12 Aug 2025 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022279;
	bh=NbDeLkuJQuEsZURzINZlr33Wx1tegMfwQx4uwT/ILoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t934R09uPkfVrtcqzi4VUa5cayMAvBeuPW816DYdOMPi6I6us0Rtzzokkd9biwVCx
	 1gnjiqHKfXA3+an5V+gGv5lCpKVx2BAqlVTcu9ALCnbFyLH8mC2+oHyNYlmlL/vkVY
	 EZhjZr/aIBMXymR6XmapS9e0jK2H9r5qggGoIcng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/369] bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640
Date: Tue, 12 Aug 2025 19:26:02 +0200
Message-ID: <20250812173017.210311142@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit ae5a34264354087aef38cdd07961827482a51c5a ]

T99W640 was mistakenly mentioned as T99W515. T99W515 is a LGA device, not
a M.2 modem device. So correct it's name to avoid name mismatch issue.

Fixes: bf30a75e6e00 ("bus: mhi: host: Add support for Foxconn SDX72 modems")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
[mani: commit message fixup]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250606095019.383992-1-slark_xiao@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index acfd673834ed..6505ce6ab1a2 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -509,8 +509,8 @@ static const struct mhi_pci_dev_info mhi_foxconn_dw5932e_info = {
 	.sideband_wake = false,
 };
 
-static const struct mhi_pci_dev_info mhi_foxconn_t99w515_info = {
-	.name = "foxconn-t99w515",
+static const struct mhi_pci_dev_info mhi_foxconn_t99w640_info = {
+	.name = "foxconn-t99w640",
 	.edl = "qcom/sdx72m/foxconn/edl.mbn",
 	.edl_trigger = true,
 	.config = &modem_foxconn_sdx72_config,
@@ -792,9 +792,9 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 	/* DW5932e (sdx62), Non-eSIM */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe0f9),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_dw5932e_info },
-	/* T99W515 (sdx72) */
+	/* T99W640 (sdx72) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe118),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w515_info },
+		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w640_info },
 	/* DW5934e(sdx72), With eSIM */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe11d),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_dw5934e_info },
-- 
2.39.5



