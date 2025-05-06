Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A36C227B8E;
	Tue,  6 May 2025 21:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567394; cv=none; b=C8KlfL1hmuxjqjT9gdM+ssp1cJ4HvanipdNMP/VWWrXmeN9RIZpU7gHIWPEQ/f7mckTs85sYlOvu26QNafCBAx3WvhkSe4ITJ2KRIy1rAXpPmyzAtAkMbiGNIbm4bteBUuoDOwIR0g3CFkz3hUB4DdbyiDOoG3yVNF9alKWB8iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567394; c=relaxed/simple;
	bh=B4oqN8pSeB8r9J9+ILMu1WqRwQF588rrnNajwOzT5Sg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BpNlvqyeEi6Pj58ILNIIyx/BwPpmrCJ2ccNpcVaFoGrspYl8UTWTPJWr4QeuttvgC8YrPhmctqEcaqn9MX1lr/bl9x+oMi6PZK8jdnHh/3Kz1b5lyQ2MOBUgWxr2Q8KrUD5qAITSWkUbxKY5GplTbopytBzXfiRQwh17aQww+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDcIwGE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDcIwGE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083C9C4CEE4;
	Tue,  6 May 2025 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567394;
	bh=B4oqN8pSeB8r9J9+ILMu1WqRwQF588rrnNajwOzT5Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDcIwGE7Am8MQKulB1TIWMzOsf/IFCn5PgkEWY/PuG/utkFhba/T2vr/qGKrIYeB1
	 7SS/YrNzBOap2orCOgaFnx8RULV5NyoP/0KbAg6b5RZwEiyVHOa/DwiCeG8GaIZv0f
	 hj7ADY6L65t8S8bpQEMEC0xwK5qhHTmF8KAe5R8Kj/o90je+7cJwp2wcH/xs1eNsdw
	 tW+f7c/Pey/qEiGbBkSNoj3EHsh/hhqsadCOPokgmVbPJO3Id9glB58QMnPw++db7L
	 2ON267DaYImK+AAWi3Omj5vdfAdbcb/jmnBv1i0oS77CWRvKP50k41mbve3Qi0qXoT
	 JzejeaSrHsDoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 11/18] nvme-pci: add quirks for device 126f:1001
Date: Tue,  6 May 2025 17:36:03 -0400
Message-Id: <20250506213610.2983098-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 5b960f92ac3e5b4d7f60a506a6b6735eead1da01 ]

This commit adds NVME_QUIRK_NO_DEEPEST_PS and NVME_QUIRK_BOGUS_NID for
device [126f:1001].

It is similar to commit e89086c43f05 ("drivers/nvme: Add quirks for
device 126f:2262")

Diff is according the dmesg, use NVME_QUIRK_IGNORE_DEV_SUBNQN.

dmesg | grep -i nvme0:
  nvme nvme0: pci function 0000:01:00.0
  nvme nvme0: missing or invalid SUBNQN field.
  nvme nvme0: 12/0/0 default/read/poll queues

Link:https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e89086c43f0500bc7c4ce225495b73b8ce234c1f
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e70618e8d35eb..f6761e6ceca4f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3585,6 +3585,9 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1217, 0x8760), /* O2 Micro 64GB Steam Deck */
 		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
+	{ PCI_DEVICE(0x126f, 0x1001),	/* Silicon Motion generic */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_BOGUS_NID, },
-- 
2.39.5

