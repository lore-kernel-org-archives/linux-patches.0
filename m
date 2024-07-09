Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874D214EC4D;
	Tue,  9 Jul 2024 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523822; cv=none; b=MMVD+dR06ZrptUnwQwMFwdedIKGT7BOsK+iXhK+Q3IbTRn4BrzfTNItymC9QUvnxnHHZMzPEeF7J6b3dPnNedEiQj7rIATqaogfHAIx7MI20xHXCfnekEy+CWcFxFUdwfkbVEQWYQMvsv8fokeSaf4oskorNApetmVJn33TGai8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523822; c=relaxed/simple;
	bh=x4Kp3espA6d9X42v4OZk+2pu+cLAVWlfGdk0/OSispY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLnY99FXkO99a9jlg8FbtzOUMQ2/vQopiSgWhkOvj5CrhZZMEGyDe8Cn6UxdovS9xxjyLjwBiq3ytkTBHmZh9P3OP/LPCWFal0e0DHkowWl+/w5YA4uZpV+aK42BXd2AziWb6Mce37ZEtaVYdPGDDUs2wFQust9OOKqXYvzq5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UECxJRpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UECxJRpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FAC3277B;
	Tue,  9 Jul 2024 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523822;
	bh=x4Kp3espA6d9X42v4OZk+2pu+cLAVWlfGdk0/OSispY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UECxJRpBqwoA6EwwLI0IV8n5wd7AG2CLkIE9P7IsSiNLJY15Pmp7hHKCRBrkzpMjI
	 199rlsuuRvBWva3mnHi9dDx+uU2HYmvt2skOwIrYOU6awKTmoK+cz3ZgUEzQHHpk9c
	 KGjhjPrIJzayj1LucnWXfp5K7TK6AWx5EA/50/74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijie Yang <quic_yijiyang@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 113/139] net: stmmac: dwmac-qcom-ethqos: fix error array size
Date: Tue,  9 Jul 2024 13:10:13 +0200
Message-ID: <20240709110702.540762972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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
@@ -268,7 +268,7 @@ static const struct ethqos_emac_por emac
 
 static const struct ethqos_emac_driver_data emac_v4_0_0_data = {
 	.por = emac_v4_0_0_por,
-	.num_por = ARRAY_SIZE(emac_v3_0_0_por),
+	.num_por = ARRAY_SIZE(emac_v4_0_0_por),
 	.rgmii_config_loopback_en = false,
 	.has_emac_ge_3 = true,
 	.link_clk_name = "phyaux",


