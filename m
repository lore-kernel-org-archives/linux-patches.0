Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C93B8BA7;
	Thu, 15 Jan 2026 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499070; cv=none; b=ozn2yWK8FGmT0GFPJdKGf/TNYgCzri6Iy6CpmhyBcqK8D6X4yiEbIH8fPg84mgA7riwMvUuycV6n0sETRZHj8mWH4Rj1rffaexQSRfRHt38Idth1mtTn9cm+c8zrAjvRm/XBtH6vkSdsFnxU9MzjzDUiQnFenPdBodzDXxKlUPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499070; c=relaxed/simple;
	bh=55lPOlQxx2FzMnymcnGOzZN9Q3EZhAG/vmIC/gS4PRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7vdf8fi0UYqmOJp7U9lvAlfycgqRn8w/C72GEZSu+qD3tamqaL2b/8ObQ5/wOqnyhHfgpI1TZHKvJNHYqv/wqwgXcmtjF7y57sS9NYD+8DjvUKWNp3zf0zLuq3J874SIv5493nSBIHO+U6bHoLMnkpbMWGW8WJdI4mBcy7A28Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYZLnTQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYZLnTQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C3C116D0;
	Thu, 15 Jan 2026 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499070;
	bh=55lPOlQxx2FzMnymcnGOzZN9Q3EZhAG/vmIC/gS4PRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYZLnTQVOmC97QxDbFzURfob1fsJCHujIqHLsiP1teRsDi4l3+TDPDDl8GSOQfXnv
	 KkhBvYRk61/6YiQoJUdaWn41GQjDR40I3SKCeFLFm0To4wZRWn8J3PIXj4kFxFsVZu
	 BFFw47ad0aYfuHwDk43SuYcEiJx3Dq+tO++cHaVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/451] PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
Date: Thu, 15 Jan 2026 17:44:59 +0100
Message-ID: <20260115164234.462775547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit bcc9a4a0bca3aee4303fa4a20302e57b24ac8f68 ]

As per DesignWare Cores PCI Express Controller Databook, section 5.50,
SII: Debug Signals, cxpl_debug_info[63:0]:

  [5:0] smlh_ltssm_state: LTSSM current state. Encoding is same as the
  dedicated smlh_ltssm_state output.

The mask should be 6 bits, from 0 to 5. Hence, fix the mask definition.

Fixes: 23fe5bd4be90 ("PCI: keystone: Cleanup ks_pcie_link_up()")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/1763122140-203068-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 9d2f511f13faf..2dfeec79c6718 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -52,7 +52,7 @@
 #define PORT_LINK_MODE_8_LANES		PORT_LINK_MODE(0xf)
 
 #define PCIE_PORT_DEBUG0		0x728
-#define PORT_LOGIC_LTSSM_STATE_MASK	0x1f
+#define PORT_LOGIC_LTSSM_STATE_MASK	0x3f
 #define PORT_LOGIC_LTSSM_STATE_L0	0x11
 #define PCIE_PORT_DEBUG1		0x72C
 #define PCIE_PORT_DEBUG1_LINK_UP		BIT(4)
-- 
2.51.0



