Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04604384CD6;
	Tue, 21 Jul 2026 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653982; cv=none; b=Dhy4Z5HBn8lnH31kLgC9c/b23P5+DcAXL8XNXbIG+86/F0IrstCbcDTzc84LRnVOtL1bwdRmQH+z2pCprXt2Z26Gstp1YiqFT/QRIP96KDo7tPmUyJMhTX2u95EYyN5ljQvP6AholtXRAokuPFOV2tDzJk9Adz0k91N4RhOJR6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653982; c=relaxed/simple;
	bh=69dG9k+fw+lMRYXnXHLDT3+R3a6/hecgzK83RFh957g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nen+fRSnRCaTAo0ze5jBCGN/mlUY3gfXbRv++D1uWBaMCqlpFSRE/lKGGcKFQ5LlvpGxNw/c+CKXO1LOdocEG8pZTL9POtq/GrERuTyZnQvfFzck5ADdqv75zAq8SZN89llqRHNPM55DQOTqzp4i5hbyTOis+wpNqFhIkg6MhHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwNDmeMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwNDmeMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926AF1F000E9;
	Tue, 21 Jul 2026 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653980;
	bh=50hqhgwAujOai0U2l3NGtlGihD8Qet9yTeparS2E9xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwNDmeMKgf5Rhz0oYKv7Gm0bddi3QhoUqZJX0Se9MJM7UiXrWeSoPaMIGWjpnabC4
	 p2lCiYYA6uqzt1QbR3Seq8FdUgA6bLncACimQCxunRQBoGKP8QRM1wZQCOryvY8d1S
	 sIDdHOL64o3tcQyRbrmoNQjnnEazmp+3SLSyOV/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 7.1 1533/2077] arm64: dts: renesas: ironhide: Describe inline ECC carveouts
Date: Tue, 21 Jul 2026 17:20:06 +0200
Message-ID: <20260721152628.936766209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit 6fa6ee724d8dadf392139e242ac936b5da730c4b upstream.

The DBSC5 DRAM controller protects DRAM content using inline ECC.
The inline ECC utilizes areas of DRAM for its operation, which are
in the DRAM address range, but must not be accessed or modified.
Describe the inline ECC carveout areas used by the DBSC5 controller
on this hardware as reserved-memory, which must not be accessed.
Include DRAM areas which are unprotected by ECC as well, those are
parts of the DRAM which directly precede the ECC carveout.

In case of high DRAM utilization, unless the inline ECC carveouts
are properly reserved, Linux may use and corrupt the memory used
by the DBSC5 DRAM controller for inline ECC, which would lead to
the system becoming unstable.

Fixes: ad142a4ef710 ("arm64: dts: renesas: r8a78000: Add initial Ironhide board support")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260710160450.64967-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts |   41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
+++ b/arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts
@@ -93,6 +93,47 @@
 			reg = <0x0 0x8c400000 0x0 0x02000000>;
 			no-map;
 		};
+
+		/* DRAM controller inline ECC areas */
+		ecc@10cccc0000 {
+			reg = <0x10 0xcccc0000 0x0 0x33340000>;
+			no-map;
+		};
+
+		ecc@12cccc0000 {
+			reg = <0x12 0xcccc0000 0x0 0x33340000>;
+			no-map;
+		};
+
+		ecc@14cccc0000 {
+			reg = <0x14 0xcccc0000 0x0 0x33340000>;
+			no-map;
+		};
+
+		ecc@16cccc0000 {
+			reg = <0x16 0xcccc0000 0x0 0x33340000>;
+			no-map;
+		};
+
+		ecc@18cccc0000 {
+			reg = <0x18 0xcccc0000 0x0 0x33340000>;
+			no-map;
+		};
+
+		ecc@1a66660000 {
+			reg = <0x1a 0x66660000 0x0 0x999a0000>;
+			no-map;
+		};
+
+		ecc@1c66660000 {
+			reg = <0x1c 0x66660000 0x0 0x999a0000>;
+			no-map;
+		};
+
+		ecc@1e66660000 {
+			reg = <0x1e 0x66660000 0x0 0x999a0000>;
+			no-map;
+		};
 	};
 };
 


