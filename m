Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CA515ADD
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dI5IoTWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A2EC433C9;
	Mon, 16 Oct 2023 09:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447174;
	bh=Tupbdr8b5sl72rA8Zml2tYOEHg8zR3b2w+RMubhbpLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dI5IoTWNm0bnQp4Q4wr9yW0L375cPZztMLLdBc0+rmwPZOs5YkQNt1qXOkTSvEqwA
	 lZqveeIdOH3nUELHd1jqoxPQPE3aaNXSvhGQSnfeIwiJ8hWccVUUQCXPLJ6BoKS++/
	 tumKfWmYSIyrEDghE8sRXubme9Sh/pHZtyMGeRnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Marek Vasut <marex@denx.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 010/191] media: dt-bindings: imx7-csi: Make power-domains not required for imx8mq
Date: Mon, 16 Oct 2023 10:39:55 +0200
Message-ID: <20231016084015.643576533@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit d7614a2733f5e354c075be178b068a241d5d8b11 ]

On i.MX8MQ the MIPI CSI block does have an associated power-domain, but
the CSI bridge does not.

Remove the power-domains requirement from the i.MX8MQ CSI bridge
to fix the following schema warning:

imx8mq-librem5-r4.dtb: csi@30a90000: 'power-domains' is a required property
from schema $id: http://devicetree.org/schemas/media/nxp,imx7-csi.yaml#

Fixes: de655386845a ("media: dt-bindings: media: imx7-csi: Document i.MX8M power-domains property")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20231004201105.2323758-1-festevam@gmail.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/media/nxp,imx7-csi.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/nxp,imx7-csi.yaml b/Documentation/devicetree/bindings/media/nxp,imx7-csi.yaml
index 358019e85d907..326284e151f66 100644
--- a/Documentation/devicetree/bindings/media/nxp,imx7-csi.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx7-csi.yaml
@@ -59,7 +59,6 @@ allOf:
         compatible:
           contains:
             enum:
-              - fsl,imx8mq-csi
               - fsl,imx8mm-csi
     then:
       required:
-- 
2.40.1



