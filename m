Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7F515EFC3;
	Mon, 27 May 2024 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837625; cv=none; b=Mu3eWPnP8Dh4KM428hj1EXy69sXx7DPsj6mj8zu/0r59lmT140vikVXHluwU9oQmfMMCu4XGV5L7rNneOFak+S4VALfmskcMtnz3nCL8dIJpaIwfjQAEvMK0ItjvYJo21CWzbwm2U4w6sCVAfZZoVcUD3cXW2/cfbSi53eDcoxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837625; c=relaxed/simple;
	bh=sw1o8DlsZsgW2GKFUBtQBLuiQvUVBo/LQUwCvaeonBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIhkz/7n4Hx8Z2bm9sbPlBzMqw2mRciFjOu/h3sDYNKllw4xMr17ZheF+IFtNaHGRoyp9jsYAITw8qQFZ3yCYeSuWTwr47jSXIhRZgTcvE1pdW0rW9ATb22ztHDkkztdsOVMhscwcFsqPMWQGt2uS8K/ky9KgL4s6o8njjQhanA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z63jJsy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z63jJsy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31368C2BBFC;
	Mon, 27 May 2024 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837625;
	bh=sw1o8DlsZsgW2GKFUBtQBLuiQvUVBo/LQUwCvaeonBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z63jJsy3fjangIu7QcgNXYknfnV0lCARnjW6rUsEK6gwFuO/HPZqLpdJW71+ka4Cs
	 aYBhmZf8PguepcZE1+lnWgWb09GCTnpbGYfc0dHqiwsLyneYoWcUBgH/A1Ca4TvrWr
	 Cl+3cV46KxlrfWNQiZdEpkJo0WUOCf8YdP8DmCGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 044/493] dt-bindings: rockchip: grf: Add missing type to pcie-phy node
Date: Mon, 27 May 2024 20:50:46 +0200
Message-ID: <20240527185630.359121374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9793ea6f0fe65..575555810c2c2 100644
--- a/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
+++ b/Documentation/devicetree/bindings/soc/rockchip/grf.yaml
@@ -165,6 +165,7 @@ allOf:
           unevaluatedProperties: false
 
         pcie-phy:
+          type: object
           description:
             Documentation/devicetree/bindings/phy/rockchip-pcie-phy.txt
 
-- 
2.43.0



