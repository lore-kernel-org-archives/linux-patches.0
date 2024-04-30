Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5618801;
	Tue, 30 Apr 2024 11:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475784; cv=none; b=hVBmKab/6hW/hT7tnpinQ53lAVk6SAOSCE0zDnPsC9rvK0Wyy4abQ1ZxDwXvqYXvFFPOq6ndtTA7tozMeMoTKcNkMcoA4g1kkF/CxP0rMFlRdOBFObxeKBw86+Wt/qIEfhBeodfMDlPamNnANafOrSZ3po90+5D+4dybrvQHTzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475784; c=relaxed/simple;
	bh=dxDS2Uaa80moevLR0eouSHzLcmfKW+NyYYr8XD0K3V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsIRsf9FWznejqMyPkxqt/CV7gc9ynSB6Iia/W92u4Hmx/CaJ/uNJ7aoz89dEPqv3oFdQf5JqTi0LcVh5NDZPlmEyTUAzIJpQFkGemEaXfZfKbsdkPCJ0b4nOPmfO01VtW95v4Ib9sSBZWO6DFxoblw0AL0oPWzzJJDN8Acz0ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7+SvIME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7+SvIME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22EEC2BBFC;
	Tue, 30 Apr 2024 11:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475784;
	bh=dxDS2Uaa80moevLR0eouSHzLcmfKW+NyYYr8XD0K3V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7+SvIMEwmR7z5vPKpWxjikQdZ/Sn3Uc2IWO3cUbk2dUACP4pYOyZPt6SIgUY9C61
	 R3O0T+pRmbBl8iY38raBUl/qdPon7cANpz3sOJjr1hBHiUJP/MXf4jlsdJ/V5ytNnO
	 8qt/nCminJyLT+fdfYvR7r4G0JyryZ1xxaFFrigU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@kernel.org>,
	Alexey Brodkin <abrodkin@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/80] ARC: [plat-hsdk]: Remove misplaced interrupt-cells property
Date: Tue, 30 Apr 2024 12:39:49 +0200
Message-ID: <20240430103043.922012072@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>

[ Upstream commit 61231eb8113ce47991f35024f9c20810b37996bf ]

"gmac" node stands for just an ordinary Ethernet controller,
which is by no means a provider of interrupts, i.e. it doesn't serve
as an interrupt controller, thus "#interrupt-cells" property doesn't
belong to it and so we remove it.

Fixes:
------------>8------------
  DTC     arch/arc/boot/dts/hsdk.dtb
arch/arc/boot/dts/hsdk.dts:207.23-235.5: Warning (interrupt_provider): /soc/ethernet@8000: '#interrupt-cells' found, but node is not an interrupt provider
arch/arc/boot/dts/hsdk.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'
------------>8------------

Reported-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/hsdk.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arc/boot/dts/hsdk.dts b/arch/arc/boot/dts/hsdk.dts
index dcaa44e408ace..27f4194b376bb 100644
--- a/arch/arc/boot/dts/hsdk.dts
+++ b/arch/arc/boot/dts/hsdk.dts
@@ -205,7 +205,6 @@
 		};
 
 		gmac: ethernet@8000 {
-			#interrupt-cells = <1>;
 			compatible = "snps,dwmac";
 			reg = <0x8000 0x2000>;
 			interrupts = <10>;
-- 
2.43.0



