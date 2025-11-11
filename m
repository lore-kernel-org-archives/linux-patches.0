Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E6F248F6A;
	Tue, 11 Nov 2025 01:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822929; cv=none; b=tbP+pybONlQsKcGMFao+GXJaS7vjsMxGCFjIl9OBPVWVN0EEo/4lTkqv1COVS+UA0HOI9ajpBQx1JkkhJtN90BSSFRz56YLxnQdt2TwWqxTuMZqAMQvN90kVhVh44jr/Twi6bEhucr9D9FdWRK7GOFpzuz/IyVxb1uYfw45lZx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822929; c=relaxed/simple;
	bh=RL5yLuK8hof4bJtTCCN5YDqro/v7FLVms1zxVRuK7iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vhc/LZOi/hixHHxSafK2dQYPGfYpZ1rhioLH8vUKW+Zo4BIAOSZBgHJsNgSlxdjaWoa7kf8hbihX9B7roZ11r3iWPBdW1+Bfk5n+ZPOy4M5v3wRto7h0t0jt1imaoyv1FCc257IBZ4lTQemGfV9gdXG34r55yipzCFbG2v6bMGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7cUr1ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7cUr1ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1347C113D0;
	Tue, 11 Nov 2025 01:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822929;
	bh=RL5yLuK8hof4bJtTCCN5YDqro/v7FLVms1zxVRuK7iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7cUr1eagH9MWuQuIbum5QTpt8I0C3G6pep2KKZrm7NePlXW2OjJfIUyQFTitkCCp
	 AXmsRJ/XRker0tRAkL8GABT/lbbmJ9ujWWqhSYiJBxJjoDRlExoMrjRcmoWewoH0mt
	 6demHMN391Tp1Vb3HPb4yYaIWxbm5H4hjJU4NeUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 198/849] spi: rpc-if: Add resume support for RZ/G3E
Date: Tue, 11 Nov 2025 09:36:08 +0900
Message-ID: <20251111004541.226350490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ad4728740bd68d74365a43acc25a65339a9b2173 ]

On RZ/G3E using PSCI, s2ram powers down the SoC. After resume,
reinitialize the hardware for SPI operations.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20250921112649.104516-3-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 627cffea5d5c7..300a7c10b3d40 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -207,6 +207,8 @@ static int __maybe_unused rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
 
+	rpcif_hw_init(dev, false);
+
 	return spi_controller_resume(ctlr);
 }
 
-- 
2.51.0



