Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FC1145359;
	Thu, 13 Jun 2024 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280418; cv=none; b=Zm492sA8xlxFpsbDJ0jicgcJYuZLrtStSCzSwid16fLR1AWtmE19BuY8iMlFhOhpEVmiAhNcaJi2hY+oolPVMccCUToGnsgBWVE8xjt31XAxGG64kEmcYC9ldi8gxkNfuUycbu/hMqGj6R9fFnAL0aMR3EokLQGbtIchyMwmeAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280418; c=relaxed/simple;
	bh=1QLKXnrN1J21W1TcIK5to5pqhe0LXu+DJ3TXRV2gIAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaCNdKykiSuJHVyJCop/HPFBR66PGfKit7Nu9S468IwqXjkA4rfNwl4GC7S/EZsZ+YeEXwcsgS19sxaZ1nH+PsE66Npw27FstYz0malDFFak1VIRSHxS1El/10FSi3ljEhsxQQuJ6PYm8HStd7fT2aa1Nh9dkIqtBc9U83QZ4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhT9wVGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhT9wVGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538B0C2BBFC;
	Thu, 13 Jun 2024 12:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280417;
	bh=1QLKXnrN1J21W1TcIK5to5pqhe0LXu+DJ3TXRV2gIAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhT9wVGQXS0k0I7JSSwY97JLLRYMrPzR2bC0azJDmKNmQ5yNrqtAFY8wJfct8Q+1S
	 BlZ2AJ2cV7iXmbAw1bFoIxNNdFt++GZWqh/pTTY+W+45tBuvAIsDoMfTWwv9WrRQyb
	 xIoC3EKA2AMrud0Rn998Hkrk5pdizVfXbzOX6dcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.6 039/137] arm64: dts: ti: verdin-am62: Set memory size to 2gb
Date: Thu, 13 Jun 2024 13:33:39 +0200
Message-ID: <20240613113224.806327041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Krummenacher <max.krummenacher@toradex.com>

commit f70a88829723c1b462ea0fec15fa75809a0d670b upstream.

The maximum DDR RAM size stuffed on the Verdin AM62 is 2GB,
correct the memory node accordingly.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Cc: <stable@vger.kernel.org>
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240320142937.2028707-1-max.oss.09@gmail.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -60,7 +60,7 @@
 
 	memory@80000000 {
 		device_type = "memory";
-		reg = <0x00000000 0x80000000 0x00000000 0x40000000>; /* 1G RAM */
+		reg = <0x00000000 0x80000000 0x00000000 0x80000000>; /* 2G RAM */
 	};
 
 	opp-table {


