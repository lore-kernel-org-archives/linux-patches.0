Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31EE378D8C;
	Mon,  4 May 2026 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903270; cv=none; b=ANNXt2weI/by/qWAvJbT4vIQezK9brdkdRHFylEkcJStLNfvnutdcEHT2Rh54XovxY8G0ku1cDMRp5ocSq4S8+JYzy5/6OvIRd1UO3gZCwbgdVq4Ns7LaV5x1obl8ZFvhLKrnQmphPBSmJr+vvrVSd1NrsUEF7fkQzR+A3m/cmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903270; c=relaxed/simple;
	bh=inzGXicLpNQufHI6RVR3fs+XHyVmg0epJwQwThx0E50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HapHD+Q+rpW+QRqaFYoPTxnUgJACNiMi5s0bb4J0pxd8XH+lXrBByHi85zjVsGDIt6FW2ULrSuE0TwM4G7Dk4kToR0NO63+BdSHNcqSDRTcXVzfkaHsLta9AYylSAzr7j6PByLTaYaFAGx8D0SVgeZNiwFrI5Xw6lSfimNRt+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LKKQVAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LKKQVAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A84AC2BCC4;
	Mon,  4 May 2026 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903270;
	bh=inzGXicLpNQufHI6RVR3fs+XHyVmg0epJwQwThx0E50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LKKQVAR/zIfqJxTloYKU7DV3XFhgdayRgsmgpmYetFiStgv5xuNKmMoFwlM4CQ9U
	 /TNDs5j7eWofMNflcA/b6n5bABQg3mz1N6MQ9zqrvajfKOvLxrC3GEzQeNEPpVnjot
	 QZkCoU2pbDkqe4zcvMEZ8jBNMXUPNau46BKOAq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 7.0 136/307] arm64: dts: marvell: uDPU: add ethernet aliases
Date: Mon,  4 May 2026 15:50:21 +0200
Message-ID: <20260504135147.903798170@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


