Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB5A188907;
	Mon,  2 Jun 2025 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876956; cv=none; b=Vnk0C6Uk9Qloi7ZzXHrTDNSVZ5B+nan5NDd3Cid9aaN92NZjE4BXu6wpHcHtEL8A1YdfA4RB14HLpJWSgHzofFblRh85DJhNqZMNEaGQOxlJdL5Wr0UEEUcUzMAkyXtfecykcVrwx3F/rmuyMvNTW5JeoDCwJ74oFSL6Ln9IV5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876956; c=relaxed/simple;
	bh=rI71B6lVWt8ye2NUpQbhMzpiURumJ6prBQV72gBWuGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBJx2YjGQFEgiotjzYBg/Qj86izamA91RjXUT5Gjh+bxYO8YaL203L8F87v2cAd6yDyzoyXOzfhW7dX1XIJzmeidW14FzrWJSC7ULFqITnDXF3f0AjSPSabsPigBOEIihRAy7l+85o5CWSE9C7lJHrRTualPgj5WbsP3S2sz4BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBjK00/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBjK00/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C851C4CEF2;
	Mon,  2 Jun 2025 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876955;
	bh=rI71B6lVWt8ye2NUpQbhMzpiURumJ6prBQV72gBWuGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBjK00/6UZFk0MojdbfkdWhDN27dg5RxiE7Pt6eJp1/WtO5iMGIOEhJzNaGY5itgb
	 MJ02KuslwFRdyK+2vjJYTSy+FncEy9ILgba/yUCHlxZOQlroh0TGzp7L/0goeyRceK
	 ubAHb/mnqxOeCoacM3hHmEeuPeW3eAE+8zMATu6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/325] PCI: brcmstb: Add a softdep to MIP MSI-X driver
Date: Mon,  2 Jun 2025 15:46:42 +0200
Message-ID: <20250602134324.923831225@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 2294059118c550464dd8906286324d90c33b152b ]

Then the brcmstb PCIe driver and MIP MSI-X interrupt controller
drivers are built as modules there could be a race in probing.

To avoid this, add a softdep to MIP driver to guarantee that
MIP driver will be load first.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-5-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index fe37bd28761a8..c89ad1f92a07f 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1619,3 +1619,4 @@ module_platform_driver(brcm_pcie_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom STB PCIe RC driver");
 MODULE_AUTHOR("Broadcom");
+MODULE_SOFTDEP("pre: irq_bcm2712_mip");
-- 
2.39.5



