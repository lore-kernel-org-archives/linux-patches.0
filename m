Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75ED43F8CB;
	Thu, 30 Jul 2026 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427148; cv=none; b=KEel+M5B22zMRb8Bl883E7/XPuw7iIfa3m7BB83c0zyyXyLLk7irRyKBB8383fXalBc/yjdtKiC0xLdI/pzvFiGmbhvKySaiuuIfGr9flxYwR5ZsJIeUS2vOC6pQKLsdEZrz7cbDy7MLnQpJIVO5sXgZO3Xy6DpuKKaGp+0YRoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427148; c=relaxed/simple;
	bh=MhIGnsKLPY2ABnDBG/byNUp+Ftu89HFVKGvKgVlNyhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0x2vXRqYKa2g/PF0dPvnPx9+7Qvm+mUCYhVG50xxQSwBlGswyv/oAV1zg317C6uKVwkA6mcAY0K/1r8Cy9SbJ/yxEr1IGud6PX7pAG6T1NXYP53zE9TxJYNJtMGcREnl6vo8CHeCrrLaOQU6A4p35c/FHZH7zuVMZmEvHR0NaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJTW7a9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJTW7a9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419CB1F00A3D;
	Thu, 30 Jul 2026 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427146;
	bh=hzXLLHeOSYmSchCCgec2cfU6LV+L745d6+veD70oK68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJTW7a9MqDYjIYNDhV8jlY+ek8eIMteg7EtvzeUQQBtPHrvLa2j+sVKbHTkxjsMnR
	 AX6DodxXNpDRfB3ac+fFJ9MYY6PztG84rDp5HI3IggNiq0bKL3pw1VJbJFOAF2oewH
	 U2eWFgGd+DJ/foLox5K61EKGxZWT9Ga2zCVQO8+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/484] ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()
Date: Thu, 30 Jul 2026 16:09:24 +0200
Message-ID: <20260730141424.890486002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4af3c3665387db..8fe602c0b690cc 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -599,7 +599,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	ret = pci_request_regions(pci, "AMD ACP6.2 audio");
+	ret = pci_request_regions(pci, "AMD ACP6.3 audio");
 	if (ret < 0) {
 		dev_err(&pci->dev, "pci_request_regions failed\n");
 		goto disable_pci;
-- 
2.53.0



