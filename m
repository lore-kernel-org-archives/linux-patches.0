Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4A2459FE;
	Tue, 29 Apr 2025 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948116; cv=none; b=I6+N6CYt9AfjDwRspEvTcTmWOdPMR4KuHYEUWbl855X17jBHu/5jZDmO54lfyM9RGeYsjxs8g+IbB7U6ocLNIIfH2BC/KhnQLvmUixQyLOmw9J3mttLZtYnl7ARo+nJBd7Rb5U3awIYlaCKT+HHlz59uJevcgDtbyx1+e44AjlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948116; c=relaxed/simple;
	bh=yJmmPdS+Yqj3Q9RyhTLzPtquGXNBsHLPH5R9mdKdINQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdS38fjwWDHuqqzWhZ265LvBPbQ+db4LWzr1azbtubH7H+qc9k9LMOv0NmXzFJMDhiIynLGNSGXXyn4xb0PIhbNZq959jzlkBPMCQ7SXbvp6HQg7LOnlEf+k3D47efVApAebSNYcLbkns9240zL4HrfM3XnnnXou2hXeAs1/WTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9dxOW3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9dxOW3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7B8C4CEE9;
	Tue, 29 Apr 2025 17:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948116;
	bh=yJmmPdS+Yqj3Q9RyhTLzPtquGXNBsHLPH5R9mdKdINQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9dxOW3Saduw/tyqt1FJY9iz8Db02TTGd33Ux516ymptur6MJOLRzqhEvClpYSppy
	 cSszamUhT/QPiU1yMiKydNsgpiWXccCw0Z76469WvJ4yco+qxN5M4/cPlaLJ5xPwek
	 5BtWQtRwfevCKBCq42PLbd9wrcdOrGYrqXuritrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/280] ntb_hw_amd: Add NTB PCI ID for new gen CPU
Date: Tue, 29 Apr 2025 18:42:15 +0200
Message-ID: <20250429161123.039908498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit bf8a7ce7e4c7267a6f5f2b2023cfc459b330b25e ]

Add NTB support for new generation of processor.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index d687e8c2cc78d..63ceed89b62ef 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1318,6 +1318,7 @@ static const struct pci_device_id amd_ntb_pci_tbl[] = {
 	{ PCI_VDEVICE(AMD, 0x148b), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c0), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c3), (kernel_ulong_t)&dev_data[1] },
+	{ PCI_VDEVICE(AMD, 0x155a), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(HYGON, 0x145b), (kernel_ulong_t)&dev_data[0] },
 	{ 0, }
 };
-- 
2.39.5



