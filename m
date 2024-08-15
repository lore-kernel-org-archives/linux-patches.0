Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5E019DF92;
	Thu, 15 Aug 2024 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731862; cv=none; b=AVdGi9pZDvxKlyojH8rd6BrarxJSzuhWQI/t5tHqqN0WW5ow7NxLUn+VRgQ1DNccxv9A8uhQzUcPeb0aOqlCpGFXSpKh7bdZsnk8SBBYnsgOiwq6lSC+ScV2chcEWixYJx5Lu0LJm7h6DXahppuZ6txnf27PL9GKCbbRg0rYpmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731862; c=relaxed/simple;
	bh=PjQAHIC4oH7D+wbRLrV7Lvri2Avn51fQ5rcVcMRpQ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb9pDdDNwYxonWDAD83kcL0DNNlKAH4A9BW4ReA3/j8JwdZIjwiJMjZYwP3900BuOpePWy7pYVoQDngzFDeaASqFQSxnWXGkvflkN6Qsl1W5klUH8AeUAJWebxhsOY8ZJCdD0+DQ7OQNZvyFH7KLiQ35zH7fgc8EcFdo7zbXcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3JpJx93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3JpJx93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D30C32786;
	Thu, 15 Aug 2024 14:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731862;
	bh=PjQAHIC4oH7D+wbRLrV7Lvri2Avn51fQ5rcVcMRpQ+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3JpJx93iqGzdW7dnrgOlaO34gR3kj5feiS8Cq6io8eNNggdHa3Z4fp3/kFHOkmSr
	 fuWn86suwrhAcYjDKB6b9XyWWnYMdYMMlur4QfaxA706djomVhP6qdsFbwYimvmbkG
	 H596cGhYOTg7BoOpdq0mMgRTw+ybXrUYzdrHRlLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 259/259] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Thu, 15 Aug 2024 15:26:32 +0200
Message-ID: <20240815131912.872919263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

commit 0df3c7d7a73d75153090637392c0b73a63cdc24a upstream.

The i.MX6 cannot add any RGMII delays. The PHY has to add both the RX
and TX delays on the RGMII interface. Fix the interface mode. While at
it, use the new phy-connection-type property name.

Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -259,7 +259,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii-id";
 	phy-handle = <&ethphy>;
 
 	mdio {


