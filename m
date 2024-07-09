Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2BB27713;
	Tue,  9 Jul 2024 11:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524485; cv=none; b=AMmF2J3zF+gXEg/ZqLyrU1BTNeWjAbJ5x4Ttw0pSWWrZ/HEMH7HjfPoLx/SW/BA/roT05c8zkIOxsmo9cbnjZxZBafQiPrFecICv23UkTREOg1+leCjBXZaQOx9M1YOM13rRlkMzoHMwf+0xwD9Ag0a+lekzZIgs0wzR8mqb9+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524485; c=relaxed/simple;
	bh=wdThse/X7ANx0CJgBxmMMA/lX9wAJzjhmQ0KBr7iD6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUEEkO6pORNYsvEYidkiUCQJVC81unxU73Vmx1sJDPs9q2/CCC4J2dl2NrE8yKSbxkB4ejULxgEhh+kD7kqsy3W5cFAx7ZzgKS3LfSfwBNCINbs3JeGvzyt71nzQY8fNUlTnTxabSlWsOE1pxbKS074wr7QHSDZ3+px+d/gWqGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQL+sqXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQL+sqXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D5C4AF0A;
	Tue,  9 Jul 2024 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524485;
	bh=wdThse/X7ANx0CJgBxmMMA/lX9wAJzjhmQ0KBr7iD6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQL+sqXxW5VlSQci0Om4fTZiQ9EKX4fv2zBawJwM3IsGVLZsdw1FLznv3tvukatQf
	 s5UPnE5bQHk49DYnPPZYv43batR5JGviMg7gPaEgJ/ebD7WLXPtDU1lv7WVazMz5/x
	 ibsQVVgLdBypZ+rSWvPXU22TBbm/WpD4BQQHE53w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijie Yang <quic_yijiyang@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.9 165/197] net: stmmac: dwmac-qcom-ethqos: fix error array size
Date: Tue,  9 Jul 2024 13:10:19 +0200
Message-ID: <20240709110715.337471056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yijie Yang <quic_yijiyang@quicinc.com>

commit b698ab56837bc9e666b7e7e12e9c28fe1d6a763c upstream.

Correct member @num_por with size of right array @emac_v4_0_0_por for
struct ethqos_emac_driver_data @emac_v4_0_0_data.

Cc: stable@vger.kernel.org
Fixes: 8c4d92e82d50 ("net: stmmac: dwmac-qcom-ethqos: add support for emac4 on sa8775p platforms")
Signed-off-by: Yijie Yang <quic_yijiyang@quicinc.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/20240701014720.2547856-1-quic_yijiyang@quicinc.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -272,7 +272,7 @@ static const struct ethqos_emac_por emac
 
 static const struct ethqos_emac_driver_data emac_v4_0_0_data = {
 	.por = emac_v4_0_0_por,
-	.num_por = ARRAY_SIZE(emac_v3_0_0_por),
+	.num_por = ARRAY_SIZE(emac_v4_0_0_por),
 	.rgmii_config_loopback_en = false,
 	.has_emac_ge_3 = true,
 	.link_clk_name = "phyaux",


