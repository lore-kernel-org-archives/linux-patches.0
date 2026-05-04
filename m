Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3336D35A3AD;
	Mon,  4 May 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903936; cv=none; b=k9oh+baStY4X4Ie0k1LKObOIa47iayKgjLNLUDbdF2UoYr7IfXGeSd8p3/7L5zIpQ+BkeMNpC6Co+FIEUV4qJ9Nd6bjwF1uWUxR3wdr8v0x/NsE9c0poAatg8j7evt6NwOOH2QEEH3tdsp9YKlVpYl7lv3BZJUF2hyR1BPj/UEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903936; c=relaxed/simple;
	bh=0te0Xg0GDDXSsI+LDqMgTcSFjRvwkkYO8px1yLDgtHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL7vK4l26jrRw6Ddztq8pQaLPi0fCRGTxq+I2f9EiF3tNNGI6OcS+DB5OqMjutnG6/aE0LT86BcEHwZk+LZxZashry5XID0FTMugr033s5/Pz/ZUVuqLXymHgErXPJiGl7AaaLdHZU35nQOwfR3COH8bryUlc50/ZIYuWXjpHaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdL047ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdL047ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88415C2BCB8;
	Mon,  4 May 2026 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903935;
	bh=0te0Xg0GDDXSsI+LDqMgTcSFjRvwkkYO8px1yLDgtHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdL047ahclXL3Aps07l82VBkAQM6KqF5euPSe2j/TZtzmzLNWQXRJ3OmUCQo9YkwF
	 Ix5aCYhfaiGbXi/BHHwKRyuFL1nwzRypiq6LgSLeh1uyBr5Ha4dH2p8CAKMn9xrjmv
	 7EukxBB6TN8m8vz+yCDEfyAh+UqoXJ79cY6q/vxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.18 118/275] arm64: dts: marvell: uDPU: add ethernet aliases
Date: Mon,  4 May 2026 15:50:58 +0200
Message-ID: <20260504135147.291539811@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


