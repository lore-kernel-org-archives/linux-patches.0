Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFE93090E6;
	Mon,  1 Dec 2025 11:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588498; cv=none; b=d3NWNgbl78k/4fafIbEK00sgwzRD9koccChMrdPG5yawD8dKiHC7zvGTMw5zYjrPCFlnPFVCtNm/uykLWTNqz/GVV3yChkeBSj/9C6xFD6hwOnm/RmQYhHiftAuypLVNfvza21312GyZsuNVAgSrIK/H1vSZJD1xhFlFFHdoRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588498; c=relaxed/simple;
	bh=xfrJjevKp4Qb5rJv7k1X4rOjPd/x0qn/StWc8xzXhjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGborBlwHbhG8Y1Z3u2EtWKlKp7x0mN7GDI30Z289nYZ1s7t7nKZf4h3giC22lVQ1QNOlGSu7E4ySA2oPAniSM0orDaHA/7kwafISapR0Bc3hS+rPUNG2KyQC2fXV4NsWO6Iz/aDkUoWJd0NACXNKq5haA081inthoDBkMryRxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxDYe2WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxDYe2WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85DBC4CEF1;
	Mon,  1 Dec 2025 11:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588498;
	bh=xfrJjevKp4Qb5rJv7k1X4rOjPd/x0qn/StWc8xzXhjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxDYe2WWG3DHsBiIBhPhvZ2eShdXkXMz+5nk52wjVxi3sI5Sd5/4ypvKQ+/fN6cPd
	 xJz4qwSzpt4wmTPilcNgBbwBHSYnznQoTto8d4ZHKj3Fz5heShmEMvO2/OOU0jeQWM
	 JX29RSPOj1MhDWGFHLj0aeway3jFklkNyxdtuIFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/187] mips: lantiq: danube: add missing properties to cpu node
Date: Mon,  1 Dec 2025 12:22:57 +0100
Message-ID: <20251201112243.730789060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit e8dee66c37085dc9858eb8608bc783c2900e50e7 ]

This fixes the following warnings:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpu@0 (mips,mips24Kc): 'reg' is a required property
	from schema $id: http://devicetree.org/schemas/mips/cpus.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 510be63c8bdf1..ff6ff9568e1bc 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -5,8 +5,12 @@
 	compatible = "lantiq,xway", "lantiq,danube";
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
 		cpu@0 {
 			compatible = "mips,mips24Kc";
+			reg = <0>;
 		};
 	};
 
-- 
2.51.0



