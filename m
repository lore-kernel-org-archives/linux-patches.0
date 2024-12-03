Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A11DA3D;
	Tue,  3 Dec 2024 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239143; cv=none; b=t/FBmYIES/t2uqOqc+9s+4B/ZfmnOyniiRLAA/BXhHYWFxJqHiBjVc0BZWS4vZ2nOuH2VGTtxbF/qmO9SkunD7wXVE5kk00mJJyzQfDdbEq0ZWbI4STl6f8hCPSW3nsWlqs3rX2nbyNbl3sV6uIWt4rCMrGEPsAqfZW01IGCKgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239143; c=relaxed/simple;
	bh=+bsHvGcib7yfl9NrcxdzPCmOt6JTLPnKsUubMLioqxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4tHFHm8+mgPMEYXxQc/jyiBc7O42+cmgFOyMos8aNnzf/JP4+Q+/RBBTHaLUgK7hjbZ0eogq6MBSgEU6Tvw2WBHG2bs8yqdQV26+QSrvQEENbQwsmQ75ImVesnbjItM9CFlZhEaagbzp9AzTZXmHuOiG29dymfus2susBog6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aX17n16+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aX17n16+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DFCC4CECF;
	Tue,  3 Dec 2024 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239143;
	bh=+bsHvGcib7yfl9NrcxdzPCmOt6JTLPnKsUubMLioqxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aX17n16+NtOUsqkSnNt0lLeh3YMZY8acaawJyGZQo4idBS625sXixnmrKNKZwnG8E
	 ORTa6zqacNqY9VwODvXpLH+gQEy9oGngl+xENlP97m60fGoiYTCNThxQX+9O2cxlpm
	 MyAc5edo6kKhNzKsTIhKR+8z3nzomr+8dJja0RHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 518/817] PCI: j721e: Use T_PERST_CLK_US macro
Date: Tue,  3 Dec 2024 15:41:30 +0100
Message-ID: <20241203144016.113357129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit f96b6971373382855bc964f1c067bd6dc41cf0ab ]

Use the T_PERST_CLK_US macro, and the fsleep() function instead of
usleep_range().

Link: https://lore.kernel.org/linux-pci/20240102-j7200-pcie-s2r-v7-6-a2f9156da6c3@bootlin.com
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index d676a4ed57803..963b66b6a6832 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -542,7 +542,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		 * after 100 us.
 		 */
 		if (gpiod) {
-			usleep_range(100, 200);
+			fsleep(PCIE_T_PERST_CLK_US);
 			gpiod_set_value_cansleep(gpiod, 1);
 		}
 
-- 
2.43.0



