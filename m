Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963941A680C;
	Mon, 13 Apr 2026 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098450; cv=none; b=umJOcvVCMvjuweoEiBVA/1m3J9tZRBdcO8FJABVuzkJgUtBDVMjKRO+qtEWKtOyb7eiXFpsIu1sOxd0dCYrgEECZoIJ/fsvlS1vPcZb/K/+JDMRlApVQDMy5qeW1nnXvV+D93iEvDr3uoZuKtiTk8pQ0W56gsIfdyotHiY3y7TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098450; c=relaxed/simple;
	bh=R89FWWnWpxv8DE0pW188ZQ2YhuWw09qZQIrGYclp704=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kV9FkDAF0UO5vcAG45nET2gA5Fuocs44jjHBb1CEyc9HhUaZwVNDOHZWqrS+zQczstBXieAH1M13Ng24naiO5j/An2TFNPBq/5vWz8DF2enWV0UfS/5LkX52HS6xNmnGHI1mRtGsnH7WsY2UmzonZY+MRX8bBnMvBWhVtrZX3MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4W/WGOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4W/WGOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFA1C2BCAF;
	Mon, 13 Apr 2026 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098450;
	bh=R89FWWnWpxv8DE0pW188ZQ2YhuWw09qZQIrGYclp704=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4W/WGOZcO4IGxM+rFJj+ma62GnLDvedhuHgMoN/W6Ewfr9sjp6CwlKkm8NgNzNP8
	 lzuqPg0VJFFjhpVrbhIJWeHvHe4kliHwNuQIIn5l5bZGb2wQMbwCJtdkvbpWS9mbbq
	 adtzh09g44SWNiw4bj3GmSEnoldf7o9YPw/ASXns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 5.15 529/570] arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity
Date: Mon, 13 Apr 2026 18:01:00 +0200
Message-ID: <20260413155850.263980455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


