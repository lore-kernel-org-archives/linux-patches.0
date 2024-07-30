Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED42B183CC3;
	Tue, 30 Jul 2024 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360583; cv=none; b=hiEJT2v+crJmnGO1exnh1RQSgZZ7NIq8hCdHvrFPv1bYBCO4u4yC7P5baRKBhJwdoyhUc+WRnebW8NU8Uw1ar0H64ZmAmkvps1qpJ5rRgs12POBiS7WCKkRA3f19Z1esh0I1GOh9I22hSDrwyYIZUOqKYwfrhl9CdZKlJpLsLWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360583; c=relaxed/simple;
	bh=5H7mFHTjYcri3oZ0L2Nncx9ORULhhESa4i6ZI9mIQ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzrbhmwTZ40T/tQWT06D+X2KS2GSaCjMuImLZAx2yY1TtkjFi5ZiEtvwCItk8fy8RdkoCpa+VThQELhRzedFgyzwppriEOq0wAMdw83rOCSNcmRNcR1gXnSjX2FG+hM/2KAgaONn5lvVYgEN1LSxgx7Mkwk1ceppd2j/9ptHmy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3ZtTGTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3ZtTGTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641A9C32782;
	Tue, 30 Jul 2024 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360582;
	bh=5H7mFHTjYcri3oZ0L2Nncx9ORULhhESa4i6ZI9mIQ0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3ZtTGTLiA7OvTodZAk2vWf2zGPWUXqARJ7b54clu15bf8rb4ck70iGVBwwvcjzuw
	 TlTltfx60ke7cCvPv3o1UPrSOvu+eQSQO3YzDqVc3kQlZB/cnC99UMObo1GJPQZlJm
	 f0QrcnyVv2LberqFVPQx/no4DrwX2q3ZcK+q8o4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.10 726/809] MIPS: Loongson64: Remove memory node for builtin-dtb
Date: Tue, 30 Jul 2024 17:50:02 +0200
Message-ID: <20240730151753.613277074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


