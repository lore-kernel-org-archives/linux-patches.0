Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FDF211A0B;
	Tue, 29 Apr 2025 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946234; cv=none; b=P2KqF1kHhQyy2xhaadst5m/RKBUZVLk8VpxkVHk3wslPU64noO46yRE/71ahjdpA/SwAcJsgyCpxuE29ZhW6DqL0azeL5AvwbgGfuhPY4X/jJS1J6EmZ03wAdXjCq9r1KaqSAePh+aOPX+pjZGi7y4LCIc0j55PNsfADZ1qyDZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946234; c=relaxed/simple;
	bh=w0uk+a+n7rg0jTa34ARw4EQwEcMGEGmvyRl+fHiLqn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swFo4vC3RUU1HcCIWAJOQH9MUmgPfC91gN+6lt95DEGlDkMOUWBlM2bFJd89zl3qSbs8CQVqMqg6ASiPGtTCU8Y9G9c/tb1O1AJXdAQSBg3E127cznGaDnPuGe4SasfKTwudcFtn8jFEc6vIvCHrAG8i7cAp8E7FOMpochlbZ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHTDBmFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHTDBmFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3731C4CEE3;
	Tue, 29 Apr 2025 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946234;
	bh=w0uk+a+n7rg0jTa34ARw4EQwEcMGEGmvyRl+fHiLqn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHTDBmFsoigQhwTt3u2XIXLH5fPaS/IBeUVuvzqgIR3tBEb7hZgtrWj33ApIlgPLt
	 58Kptr2w26ykFg4SxC5l/Nol+VqSEJhkdwhG2cZsejunOjEM1134mn+AYTdH2qU+Rz
	 4jZAm5Sr8DSJfhZpur9il5owjFb99tB+F+tx6bOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 182/311] crypto: ccp - Add support for PCI device 0x1134
Date: Tue, 29 Apr 2025 18:40:19 +0200
Message-ID: <20250429161128.478177956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>

[ Upstream commit 6cb345939b8cc4be79909875276aa9dc87d16757 ]

PCI device 0x1134 shares same register features as PCI device 0x17E0.
Hence reuse same data for the new PCI device ID 0x1134.

Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 157f9a9ed6361..2ebc878da1609 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -532,6 +532,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
 	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
 	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
+	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
-- 
2.39.5



