Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021278;
	b=jkc77dQ9KIRtCmT2lRIORVz340k8uaLhQb/OOT/bM90mfEYfruyC0HTLqGuNvmPflLrE
	 Lrz3Hafk/ZVFyH+CgZR0VN6kgw0twJri3+h7kqpLsgipPCd55Tmm5Xk/sS69T0f38YDrV
	 3cjFtzaXyc2TrxucS+vO5ErV3XQ0wvTL3eyG91gdXEPa9apgsLdzP8y++TRR5Cqj297bM
	 i8KXlAgS+RGF3VjWX0SjwiJYg+KmS9BvMJuEZba0CFj3RzwjiT5WjsSjqyCByMcoq2LQu
	 9RwsJRH4WFDnB1uW0LhIi9ZSHnHeJCfGA2o/iE/hnaIbo5dh+nm26sEuBAlU+o9MTYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FWUT++DtN/Sv7GUgiujzG44UUp0GIVzNNyfrdufMZY=;
	b=o0zdRTlaC+qmtBiKTCFynyz8T6Lx/BcQ5dhmIu/ej7FvtZ9boEyKTQR7MK0Og4o86Wt+
	 8tE4WEW40IjIajA9iC8I1LdDUgdXlk+cNnJsTLMc+tBU4shceuEl/xyTMuTaQOLUFUNW/
	 fbKbYUODXb+bMlV2zu5reeRZ8uhzhiwlV0ZYkMvyrxF/QemmTOx1jSMTDqHJVhR8NBp5u
	 D91OA5ZguMNXErPX4SFQozDoKtsGEkJujOvg0AovLla5GeLX2HZ/EsrGNZ2qoOQr0Z413
	 0MuDFW0Vx0OHTC6BVxNQeVmr/I0QVFq5iBvk0DelQjqKF0pRZDQxAAO4fQrpZrI3cGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZUjQOaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF62606A31C;
	Wed, 18 Nov 2026 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZUjQOaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF221F000C6;
	Wed, 18 Nov 2026 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021278;
	bh=8FWUT++DtN/Sv7GUgiujzG44UUp0GIVzNNyfrdufMZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZUjQOaM/6ZjlTdgmzC++cJXGz48GhOkg/6KH2ELs+1YieCNbgt8cZpEUrRQrgdqK
	 6tY0xv88TkT96QwpJ4V1cooNdCbCwAuioG74/1jCX7eEy29zLRafvBK+hNtAAw4Hrn
	 fLk2bD+LVYVtfGTbBxDmNK0or0qNM2GZqZkgusGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2250/2651] net: phy: realtek: restore RTL8211F RGMII delays on resume
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150406.452036500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 20c0c677362468b0af23e26e5fdb871ea911bc25 ]

RTL8211F and RTL8211F-VD both use rtl8211f_config_rgmii_delay() during
initialization and share rtl821x_resume(). The RTL8211F-VD loses its
RGMII TX and RX delay enable bits across a software power-down, but the
shared resume path only clears BMCR_PDOWN and waits for the receive clock
to stabilize.

On a BeagleV Ahead configured for rgmii-id, carrier and the negotiated
speed return after an interface close/open, but the receive path does not
work. At 100 Mbit/s no frames were received. At 1000 Mbit/s all 11
observed frames had CRC errors.

Reapply the RGMII delay configuration after the existing resume delay.

Tested on a BeagleV Ahead with an RTL8211F-VD at 100 and 1000 Mbit/s,
including close/open without a link partner.

Fixes: bb726b753f75 ("net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20261015045001.83986-1-kmehltretter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 177b62a7b2d16..c867e5213216b 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -1375,7 +1375,7 @@ static int rtl821x_resume(struct phy_device *phydev)
 
 	msleep(20);
 
-	return 0;
+	return rtl8211f_config_rgmii_delay(phydev);
 }
 
 static int rtl8211f_resume(struct phy_device *phydev)
-- 
2.53.0



