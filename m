Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92213A406;
	Thu, 13 Jun 2024 12:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281774; cv=none; b=oHyiq6ckkAOml4uNkzXgdu3hmMezqz0p4QrbxhXNWMGdWBryAw17l8n1Q/3JfovUp1JFHTo2lMCygpaaoCtUeLwRoSxcRfIUKh5vSE1ajftsnwBdlEU4LzZGHp5ua5xbMxCyh1E8gpty9oZnLIbGPTJ+1MoiBhn+vyhkE85L0RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281774; c=relaxed/simple;
	bh=tYhlcpDGSY2GZCxOO9DPDv8TG7GEmq+OPuLHwAgLwDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP1IRR/PcE7CI1gGIMRWuyUJxS3s9oX3RSjmAB67Bi3lBySCttv7J9Vc6svT+6iXxn3p3fDOsSIKrNNhq1pixDzhnAhgHPP3AHGLm5oU6NuREbKWT3O6ndplji4ZSSBkZuiZ0euoKa+bEA8UuBXJMB08D72q61ZJ298fN4W8FKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6NjbCuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6NjbCuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E34C2BBFC;
	Thu, 13 Jun 2024 12:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281774;
	bh=tYhlcpDGSY2GZCxOO9DPDv8TG7GEmq+OPuLHwAgLwDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6NjbCuq3QhF3yEGaG4zyPg9YCa1xTxjnbDqweztppwoyA2KxxWLFNw/GiTByVXzy
	 XhjJbfKHBsu6g/31HnN+h6Ui3wf0OLr2gLZOimUknGxDprdAKnmO/pdX/PdhM70DA4
	 Bo7ftN968bCOKI+4mlUOQGXCDLCsUSamuI6X+4vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/402] dt-bindings: rockchip: grf: Add missing type to pcie-phy node
Date: Thu, 13 Jun 2024 13:29:37 +0200
Message-ID: <20240613113302.927228643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit d41201c90f825f19a46afbfb502f22f612d8ccc4 ]

'pcie-phy' is missing any type. Add 'type: object' to indicate it's a
node.

Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240401204959.1698106-1-robh@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/soc/rockchip/grf.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
index dfebf425ca49c..8fe31a7083db8 100644
--- a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
+++ b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
@@ -141,6 +141,7 @@ allOf:
           unevaluatedProperties: false
 
         pcie-phy:
+          type: object
           description:
             Documentation/devicetree/bindings/phy/rockchip-pcie-phy.txt
 
-- 
2.43.0



