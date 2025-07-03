Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008A42ED86F;
	Thu,  3 Jul 2025 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553945; cv=none; b=khQOEbHIxWdQWdJnmqH66Y2LbjQ3KuBDArE4ZMgMA20BEzOJtmDw9KTkJx7W6wct/nl6YkpdGlYWazg7ypO67rKdv1Md8uvrjQhnPfXsMjMzBaWQ1Q/L49UwPwvKlRlU2N7dZjL+3ZmT/VAKN6wl7l/ibLrCGMA0QtCtegeo4Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553945; c=relaxed/simple;
	bh=41HttYmQNZrR44rZn9KkRuwN/qxCngmvHPk9yycEgf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9VtEEVVQlXqA56yNcYiq2zWNAX9/mMIQdX7E5nAaVi7a7m2zQreRWHlWEt+rvK6Z/OQCxKZ6NF8o3qk23vz012PcEe+KZrP42tDIinzK+mY2ZMKBQeyqqrCOxK3mdt9+f7yo9Ewzguh96yqTZ3JRTl3EMf0nNDiCDcI0Hl3wYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dikWHS4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dikWHS4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B226C4CEE3;
	Thu,  3 Jul 2025 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553944;
	bh=41HttYmQNZrR44rZn9KkRuwN/qxCngmvHPk9yycEgf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dikWHS4clXilllaOBpkUfiLMhifMPBXJFaBZJdLKijAd0MfTnzLEfsmIDYy42jSFz
	 t66ykITPCZ+VdpG3K2L4bFF7J59hwY+h6skjLCIBY82dCI4vBeKKe0zRQVl+WvKFKT
	 QC1dhYcWXk3CeVyeMcqh64UZes9jOPXQdl7Cmg1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Marc Zyngier <maz@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Janne Grunau <j@jannau.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/218] PCI: apple: Fix missing OF node reference in apple_pcie_setup_port
Date: Thu,  3 Jul 2025 16:39:32 +0200
Message-ID: <20250703143956.934156275@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 7fa9fbf39116b061f8a41cd84f1884c545f322c4 ]

In the success path, we hang onto a reference to the node, so make sure
to grab one. The caller iterator puts our borrowed reference when we
return.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Janne Grunau <j@jannau.net>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://patch.msgid.link/20250401091713.2765724-9-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-apple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pcie-apple.c b/drivers/pci/controller/pcie-apple.c
index ddc65368e77d1..7f02fe198d41c 100644
--- a/drivers/pci/controller/pcie-apple.c
+++ b/drivers/pci/controller/pcie-apple.c
@@ -585,6 +585,9 @@ static int apple_pcie_setup_port(struct apple_pcie *pcie,
 	list_add_tail(&port->entry, &pcie->ports);
 	init_completion(&pcie->event);
 
+	/* In the success path, we keep a reference to np around */
+	of_node_get(np);
+
 	ret = apple_pcie_port_register_irqs(port);
 	WARN_ON(ret);
 
-- 
2.39.5



