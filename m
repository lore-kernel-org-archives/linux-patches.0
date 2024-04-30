Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD212C462;
	Tue, 30 Apr 2024 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474997; cv=none; b=M6VaEpvE71puVYE2WFWNW/DDqdUEQfASIV4ASPhc6JCHEm90c4mdpu+DE6QOZrVL34xj262hpojhKiXIMxu5ZLU2yH8bDygaXt1teZ95oKGJf46qSEq8THcfqzcwlxXcsR7+vPnIdJfYa3D2EF6TaY5kcXc6ZJobYO7zI4rlfuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474997; c=relaxed/simple;
	bh=fS+ZIRFatC4u1ekKUpY9bz+tjAblmsJqQ4kib4HTMi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvCo+165/m0bue8BT3xuRgk13B57UdW3izc61tXGe7wh/2VCqP/c20jeKsKOSAv2BmDB/mLcnlacQKfCzYvCiJY0ug+F65UUt/h0nY6/Nvz8EuFuulmzPqJGrJu1nR3RqsVs0HqH4J1tM8EsP9Rvbr1OxrCB0fHDzAmO+6rfFRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/jew75F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/jew75F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1A2C2BBFC;
	Tue, 30 Apr 2024 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474997;
	bh=fS+ZIRFatC4u1ekKUpY9bz+tjAblmsJqQ4kib4HTMi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/jew75Fnq2bvbpYMWSaEFQrMEHW1AqcYhZeu/2CyYJ7gQH/rJ5L0/SKq29ESOYoh
	 yWPSfGFnJyBpQNF7+cjlLWORsscOfT6ZwYAz01AGjvtZgQTx/Zx1eNcEPhb9ab3F9r
	 +rEQveMVkzXqh8U7lvqOAVc9ag2QgOWn8b0PDczU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@kernel.org>,
	Alexey Brodkin <abrodkin@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/138] ARC: [plat-hsdk]: Remove misplaced interrupt-cells property
Date: Tue, 30 Apr 2024 12:39:28 +0200
Message-ID: <20240430103051.864727790@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



