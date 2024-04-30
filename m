Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E26912D1E8;
	Tue, 30 Apr 2024 11:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476403; cv=none; b=QdwSJSWON7tzCJ+xja6ub4vlO/Dqj9mNBUOl2GLkTyAxLFuG4imIDSFiJllYYie+8o0yZTWSrPXBY4oV29j+eXQwxNnAVDs+ZlUqVFjdncEKcj9WygiG2deUTuCjq6NbUw+ehUlmt7nsYfQynUSqpW6YjyrtHI/aO2N2wdJhZbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476403; c=relaxed/simple;
	bh=K5jMSKXyQxo5SjfqiBeJFSpbcRin/32n7WpUzxfMN8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7CgJ97x8Z7Wd0AkMq+vW+DObUg9aomSVItd+aeBUeSyL2O5AvYmkfsHcw2GNkEusdq92iMr/VYp55U5CcW10D8Z+XTgVmPnvkqo4TL69LPdsvUQRZWK2fICXmj5j2NXNBXOqn5TsxVFebC9jsxwxK9n8NEXwNmgRGVfXLicRx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E55kxxIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E55kxxIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896C8C2BBFC;
	Tue, 30 Apr 2024 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476403;
	bh=K5jMSKXyQxo5SjfqiBeJFSpbcRin/32n7WpUzxfMN8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E55kxxIpgcmiE5dS3zEhpx1KCvDL0bkO0OzqjG+ihhgJ/LHfJD1A3TLtJUYn4PWiC
	 +kzdWogG9oW9+fWPlKx6rsTbkL9mDeyIVOXslNRwL5zNcLrZnk9eHap/VeasF51Bqj
	 r6wkPSjtzCbvHxhpXQ55RRUOK3ELgNbvP/Wj42zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vgupta@kernel.org>,
	Alexey Brodkin <abrodkin@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/110] ARC: [plat-hsdk]: Remove misplaced interrupt-cells property
Date: Tue, 30 Apr 2024 12:39:51 +0200
Message-ID: <20240430103048.226122888@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6691f42550778..41b980df862b1 100644
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



