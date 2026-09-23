Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D36377AAD;
	Wed, 23 Sep 2026 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173522; cv=none; b=Z2k7RRFp+UfARHAixcXGJzZH4pBXG5VIIaeNeK8Pkz83LLs04D40Q41QesvqgiHaSwtfH7TvWrydMoTCIZUrATVuhYDP7DSoSlQA+jRHYOIt5DOCcbFonBZbRa0t4uHKyDn8HfWIO4yO67RDxdimctPGuse8OsmdbKXUa9lonfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173522; c=relaxed/simple;
	bh=diO/mFQTyekd0/8UyoIWPkcwd+CnWSPI4D0ULYm0e+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec/3BhApLGiOg2t3IEjDuraxomXdxYGYldF43b/QCgrSDlcfpxvrQ8HHTb94SoYlMB3ZiljhlkjJAlh7FkPoD1sjjwFnuKcXRUB9XIIqaSTeoybQoiYFyyZZCsxwcpME11t8j2pH49g6k/IjQLJxLd9YCQRc0hTHciLZMV+Qz80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj5S8xTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj5S8xTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752281F000FF;
	Wed, 23 Sep 2026 14:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173521;
	bh=PgmkYMTG/niY1db/oB3Z34mThzBdWo2DJCJpAzQ/+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj5S8xTOexWxf067CZi/LDMTxzcp5mhgOzdDYCyAxo2pePEPzNCtmzOrOWAlmpp2N
	 YSXb4t+F2BOeXG9/LdfXE7du8LvEe1YDLD9YNN8A4tHekqrSY6CpPg4WV5ZtG/zNWM
	 6UHcGQSI4SI9rD4sMPoJWTY1PbrkUdgW9+v2gyj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.2 273/438] arm64: dts: socfpga: change access permission from 755 to 644
Date: Wed, 23 Sep 2026 16:04:54 +0200
Message-ID: <20260923140651.843806498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit 5f8cb07d7a8573753c5d31dc76b51cab8e5e9460 upstream.

These files have an incorrect access permission of 755 instead of 644.
Change them to the correct access permission of 644.

Fixes: 4bc04eb90b7c ("arm64: dts: socfpga: stratix10: Add emmc support")
Cc: <stable@vger.kernel.org> # v7.1+
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dtsi     | 0
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_emmc.dts | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dtsi
 mode change 100755 => 100644 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_emmc.dts

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dtsi
old mode 100755
new mode 100644
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_emmc.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_emmc.dts
old mode 100755
new mode 100644
-- 
2.55.0



