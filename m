Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015384;
	b=1Qg5+DGMfqQlsN91Cw15k34zwiBk37gKXGWSYssqsSPchHV2sjoCfPj0OwitzEgKSpwl
	 +cSZNmHo89bSu049Gz+6TbSmZaXm+lOn9klvpCdSOBJnLuLDleORH4ZcaevLStRjupi7d
	 s0CVvVlCoocF6q/JC+hcI08bIhIU2QI/H2eCYnqQF7KT2S+Omen6mZeZPK8MbGcbtk83h
	 b/DFks8zgGop8AqQCmIAVOs8yB4iAZVOhE4SEYk9ysjLaBB05i+fP9DLv80gwHhOgHK8G
	 u6O6lDy7ZTxZIZsjz33FReKmP9+KNKc1ltysiZlZfUwtazG3WG233Vn/PbSZ4phFB8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hT2xBy6MgUMNglyW3cmNwzrwLYWDCi/6L+CYYGNmCyk=;
	b=Wzl0GZAEaDWHPz8K84qdHpVm6S5mZb5cPu/Q8p0SBLcXOKPPVZFsclqrFgeDSD3aThL7
	 /gs9YMiBURX/KgjqvWrUEgqia5d+M70LsYmNjGdjwrrEDza05xHJk1P/eHliG6TLDEi39
	 H7M9zVswXsLrAEdtJDtOBpwru+aOl2MzVXtPOLXxWTheHcOGLyFWLgAKS91QeZlhAk23V
	 80JDfU5NneUijuG6zeoM28ozNO+SIM6/6+dYKYGlo5QWK/+cAulXRcwOk7icUQQJ5MT7d
	 AJmX5Oqi7xaXpK+TOicusIT28GjtYkN3N4HLrK55PmWtJH+GgLvD139dThJrWwd7ccw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjTEaULm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34641606A31C;
	Wed, 18 Nov 2026 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjTEaULm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E01B1F000C4;
	Wed, 18 Nov 2026 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015384;
	bh=hT2xBy6MgUMNglyW3cmNwzrwLYWDCi/6L+CYYGNmCyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjTEaULms1hQ4yHLFV+qvmPHQW+UNpt7yNhC4Ms8YtRRIhwq2i3mG070d0njxkiue
	 GaRpPfzHWpHs7kdyiWTVZQUIeZG3xLFI/Yr2HWiqQEQRkf9Fm/GcLei+ddJpRJLTBB
	 zEHRj826MozH48vB7zYdAUQQWbeqwWKhmS94rlo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0153/2651] cxl/ras: Pass the PCI devices struct device to match_memdev_by_parent()
Date: Wed, 18 Nov 2026 15:23:13 +0100
Message-ID: <20261118150253.362162980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 977eaad352bad4c4aac7cd15683800196c2ead57 ]

cxl_cper_handle_prot_err() hands bus_find_device() the 'struct pci_dev'
where match_memdev_by_parent() expects the embedded 'struct device'. The
comparison never matches. The lookup always fails and CXL endpoint
protocol errors reported via CPER are dropped without a trace event,
leaving only the root port, downstream and upstream cases reporting.

Pass &pdev->dev, and rename the callback parameter to match what it is.

Fixes: 3c70ec71abda ("cxl/ras: Fix CPER handler device confusion")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Terry Bowman <terry.bowman@amd.com>
Link: https://patch.msgid.link/20260828215726.1077498-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/ras.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index e307361bb39e4..0759fc9b07de0 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -70,9 +70,9 @@ cxl_cper_trace_uncorr_prot_err(struct cxl_memdev *cxlmd,
 	trace_cxl_aer_uncorrectable_error(cxlmd, status, fe, hl);
 }
 
-static int match_memdev_by_parent(struct device *dev, const void *uport)
+static int match_memdev_by_parent(struct device *dev, const void *parent)
 {
-	if (is_cxl_memdev(dev) && dev->parent == uport)
+	if (is_cxl_memdev(dev) && dev->parent == parent)
 		return 1;
 	return 0;
 }
@@ -108,7 +108,7 @@ void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 		return;
 
 	struct device *mem_dev __free(put_device) = bus_find_device(
-		&cxl_bus_type, NULL, pdev, match_memdev_by_parent);
+		&cxl_bus_type, NULL, &pdev->dev, match_memdev_by_parent);
 	if (!mem_dev)
 		return;
 
-- 
2.53.0



