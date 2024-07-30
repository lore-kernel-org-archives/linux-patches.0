Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C091A76D7;
	Tue, 30 Jul 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359529; cv=none; b=RJmn5Idu/vbA9wVPnF9Xq7shUtWO9RKeVsIXwrQa2tZIaiVxTxPxk+nxUVwsuA2ChCoQCpNZ8dgTWVe1JyTT43HDdyBTd6bovUF44PMfV3FObHKPp577LZST3J99sSahv9WfIMI5AmNISSoeLg153/zmYyKScBGte5FyGhmGRgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359529; c=relaxed/simple;
	bh=2bdAeBP6e6kuk0/V1g4w5g0U6dQ4338VhAI9LkC/66A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiJq4n9tyjeF13+92HiepvgklL9TLIy9nHDkwCRscW2mQZld05XA+2FwMEwxR4gsM5rnsWKapFUPaHQTijGqHsXHT55D5PB/r9gK6cSIlSWKGRXTfisj4sN3UZrAP5yNyksaHBxT/Ryk1Yfy84um+4xGbuQSGdMj4HT6XANgIWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM/xc5gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM/xc5gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F21C32782;
	Tue, 30 Jul 2024 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359529;
	bh=2bdAeBP6e6kuk0/V1g4w5g0U6dQ4338VhAI9LkC/66A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cM/xc5gDfFnrwWrNeJYCzX9xoHkYVMChYfITs6SQG5GlhSgqAPNTzRuapDWgUdxuL
	 XXLj+7tFrwoFHt2wydWzJqqIZYRyb5qfvtUHwlI5gJ+xyEN5Bflj5PgiBCZ9LhdRMQ
	 DZxfLAz45zRcbUxO57WRDwOHEcbKzje/DFBwF1ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 497/568] MIPS: Loongson64: Remove memory node for builtin-dtb
Date: Tue, 30 Jul 2024 17:50:04 +0200
Message-ID: <20240730151659.453198640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit b81656c37acf1e682dde02f3e07987784b0f3634 upstream.

Builtin DTBS should never contain memory node as memory is
going to be managed by LEFI interface.

Remove memory node to prevent confliction.

Fixes: b1a792601f26 ("MIPS: Loongson64: DeviceTree for Loongson-2K1000")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -23,14 +23,6 @@
 		};
 	};
 
-	memory@200000 {
-		compatible = "memory";
-		device_type = "memory";
-		reg = <0x00000000 0x00200000 0x00000000 0x0ee00000>, /* 238 MB at 2 MB */
-			<0x00000000 0x20000000 0x00000000 0x1f000000>, /* 496 MB at 512 MB */
-			<0x00000001 0x10000000 0x00000001 0xb0000000>; /* 6912 MB at 4352MB */
-	};
-
 	cpu_clk: cpu_clk {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";


