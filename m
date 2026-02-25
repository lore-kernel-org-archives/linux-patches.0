Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AB22E401;
	Wed, 25 Feb 2026 01:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983015; cv=none; b=caovZML6WeIf0vDdS2KOEj1Yef80pF10uyVDPecUkprb2lbGCbRI0qqfrhA4A5KuVpiyB26U/qF8+AC9P9bkE/tEDRr8GCppb/WE2t3bh61PLEwSB1RFJpdWWoLEOyRmB5QqWAXqA3wk0HDV6EAvDYNdjjeLy5SdCqrPw99clgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983015; c=relaxed/simple;
	bh=XNg7D7+Gxks/F2XK4gofHt7q5jWNxTEBSnpQkF0vjts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLW9GVc3nvKk8KD22xxCUJ0VFgYQs2d+RaALLSptEX5VRnEckR4BNJChPmPUWpbMYSUIb05xn5jXFd2nsPxRlZJVZ3LYFslA3E12h9MK65G7oOkheP9jKVbqApCupu813RnFXRWt3I/RfLbZAINj3+F7ccNsLGw+vQRsYRKE3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9YmNFXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9YmNFXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42032C116D0;
	Wed, 25 Feb 2026 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983015;
	bh=XNg7D7+Gxks/F2XK4gofHt7q5jWNxTEBSnpQkF0vjts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9YmNFXg4KhJy5hMLDxY6ffrnGSSkA2rjCVOWGz0YRtcWZ8jgWagNsY8mytxaZ0zB
	 3BLNVrQsS35lUjPeqFrCpUSuBpd+R6ym5TaGqcxi0CMbo6gJZ4CuVTd6bMOJjvv84f
	 nsJ8/3WXzaeombdx8lDwAEcF5FczAhJJabCM6HHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 183/781] arm64: dts: ti: k3-am67a-kontron-sa67-base: Fix CMA node
Date: Tue, 24 Feb 2026 17:14:52 -0800
Message-ID: <20260225012404.134279191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 11a6a5bb72ce271de24330fd859e83f7bc281609 ]

Fix the size of the CMA node by making it a 64bit size. This was
probably a copy&paste mistake. Also drop the unneeded alignment.

Fixes: 1c3c4df06f9d ("arm64: dts: ti: Add support for Kontron SMARC-sAM67")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://patch.msgid.link/20260115131431.1521102-2-mwalle@kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am67a-kontron-sa67-base.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am67a-kontron-sa67-base.dts b/arch/arm64/boot/dts/ti/k3-am67a-kontron-sa67-base.dts
index 7169d934adac5..3be6c6d19def5 100644
--- a/arch/arm64/boot/dts/ti/k3-am67a-kontron-sa67-base.dts
+++ b/arch/arm64/boot/dts/ti/k3-am67a-kontron-sa67-base.dts
@@ -85,8 +85,7 @@ reserved_memory: reserved-memory {
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
-			size = <0x10000000>;
-			alignment = <0x2000>;
+			size = <0x00 0x10000000>;
 			linux,cma-default;
 		};
 
-- 
2.51.0



