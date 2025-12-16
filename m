Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD5387B37;
	Tue, 16 Dec 2025 12:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888341; cv=none; b=RlPvWkl7wkVwZEMsSEnWBiIHg0Rxm1Jr5azCvQ5HFa3LjDYquGVI2BGRpS3jnNecDF00lAerKhPuF63d0jeT/1Q96w1tp4KJFaDzUdPyiKYWQJiRBLNP5Qc1fV+Qm9zOxsUh+Nia7NG+frFB89OWk0cPkRISke2McqO3P/WHIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888341; c=relaxed/simple;
	bh=zu70LZ4wsmGi5C/ZhhAwD8l19j7CEG6jZTCjXww2GxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vCIxOyjC9cGQnlUSsq05vDd0Hmj3jHcCAVW8grKIWEWK/z2I8BIspulTPflzI4RYptDuSRTS7ByyuZC90CakLDtW/95t0givLMjUDvQhiBsYiju0yUZk9U0GZcEyZtM3KKhidbPrhe/raSEUvGPgFjjzmeVZjWeNkPgo92PnYiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWzDoPfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWzDoPfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93600C4CEF1;
	Tue, 16 Dec 2025 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888341;
	bh=zu70LZ4wsmGi5C/ZhhAwD8l19j7CEG6jZTCjXww2GxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWzDoPfj/+4zh7jq1Io1syKg/7SVRr0blIEvb0qNO6cgC8wabkaKMF/Y/Df4AASRn
	 bWAs8U6Z64BBXTQb47eUCV8RTc+h7Z6TXiAUtb7Ub/cFFRaGw8kOWqQGJXCiqSTycZ
	 EuvPW7i+o0Abbj201/b6ROmpRWlhkLMejeswbQwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 506/614] net: dsa: b53: fix VLAN_ID_IDX write size for BCM5325/65
Date: Tue, 16 Dec 2025 12:14:33 +0100
Message-ID: <20251216111419.703226490@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 6f268e275c74dae0536e0b61982a8db25bcf4f16 ]

Since BCM5325 and BCM5365 only support up to 256 VLANs, the VLAN_ID_IDX
register is only 8 bit wide, not 16 bit, so use an appropriate accessor.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20251128080625.27181-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index eb767edc4c135..a09ed32dccc07 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1924,8 +1924,12 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 	/* Perform a read for the given MAC and VID */
 	b53_write48(dev, B53_ARLIO_PAGE, B53_MAC_ADDR_IDX, mac);
-	if (!is5325m(dev))
-		b53_write16(dev, B53_ARLIO_PAGE, B53_VLAN_ID_IDX, vid);
+	if (!is5325m(dev)) {
+		if (is5325(dev) || is5365(dev))
+			b53_write8(dev, B53_ARLIO_PAGE, B53_VLAN_ID_IDX, vid);
+		else
+			b53_write16(dev, B53_ARLIO_PAGE, B53_VLAN_ID_IDX, vid);
+	}
 
 	/* Issue a read operation for this MAC */
 	ret = b53_arl_rw_op(dev, 1);
-- 
2.51.0



