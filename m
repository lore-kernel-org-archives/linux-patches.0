Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324243D9DBB;
	Mon,  4 May 2026 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904558; cv=none; b=XI9iTyaQZ9Mq11t20dKs1P+kGd8ApWFJtDbKzSVUevNINsPgACEiXS3CdEX09qTOal86w//f2Co7o+5lCi8H8mkRE0HJeC3iZba8dcVEeQu/kR1h8iX5KEUId8P9tUyEQTznu/aA7tl36VmJG2bJ4U/tAmlE6+gLH8kTKYSBXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904558; c=relaxed/simple;
	bh=lEx0UlY26muFrkRT44Zvif6Vlq63AXO/xUU2myDgYd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtYz/9luhw/tgI0ep1RRUv4RXuYBqDVcwkmxuHNIcKtF2o5loWdWbKzB0w1C5DamQxTvjlW+TFjpBRyb00+SkXCdpH2Fa6vDWG1JFG/HKjpGVRiLGbVJtd9F590B9Rv5ht/eot7mLPoPulB0IBf+Dm+ZsmBhh5/TgMjNjOQ7kbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX9tAk02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX9tAk02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA673C2BCB8;
	Mon,  4 May 2026 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904558;
	bh=lEx0UlY26muFrkRT44Zvif6Vlq63AXO/xUU2myDgYd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX9tAk02FUAFb1cm28oFpcBFdmduCOAktbOcYolgpjjuVKrS1tHCqH5cOvm4t7oWz
	 nIvTR08mouwRZSR0XRassowll7kXEIeCnAzCi0X/h7k/zen3ZrKpeILWMGIn5KWE3s
	 ZK4u2JTZoIfM2t/fL3+Acg+vx2w/+m9Jipd71WVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.12 085/215] arm64: dts: marvell: uDPU: add ethernet aliases
Date: Mon,  4 May 2026 15:51:44 +0200
Message-ID: <20260504135133.266264429@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

commit 38f09c97340cd23f976242e6cb1e7aa4c8ed28d0 upstream.

On eDPU plus, which is an updated revision of eDPU which uses an external
MV88E6361 switch we are relying on U-Boot to detect the board, and then
enable and disable the required nodes for that revision.

However, it seems that I missed adding the required aliases for ethernet
controllers, and this worked as in OpenWrt we had added those locally.

Cc: stable@vger.kernel.org
Fixes: 660b8b2f3944 ("arm64: dts: marvell: eDPU: add support for version with external switch")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
@@ -15,6 +15,11 @@
 #include "armada-372x.dtsi"
 
 / {
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+	};
+
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};


