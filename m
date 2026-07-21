Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AD33C1978;
	Tue, 21 Jul 2026 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660494; cv=none; b=iPTnSwR/BEEecwPU5s2EPgb9QoHvPk+U9UGHyLKzNxo57E/Uxg5gW2NjIEKDFE8rMXMoGUqVRhdME6LEBAqOau3pzMQ8wI68WwdFUnfk80PBCMR3b4cTAdQKS+H/0G/Ozj0/HuUCx4m5ezIg86YBpe4V8XsuleNoxIwjVgYkVVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660494; c=relaxed/simple;
	bh=/huYDXu9wnakJ9q52ytZoT/KlcXF+FDn7X0ywaNo6Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3iX7niIdfxzaOhkPpaZOv3Xyt75sX57X3eCyX7GRHXjUMK4djR8ooWCHuYd280btq9DFOWiNWEeBLP5idqNoZ57UU9xgojOmilID+8oCxDQNx+Qltn8dtsFxS+6inQWnkWqexBoAUv/wHx4DwmHIH+hzOPu2uvuNXmXNbZpl+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ2f8wE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ2f8wE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC01F01559;
	Tue, 21 Jul 2026 19:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660451;
	bh=8e+ihxkjXrOxIGx0h1iPYVMcMgj6sU0gWG5B1/SVXY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQ2f8wE6QOT+1YnPBo/piN/vi1//lLyxekqnhQKe5WNqNTK6RWxRZmVS9wQf5WOzh
	 8K1ll3OcFvb1++uV8uOUGKcX4F143b8sACU51PxGjq8fTfNg/oIb0hq9I6wd/q4EnQ
	 IfMt01s9o9hgEQGXQk8U4aBNBd3NmF9XsUSyeApc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0985/2077] PCI: rcar-host: Remove unused LIST_HEAD(res)
Date: Tue, 21 Jul 2026 17:10:58 +0200
Message-ID: <20260721152616.049553379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 6ba90ce2069ae923b0ec787aebdf2d786e5d2a58 ]

Remove the unused LIST_HEAD(res) declaration from rcar_pcie_hw_enable().

The macro instantiation defines an unused 'struct list_head res' variable,
which conflicts with a valid resource loop-local 'struct resource *res'
declaration further down in the function, triggering a compiler variable
shadowing warning:

 drivers/pci/controller/pcie-rcar-host.c:357:34: warning: declaration of 'res' shadows a previous local [-Wshadow]
 357 |                  struct resource *res = win->res;

Fixes: ce351636c67f75a9 ("PCI: rcar: Add suspend/resume")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://patch.msgid.link/20260521091256.15737-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index 213028052aa589..cd9171eebc2891 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -346,7 +346,6 @@ static void rcar_pcie_hw_enable(struct rcar_pcie_host *host)
 	struct rcar_pcie *pcie = &host->pcie;
 	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(host);
 	struct resource_entry *win;
-	LIST_HEAD(res);
 	int i = 0;
 
 	/* Try setting 5 GT/s link speed */
-- 
2.53.0



