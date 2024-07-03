Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FE745945;
	Wed,  3 Jul 2024 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004983; cv=none; b=DsFKsjlZ3Bde1pIv2n1nv/NnPHQ4UJqx39tvUQIREdQYhAt8S0aR8hUNUA8T7SwB6pVO3E3vEo8fXXjc1/qKNCY+fu/vAbbd9My8czG28qhiU3TNpVR7UcKZX7ytWl4Ii8ExzLz+/bg5N1y1+0AKTSbk8jd8WsKfnodRox1dWJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004983; c=relaxed/simple;
	bh=F+6j2Ao7E5daH1ebwtNvEHIqKFBBqkkrunKfTt6oEoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F74eylU8r0iaZSURY5NxO4TYoMCRFa14G+gtB4EhXnF9RMQIyZvYAAe43D/9pAEWFjNXCefZn9CPm9tevg4jtpX3d8u35kLmdfLY8eKf3Ks7Nf2/fTAK/hZOBLOo1y4i1ozz4c87/yKvB/04oI12K7nYHfHXIjhItFuyw8U6U+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzpgF8WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzpgF8WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADD0C2BD10;
	Wed,  3 Jul 2024 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004983;
	bh=F+6j2Ao7E5daH1ebwtNvEHIqKFBBqkkrunKfTt6oEoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzpgF8WFZsIlIS+j5F2lLzioEDA3pHjZCnoDyFE73PIL5YunAtOJ5wR+SGqLMxZic
	 /u76R2zDRLkVqgk26sM9uhk/usxhi5Yl+FjYUr9ztH+qwM6/DsM+45hpEy+0JzY7jJ
	 XVT4+03pLPNZupyevDin5jZwH0KUgcaB8EVnfyXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/290] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Wed,  3 Jul 2024 12:40:01 +0200
Message-ID: <20240703102912.467889678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

[ Upstream commit 54a4e5c16382e871c01dd82b47e930fdce30406b ]

PHY_ID_KSZ9477 was supported but not added to the device table passed to
MODULE_DEVICE_TABLE.

Fixes: fc3973a1fa09 ("phy: micrel: add Microchip KSZ 9477 Switch PHY support")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2b7616f161d69..b68682006c06c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1410,6 +1410,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
-- 
2.43.0



