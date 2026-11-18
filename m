Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032548;
	b=ReyVmNIb9vyO4lisS9Wf6usBwWuqeHRrHKYmCAC5pC+gCXY5prZZTFwSy4F31eqG/Utc
	 er3wPyq4sqNi1m8mnpMYpSweajnlzrZOtPwOS9keNHtDJ8Yey30J+qV9BdJlV/Bv0/XPB
	 yMEqfLRY4wiis/PCCT4XBfJFVT+wbyTNWeIZdMkH4JtlwDORgT1vaugfg4H7+6d1ajuS0
	 4NaDRWufX7GRaikwYHnpw+c6KOn5gamoXJox49IsmV+zPqQDlwzceRJfr2JxxMmD6MG7A
	 hKkzq3/s1vb+R7o9B1jETusJeYVostC2joEJJ3MmbWCZS/JD1e0RHgfdc2ub/nFiIyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vzte/R9S8Qt/Qr1NyfEYIVG1BdIvKoqogpa56wI2844=;
	b=NPbR1d8mnDUm0dZ4cfr2tEpXWK+p1HOK2gZNZR6ymvnhjlCqmsMmdqOtniCVZnIPCU/E
	 FAza+eg4a36D0eOQSaZ86TxPE2Ph47ys4EZDJ0lsVdilowj1r1SRnpFb5WhPh74SEV/aY
	 TUT7Hvyu1TsDHP1JxuWm6lIRDr6Mbj0uWeHlJAPPzE108bEat0JOuja+cydTVv8ML//2R
	 jM7HC8IWj3EtT82YS/IPebuVHRKxsPjb2Ho7B6FoFvWvDUHnFAByntrLYrnZ7cVElUydQ
	 i23L2+/xszLS5pgPKOnZFZdW9JsB3equo1vigN5Kirkt9yZth8B4SdKHSjuBNfk5wGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RqZF0GHX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E36F60A260B;
	Wed, 18 Nov 2026 20:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RqZF0GHX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236A1F000CC;
	Wed, 18 Nov 2026 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032548;
	bh=Vzte/R9S8Qt/Qr1NyfEYIVG1BdIvKoqogpa56wI2844=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqZF0GHXDM7rc7VbJzH1T1i9D/AhyuifsNNrIxJDzoQyO695gSyEc8APd49UrrTW5
	 Qn8sGTcuEhgBzYtpkQQMLJqUxuF6rbPZ3i1bLvQlPJiqcOs/eG23UPeLV52nsGj8xP
	 wsmcdj+j4TZ3+8dRBOJSEWVLY+xQxxnMRKnU/dxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1449/1756] net: phy: realtek: restore RTL8211F RGMII delays on resume
Date: Wed, 18 Nov 2026 15:59:36 +0100
Message-ID: <20261118150106.794563710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 72afa280c939f..c166be011f9f1 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -586,7 +586,7 @@ static int rtl821x_resume(struct phy_device *phydev)
 
 	msleep(20);
 
-	return 0;
+	return rtl8211f_config_rgmii_delay(phydev);
 }
 
 static int rtl8211f_led_hw_is_supported(struct phy_device *phydev, u8 index,
-- 
2.53.0



