Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5DE1448DC;
	Thu, 13 Jun 2024 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279310; cv=none; b=HJCaMi9FnRD6dWqvv4vxRM3CtoA/HDjtc1vUrhWniqH+3ekt6f4E6AedxDgJdT8RC/clb9sBOb6DbKkMfpj4bneypCdJnB5noGVaMNSpr7E/cpypfSrw88zr8x7RBMYuB2z8vDL1sAtrDPqLgTiLcwxsHOW+zbz0Rijd0d5OLEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279310; c=relaxed/simple;
	bh=CkUH9wZW0gK7yexNJKA44NHguSee+evmv2QmaztJs78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxQgwsoBIcRJi72rkO4HfLKA1Zxry3FTJ3cymfqBpXQNrHB+EF9DKy1y3ZbcshoJF1T6TTei4VTI088cdPBhN+Kr4QbnAogALEATLAG9SzaEzEB4HoywzIKqmKh6ZPUd0PVscXjCswKk7PKbtFnWMTTWTZN9bEHQhYigRQD4syY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goJpBW1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goJpBW1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285A4C2BBFC;
	Thu, 13 Jun 2024 11:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279310;
	bh=CkUH9wZW0gK7yexNJKA44NHguSee+evmv2QmaztJs78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goJpBW1UwNa+71AP90fsFF+9Go+iTGiRtaquMqwR/HLqVD2zGsR97zb2XbInSCVmU
	 9HhFta170SvtCn5XWkZ7gk39MUqUQYBtgn4XNoc63hccwgBMj0jAff6YaGooiMfO1E
	 WNt07h/Fu6d37s0Hs/LSoNKXGlnewBvOsP/WHlYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.9 033/157] arm64: dts: ti: verdin-am62: Set memory size to 2gb
Date: Thu, 13 Jun 2024 13:32:38 +0200
Message-ID: <20240613113228.699005458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -76,7 +76,7 @@
 
 	memory@80000000 {
 		device_type = "memory";
-		reg = <0x00000000 0x80000000 0x00000000 0x40000000>; /* 1G RAM */
+		reg = <0x00000000 0x80000000 0x00000000 0x80000000>; /* 2G RAM */
 	};
 
 	opp-table {


