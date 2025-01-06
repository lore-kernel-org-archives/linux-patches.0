Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E2578F49;
	Mon,  6 Jan 2025 15:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176880; cv=none; b=RHgBNb5Z59XZrxR2TeDdhYxr+W/0P6eMLfCbcfO33F9S1hHAkOO0ivTXrbK4kIlbpcU2QKwvtUfuyiF3TjMRi1qBWLGhZBNIWZp3Clq2gJpQgCAALnkCnII674atj5AscQa1ESn82KBO9b7WVi3WXSNOjibaRem10D4jRI0a5jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176880; c=relaxed/simple;
	bh=pQvSzM7En5Worw9f2s+elHVFerw2WhGvSqbR0fQzhIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG4XgIK2CahZiAcB7zshDBr1r3kJCouahk3S3db6H2BX1w8XHb4WxmjpUdUf+t3sQFh7wWLO91YrlxfFtEs19ZJVKKuerOvaCH6pWfzBmD+QWKVhqeK4QBSKmXCO22e8RXuUodY4Eo+QQWQ8opTcnkb4/ung7V2ebTe9qAQ7r4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osQQUPh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osQQUPh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E59C4CED2;
	Mon,  6 Jan 2025 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176880;
	bh=pQvSzM7En5Worw9f2s+elHVFerw2WhGvSqbR0fQzhIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osQQUPh/BMVddYUmeqOzmd4QBRm/3lm7ahfFeXWG978M9Lrk3Do8U/E9dM0sK0gX+
	 nSQH5CeEWjPztRlSPR/2njnZQUTBLIu0zuHWMQXHwl4MsGwFsXNx/Clr3I6LuL59gp
	 Nxyw4iBYIDRXarauKh8KgQjtpiHq2LJWce6CH1cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/81] net: dsa: microchip: add ksz_rmw8() function
Date: Mon,  6 Jan 2025 16:15:51 +0100
Message-ID: <20250106151130.160793441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 6f1b986a43ce9aa67b11a7e54ac75530705d04e7 ]

Add ksz_rmw8(), it will be used in the next patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: bb9869043438 ("net: dsa: microchip: Fix LAN937X set_ageing_time function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d1b2db8e6533..a3a7a90dad96 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -454,6 +454,11 @@ static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 	return regmap_bulk_write(dev->regmap[2], reg, val, 2);
 }
 
+static inline int ksz_rmw8(struct ksz_device *dev, int offset, u8 mask, u8 val)
+{
+	return regmap_update_bits(dev->regmap[0], offset, mask, val);
+}
+
 static inline int ksz_pread8(struct ksz_device *dev, int port, int offset,
 			     u8 *data)
 {
-- 
2.39.5



