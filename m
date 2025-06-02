Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DA817BBF;
	Mon,  2 Jun 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876015; cv=none; b=BiZaGo8xR7/jsfka273mp1MGGvSK4S7QWL3NmTCfgseD3PXNS2EYxW1LcRUvWMSx8iWhtRhAoYROjtNLkdAet0oAgnYBDjQNyS4PnFuhkELIYlo+0ApHxaPAbJVrTdC+4cylumFOOPCKkSIHSZXjTctfpsJCoAF8KqFXm9AmVmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876015; c=relaxed/simple;
	bh=ApZ1TSSN11OenBNouWqQQRsi6zNq8Pb9+/xRP9XHulA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0pDl4QxgnzFv0QU+77sz7SZZLkojKEx5mumojCwE+5wPlTPtz2LOHtI9aSvGqrQP5pMmJPLvh1Jr0FZceNw0vODvXvaTabu38RD0fUFlL9sQV4N1+Xy2k2/89kK903iea5IELDTeHz+ALX634YEtDi9DUlzjbTfUmIOk4siWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI2dlK0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI2dlK0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF05C4CEF0;
	Mon,  2 Jun 2025 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876015;
	bh=ApZ1TSSN11OenBNouWqQQRsi6zNq8Pb9+/xRP9XHulA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI2dlK0NGqcDjBWZ+La9d5oCYPyOLJHXATbEDXsEW2cDI6fQrKu7vbflz4gatvB5U
	 8cDJrBWKzp7m0KIv+kojieT37HxjOcBkpiC1F2+UTLuAC8+lmSlB/aULfQRfjhfJVL
	 mwlqcJfU/8YSCMpvXTZDuoXvyl4209OzBV3HyNBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/207] rtc: rv3032: fix EERD location
Date: Mon,  2 Jun 2025 15:46:56 +0200
Message-ID: <20250602134300.482126342@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit b0f9cb4a0706b0356e84d67e48500b77b343debe ]

EERD is bit 2 in CTRL1

Link: https://lore.kernel.org/r/20250306214243.1167692-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3032.c b/drivers/rtc/rtc-rv3032.c
index 1b62ed2f14594..6b7712f0b09ce 100644
--- a/drivers/rtc/rtc-rv3032.c
+++ b/drivers/rtc/rtc-rv3032.c
@@ -69,7 +69,7 @@
 #define RV3032_CLKOUT2_FD_MSK		GENMASK(6, 5)
 #define RV3032_CLKOUT2_OS		BIT(7)
 
-#define RV3032_CTRL1_EERD		BIT(3)
+#define RV3032_CTRL1_EERD		BIT(2)
 #define RV3032_CTRL1_WADA		BIT(5)
 
 #define RV3032_CTRL2_STOP		BIT(0)
-- 
2.39.5



