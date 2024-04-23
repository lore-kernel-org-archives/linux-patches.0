Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28911145B05;
	Tue, 23 Apr 2024 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908745; cv=none; b=u1qceWuYlS1YZ0t4nCXEfSsgDC9G4RlxosUhIybQz5a3xFmdHNm9O2Inp/J+f1aZg+/1mhI/ViAeK8CUNuPLSKe9BIjRhlkdx0AIgVQpse07Fx/OFQs2oMYKapO2xplZDzVTOiMGlbusq1c07UvRvznNif5cNznglgKIFlBhBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908745; c=relaxed/simple;
	bh=htpgL12qoj6GTkTEG6RBiJjGxaeOLyNY/4nPnAQ58r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmLQtINY+RozZp51gfIz5Jq3DvI8ojy9lSrMGXxBvuAUZi9PRC6OaUiC/UUXi81fLjJKJ8qJ4CeXDA5PA4cgNhBl7ZQBdekVJpswFV02+v5Re5vvDL8W6gQskcookyXXkfT4liC0N3WPqvzCeiktSupGQj+S9plXiYI8X9FtD1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1dpkAhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1dpkAhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ED8C3277B;
	Tue, 23 Apr 2024 21:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908745;
	bh=htpgL12qoj6GTkTEG6RBiJjGxaeOLyNY/4nPnAQ58r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1dpkAhl0PsbZzqyozxwvP4y31y4ke1URm2fxeQTef3z9sw+7lwUNljV/sK+AkmR4
	 kOTPtJw38NzdxSzqiA18i3kLoRItravg/cTT6G6YLjkkWdwC24OzYKiAiXmbQ5OEIc
	 7I2DS7D1aJEa1E+heRYhLGLj1oaalsIibiQ1EETc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 118/141] mei: me: disable RPL-S on SPS and IGN firmwares
Date: Tue, 23 Apr 2024 14:39:46 -0700
Message-ID: <20240423213857.037091156@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


