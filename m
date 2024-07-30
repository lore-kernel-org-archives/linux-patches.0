Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616C188013;
	Tue, 30 Jul 2024 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358268; cv=none; b=JlEp+9w0edcTkH1V1L6i/90DBE1qZ/M09+bDYC5I8OFcnsl5jtZYWPCeXOfTr0NYo5e9X3cTAyK+9NE7IcARG281QbuN0RBqUqO2A5czTO5lNrdozIHlbc7ypRzGTnWWWXtzC8Vs8wvQwYzuS2I/zNN1REKDw7GzNoOVFJoOaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358268; c=relaxed/simple;
	bh=2ikSJH36PU5tTzTtV13uRdKzu3z9/YgWSALPtOrNkjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMJZclayn7IFZsPQh0F3ElZTI2yUNRFwQrztm2Qgnpmou5VsYn39wrHN0LbEZF5xwS05wxczLw55G96lMFLpQE/z1TLbxOfXR7qqMISqYjhPLgWLjfyGne/535avRdmCD785x4M15t2lS3CyKkIgaMmkN0lv1sOyh8l0ZcLQ6eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNwAqCK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNwAqCK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E686C32782;
	Tue, 30 Jul 2024 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358268;
	bh=2ikSJH36PU5tTzTtV13uRdKzu3z9/YgWSALPtOrNkjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNwAqCK9yPOLu8r6OGUMMTWo0NkVW6Ok6CI+YaCPiErCS0VY112FfM38vIQrBBAVD
	 Pfg4nNgT8zBfHmBaurBbye+lQh86u905Xl78myiwWAUEIWo/SUio4AS/8k6YdY0iqo
	 V76qTi3eyDj/ZszL6VtULc6KnqvB9g6BitWAdc58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 372/440] MIPS: dts: loongson: Add ISA node
Date: Tue, 30 Jul 2024 17:50:05 +0200
Message-ID: <20240730151630.344518353@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit da3f62466e5afc752f8b72146bbc4700dbba5a9f upstream.

ISA node is required by Loongson64 platforms to initialize
PIO support.

Kernel will hang at boot without ISA node.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -52,6 +52,13 @@
 			0 0x40000000 0 0x40000000 0 0x40000000
 			0xfe 0x00000000 0xfe 0x00000000 0 0x40000000>;
 
+		isa@18000000 {
+			compatible = "isa";
+			#size-cells = <1>;
+			#address-cells = <2>;
+			ranges = <1 0x0 0x0 0x18000000 0x4000>;
+		};
+
 		pm: reset-controller@1fe07000 {
 			compatible = "loongson,ls2k-pm";
 			reg = <0 0x1fe07000 0 0x422>;


