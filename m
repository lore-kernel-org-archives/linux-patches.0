Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027510;
	b=TsOidin6rLN6s9B4G3hSbGHTBXmzDX6lH5weoIUi1jtKIYn6ybL1+Y7PQXGrniBesLNN
	 vy/AMiuGbxOJjfUSX5recLUblMcvMrfQ5jAaHZACQ3afLagauZuA8xOpAvqa/px05rixp
	 0dsOqbINchLTNT7gNG5lNnM9NuvJUrmMl+7vWRk4VzIiEc7BYjKAInXGcNqtViqg9MW4z
	 +UxJQnauNBVMnKBzFM+hEN5psC4/IIHWvnEGV9D3jHat+DnC/JGXdmpj+RnJCU8lFcEjz
	 Q8MnfdxuopcazVKoIGthtEeaJUu6c8/Jq/WnC4sl+sY4A7FMd+saXvu1szW6KX1ssBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p9HVcQe+ZP+JOc6wcgE9wKP8isme8E2//sRlPTlPnKI=;
	b=2DQuYdQWmBbBJCd4HGYM8TDfrPlULHrhXUjgmt8LaMc6meodVYQoJ5E933bMwsDPzbEI
	 tOKbutiuxlyvePWFigPsI4oNl8jGHJW6mB7KQGurHbcibuzifg5GJFNzWouFe8o+ck5e+
	 h55lpTVPOf5uoGaR4PfKrQaT9dVJAbN3KQuT9GUHC386H0TZ0JLe5TjL9ajJZ5xWPxaGw
	 PAjX4RIRqHpiWu7Mq4sABCcUykEuqIYlqIZqtwia5ImScpzN0cmqSY6Zm23p/GVvWgL8x
	 IkvUOuaVtg3yy1XbGdr6PKkF878/pD+f4aNgBXzUvWGQxeGJhBJ8SFvVaZX3blhCMrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhPb61pY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043AD60A2611;
	Wed, 18 Nov 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhPb61pY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0BC1F000C4;
	Wed, 18 Nov 2026 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027509;
	bh=p9HVcQe+ZP+JOc6wcgE9wKP8isme8E2//sRlPTlPnKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhPb61pYCefEd+ZawbuFXHTJcDs6rlW1YbX7Rq87z34IsDXG7QZ9R+OTxnzxMzGQr
	 H0dPE8ILDXUmj4r2Jnidf3NVZAYN3W3pe9Jk3t3mFA/PMD2+eQ+73Vvq5zbXVyKIKf
	 Um2tVW76e+1UInK0fIc/L6w9d3oWqFtSf7nCgmaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1814/2151] net: phy: realtek: restore RTL8211F RGMII delays on resume
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150227.887843820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ef8c3b23bee88..cc8606dd2bf01 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -772,7 +772,7 @@ static int rtl821x_resume(struct phy_device *phydev)
 
 	msleep(20);
 
-	return 0;
+	return rtl8211f_config_rgmii_delay(phydev);
 }
 
 static int rtl8211f_resume(struct phy_device *phydev)
-- 
2.53.0



