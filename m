Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66012CDB0;
	Tue, 23 Jan 2024 00:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968993; cv=none; b=RInnCb1g3x97pMmju2+07+HYrOdmJj00mRe/rGY2M06sXwIoAVgA21pfOdCfHbC1fXzIyUpEjZkY6+ei1yVwGcnFHKJH9DQeG4XeZomJbn4h0Ml6vGlH2Av0xVDwHj8e4bDHnTsNWeORAkNjE8EbCzMu+p/usjTMGjSOakhBv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968993; c=relaxed/simple;
	bh=p1lYo5l+PytBoufEf/nxJmkmRqsJLHHxLqXhG2/ou48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkjpaYHRAIK3DfR0mqzRvcw8Aw7c9S/D4CfeoEijC38G1z/GGPytizUlJfLwIva5muRM8ag0rQoh/DXYClZ4DNsRqCj7RT96K+Pna847oX7xJyam4jjKHmXfdbDexUrp/ahNCHamd6kLPv0SW/M1U/VZttDzKhfR1l1I+Ry7vRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrbtKgFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrbtKgFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61B1C433C7;
	Tue, 23 Jan 2024 00:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968993;
	bh=p1lYo5l+PytBoufEf/nxJmkmRqsJLHHxLqXhG2/ou48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrbtKgFJ71Vhrh40+sp5cKbMnmRNJ2pAw/i30KxFtxj6xYiJPTdkF1vvA6ZUHwm/H
	 No77X1jeR5/L/83Re4gh+sq2zaXH3IiCV657Mlh9/evM1DInno0VIIul2OI8aeNAcq
	 3qcHnEBUxizvU7nyGYbv72ctTVI/6UaoqlApSffg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.4 147/194] usb: phy: mxs: remove CONFIG_USB_OTG condition for mxs_phy_is_otg_host()
Date: Mon, 22 Jan 2024 15:57:57 -0800
Message-ID: <20240122235725.532111052@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit ff2b89de471da942a4d853443688113a44fd35ed upstream.

When CONFIG_USB_OTG is not set, mxs_phy_is_otg_host() will always return
false. This behaviour is wrong. Since phy.last_event will always be set
for either host or device mode. Therefore, CONFIG_USB_OTG condition
can be removed.

Fixes: 5eda42aebb76 ("usb: phy: mxs: fix getting wrong state with mxs_phy_is_otg_host()")
cc:  <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20231228110753.1755756-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-mxs-usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -388,8 +388,7 @@ static void __mxs_phy_disconnect_line(st
 
 static bool mxs_phy_is_otg_host(struct mxs_phy *mxs_phy)
 {
-	return IS_ENABLED(CONFIG_USB_OTG) &&
-		mxs_phy->phy.last_event == USB_EVENT_ID;
+	return mxs_phy->phy.last_event == USB_EVENT_ID;
 }
 
 static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)


