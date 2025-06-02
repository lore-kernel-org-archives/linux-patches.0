Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740922A804;
	Mon,  2 Jun 2025 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875561; cv=none; b=ZUBkBMjpMUQqzrRLZkcgiw0CplY9RZWq8Ptl8kZU/lhLz5DbdVvaSRwNSl8SmDL12kA5NkvSUtK4/O+NCbK0Zt9YHCxoaswZTFtO/fzRVRgqyrGh/pv8/2ghg+rqQ9gQS88e8y7roLAQIsQR4vgLnq2oZHIh5uHzPCDSIkb3+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875561; c=relaxed/simple;
	bh=VcsbD5vXEPRE69t/Y+2NI14oydo/m4NGJK67aL/tb7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1g963ILkeayNovMi/eAaVqYeN36N7XI7wUdnWjMYdqsyaW+6CPT9UiZRhhZY3vsq7XrUdMNbg564Awk3+OzuwwQDPSn+qjhtSwXGW02/KbcyuCqeqWiTlEgvZ47fQAi2c9JGR65PHVEpzKwKQ3kAFa0kl0fdz0KTjGOSWFCQg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3eufxex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3eufxex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3B2C4CEEB;
	Mon,  2 Jun 2025 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875561;
	bh=VcsbD5vXEPRE69t/Y+2NI14oydo/m4NGJK67aL/tb7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3eufxexHAeiWBC1iJ/bpgCJFQnEnSq+sn5GDu2yP13YwH75k4UV9K3s0NyP3iiZ2
	 tm9bgZp1t8cip6jM7WgTymiDuS2xVJfbz5O4uHwoNlTwrqTpZC2tzdKMCfAAcbetIF
	 o9Gv790bxKrC0gy/j5z+uR7U3HHHPdO5fZFteWZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/270] PCI: brcmstb: Expand inbound window size up to 64GB
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134314.331708247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 25a98c727015638baffcfa236e3f37b70cedcf87 ]

The BCM2712 memory map can support up to 64GB of system memory, thus
expand the inbound window size in calculation helper function.

The change is safe for the currently supported SoCs that have smaller
inbound window sizes.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Jim Quinlan <james.quinlan@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-7-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index bbc9786bc36cf..2fc4fe23e6bbf 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -300,8 +300,8 @@ static int brcm_pcie_encode_ibar_size(u64 size)
 	if (log2_in >= 12 && log2_in <= 15)
 		/* Covers 4KB to 32KB (inclusive) */
 		return (log2_in - 12) + 0x1c;
-	else if (log2_in >= 16 && log2_in <= 35)
-		/* Covers 64KB to 32GB, (inclusive) */
+	else if (log2_in >= 16 && log2_in <= 36)
+		/* Covers 64KB to 64GB, (inclusive) */
 		return log2_in - 15;
 	/* Something is awry so disable */
 	return 0;
-- 
2.39.5



