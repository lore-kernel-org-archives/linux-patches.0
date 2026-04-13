Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C09257844;
	Mon, 13 Apr 2026 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096359; cv=none; b=qKe5wwtouPXMTHyJVw3aj+PNBhbamiV/FWdJDjq5qg1CjCAXpA6kUFWNL1nYDMyxryImWz7mT2w7M93L0xQ4HZixVkub+hflvDCj02uXHF8Ie/Gj9WGD8hhAlEbjz95DN1GxN8njGahy22vK48trrXkBe+5WTCcCYncWyqwLVSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096359; c=relaxed/simple;
	bh=bDg7gu47Ps3Gm3RQZwq+/bxlXIqpkikYyouEAKsBDUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv9I2APLHEW7skG5vXVZQITEA15UvFd4GhnbKLOYAzQ5No+nkJN1HvpQkpqPs7hcMlcfXq/8MVHpt2QqfukmM34zXwXHuf4wTu6MYWY9h6N+f6rY4p+fwlTOOGevfm5LxuTLxr+JD+TtcLck+nLOavjlZ0SJRwSkuBBCzV80mwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaXIuv4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaXIuv4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E61AC2BCAF;
	Mon, 13 Apr 2026 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096359;
	bh=bDg7gu47Ps3Gm3RQZwq+/bxlXIqpkikYyouEAKsBDUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaXIuv4s2TnKh8+fwNSNPYZbBGmS8SMEPhyiBa/bLNC5tbqumeRJhzSBZmvqIn+Z6
	 uY0GqHC/Mh4XciqABexg5O+qvQ/7bJAL2WkW5WqnGbD+802saXE77hE0HWaH34U8vD
	 qO1ixIQ9AkBVIDPBjwDWElG6wc3h46g/214eVTjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.19 35/86] arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity
Date: Mon, 13 Apr 2026 17:59:42 +0200
Message-ID: <20260413155732.880029498@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawnguo@kernel.org>

commit c1f2b0f2b5e37b2c27540a175aea2755a3799433 upstream.

The PCIe reset GPIO on Poplar is actually active low.  The active high
worked before because kernel driver didn't respect the setting from DT.
This is changed since commit 1d26a55fbeb9 ("PCI: histb: Switch to using
gpiod API"), and thus PCIe on Poplar got brken since then.

Fix the problem by correcting the polarity.

Fixes: 32fa01761bd9 ("arm64: dts: hi3798cv200: enable PCIe support for poplar board")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
@@ -179,7 +179,7 @@
 };
 
 &pcie {
-	reset-gpios = <&gpio4 4 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&gpio4 4 GPIO_ACTIVE_LOW>;
 	vpcie-supply = <&reg_pcie>;
 	status = "okay";
 };


