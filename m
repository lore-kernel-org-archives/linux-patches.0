Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047795;
	b=34XJOBy+k3a6wXCNow9nxh9v013dWaFov3Wmo5a+qQJo0Vm6VTLWxY8IABFSGG3QZL41
	 9hIDGq9JFo1kbDSedRjN7jCsoYsRJR2isfknPtylYUXfpo+dcAKgXIsd+c//8Iyis5t56
	 lu0POcpH+a49oZGthO8675djOLPNNhJbuVrCYP+cw7x07kOjE3kh5Wso7T22T2TKAGE+8
	 NfXnuq9ArPVitW1+Sp5RVV5fWrXPpg0JxCVG/c0LeERrD9tsO3hMiXzz3Spm3LloB/MCr
	 4qZKW29y0w6Pc/+U8TUEYEMhvXiyX4BLk7zakx396wsJmOynWmaultnG/OqLMpREC6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CgeSRCdSsRSj6EiXimGiJV+Te65uKtbAedEqGlHOHbs=;
	b=5GipGM8NIXk35oiVyVZytc3NIkY+0DifpTHcG8h0gA1E6wfchPTNnBjZfGbul8YKehAd
	 OEJvL5Mj1oiL6dNw+WsQMe6bSps0LHft2Rz3I/10qAs0JF8xBr9Nm9IS8zGHvVM7M9AqN
	 6ulOXXRq/ji9TpaHzvoa6up+5s9/JBL1jIVW8FFiwz2QVHETLR3kysc6UwoyXaasHtnQL
	 BFsLPidHa85HHmqdY5RSwp5QCkaozzpOVVewytIb6BpNH+opHCnZoWVuHw4ZSClQUrvwP
	 T/0CXUgkCaHX2e9c3aX5dhg3yvSkwXZDhGAZexl/DGtnHVqdH84V9fbsZybqdq4JkEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG6MCfeW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C5C606A333;
	Thu, 19 Nov 2026 00:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG6MCfeW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055C81F000C4;
	Thu, 19 Nov 2026 00:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047794;
	bh=CgeSRCdSsRSj6EiXimGiJV+Te65uKtbAedEqGlHOHbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG6MCfeWa2Hc/hh3N8hWh/QEgQIfW4lPs1Rb/eY3JZGNimSrXoj8b3k1oPw1zwrAA
	 h5H3+PGlni/tAyeIlprfGqrTgchrhFBHC2zhu682GCXvyxxzySydzM8guNimc08apw
	 LrQb0Y8RrEpsSUCwH0gCsv0jeRDIdbGEDz+/OPUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1729/2857] drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150303.573677057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit e3eca845ef7d6cd8c407f9b42beb45af94ff096b ]

Update drm_of_get_data_lanes_count_ep() return value documentation
to match the drm_of_get_data_lanes_count() return value documentation.
The drm_of_get_data_lanes_count_ep() is only a wrapper around the
drm_of_get_data_lanes_count() and therefore returns the same error
codes.

Simplify the return code description of drm_of_get_data_lanes_count()
and drm_of_get_data_lanes_count_ep() to -ENODATA and -EINVAL.

Fixes: fc801750b197 ("drm: of: Add drm_of_get_data_lanes_count and drm_of_get_data_lanes_ep")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260305205840.95978-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_of.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 7bbcb999bb758..2c295f6369329 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -443,8 +443,8 @@ EXPORT_SYMBOL_GPL(drm_of_lvds_get_data_mapping);
  *
  * Return:
  * * min..max - positive integer count of "data-lanes" elements
- * * -ve - the "data-lanes" property is missing or invalid
- * * -EINVAL - the "data-lanes" property is unsupported
+ * * -ENODATA - the property does not have a value.
+ * * -EINVAL - the "data-lanes" property is missing or invalid
  */
 int drm_of_get_data_lanes_count(const struct device_node *endpoint,
 				const unsigned int min, const unsigned int max)
@@ -475,8 +475,8 @@ EXPORT_SYMBOL_GPL(drm_of_get_data_lanes_count);
  *
  * Return:
  * * min..max - positive integer count of "data-lanes" elements
- * * -EINVAL - the "data-mapping" property is unsupported
- * * -ENODEV - the "data-mapping" property is missing
+ * * -ENODATA - the property does not have a value.
+ * * -EINVAL - the "data-lanes" property is missing or invalid
  */
 int drm_of_get_data_lanes_count_ep(const struct device_node *port,
 				   int port_reg, int reg,
-- 
2.53.0



