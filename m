Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD370242925;
	Mon, 17 Aug 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978947; cv=none; b=qgcUMGJGiiJZiwYTGr36Fq8iltOU94weiG240k5hAmfbl6j/1HjGcgX/ZhqMesNELlo1uUcvUtJLPuZWDOCwfodstMln2tnFWgaR7zfMma2jjniEw3GNWs9KtbxUHd4olZoiXi+A3400Us+b+tEJOagJIMvv7gbwzVsO3RAdqL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978947; c=relaxed/simple;
	bh=bVOC/HPJnPm5FbW8Jt5ewodnpoljlY/MR+v4aYyVV68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ7ex4ef9VTVWGd3rbGlbuUCl/+fjk179oqO+00w0s0ayrSEvUZqefxiUsqvZ3yBw4R8o8/7eXiufibDmzFkg4uFPoFvN0Mb/fVLa+mR8LxdSDz6qE9z6cf/+DiMyCromRzYRxlSBYcybQLq7qIBx23iPa0SS8WFDn+lfzn3la0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMSDKAO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMSDKAO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186B1F000E9;
	Mon, 17 Aug 2026 15:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978946;
	bh=xBKo06LF9opXpih/ivs5f/b2EJLjk8Apmx9+nkonSBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMSDKAO+lpBeyQwpotl7b21rGQ7JqNvdPG5wour763w+d/JiK6XY+Oc4MdAOIKDhE
	 zi0HlzC6hmBWJT/kpYnXzU77lF+lmhEAwauCpn+T6NmxTrlmiMxNMhsn7sQBZkWqJk
	 8UfCe3+W/3hZ0+dok4QQxVwxChXYjpl8c1Vk0T40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/609] ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()
Date: Mon, 17 Aug 2026 15:25:50 +0200
Message-ID: <20260817132545.240044896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f7697ecf6eab9d4887dd731038b3dc405c7e755e ]

The driver handles ACP6.3/7.0/7.1/7.2 platforms but the region was
claimed with the stale name "AMD ACP6.2 audio" left over from the
original ACP6.2 driver. Correct it to "AMD ACP6.3 audio".

Fixes: 95e43a170bb1 ("ASoC: amd: add Pink Sardine ACP PCI driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260707060130.2514138-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index 7c9751a7eedc22..c3bce6ed090d79 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -163,7 +163,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	ret = pci_request_regions(pci, "AMD ACP6.2 audio");
+	ret = pci_request_regions(pci, "AMD ACP6.3 audio");
 	if (ret < 0) {
 		dev_err(&pci->dev, "pci_request_regions failed\n");
 		goto disable_pci;
-- 
2.53.0



