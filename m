Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B4C2D0;
	Mon, 11 Dec 2023 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdqUZAkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B95BC433C8;
	Mon, 11 Dec 2023 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319492;
	bh=ITPstsTMTqOvtuffJC41EepfA0Y1uUuKneECR7fMKaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdqUZAkGnH6z0UFlRWkGTgEkX8pbBFtHHxVDY0ir/czJCPkvYcMSb5wFo7WTe0V/B
	 Lx7V1b1A7txV14DzpHU3NSMa87b+P4aIFtm0/lBmbYiFgQPQMFEMz14F0elw2USi9+
	 mX02AS9xj2vi5/XFTLbU8DGLLuU/QfzA8fwTwR0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/244] ARM: dts: imx28-xea: Pass the model property
Date: Mon, 11 Dec 2023 19:20:18 +0100
Message-ID: <20231211182051.422386417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 63ef8fc9bcee6b73ca445a19a7ac6bd544723c9f ]

Per root-node.yaml, 'model' is a required property.

Pass it to fix the following dt-schema warning:

imx28-xea.dtb: /: 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Fixes: 445ae16ac1c5 ("ARM: dts: imx28: Add DTS description of imx28 based XEA board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/mxs/imx28-xea.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/mxs/imx28-xea.dts b/arch/arm/boot/dts/nxp/mxs/imx28-xea.dts
index a400c108f66a2..6c5e6856648af 100644
--- a/arch/arm/boot/dts/nxp/mxs/imx28-xea.dts
+++ b/arch/arm/boot/dts/nxp/mxs/imx28-xea.dts
@@ -8,6 +8,7 @@
 #include "imx28-lwe.dtsi"
 
 / {
+	model = "Liebherr XEA board";
 	compatible = "lwn,imx28-xea", "fsl,imx28";
 };
 
-- 
2.42.0



