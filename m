Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE25576028;
	Tue, 14 May 2024 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686751; cv=none; b=YQe7zFCslNsEdATEH2oSp8sHsnliCOYpqGnQqAG+R15HFeinRHh9TDQFtwKfTOCJOJXz+3hF1SOVH5zX9ZLKcQdxP0UTKjrekKH26zdgJNKpBwTpevlSBfIDJPUdhpRqkovJU0+N+kaqFufqPbSAKXaZo68frTXlmL4Sedl2+Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686751; c=relaxed/simple;
	bh=Ys10ZJYmRgK9vQ/ypMm7i2iSOJAhzNd3sRy0KjLPvDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMQ+ZEBCAP9LfDSgkH3hT77SXsx0aKkm47UVDHpgb60t86ObUxWBxNfliqGk302GmUIMz5pZWpEEM/5UVXA/A3ywJvZq9RfGIvWfNphGEqPeAvYfhJeYjwLuS8qYW+2bzp3WPRyNmb3GZkFTv/CFVRTiQUgVfw2Hv6cxCKmP2PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWnf9ORH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWnf9ORH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EAAC2BD10;
	Tue, 14 May 2024 11:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686751;
	bh=Ys10ZJYmRgK9vQ/ypMm7i2iSOJAhzNd3sRy0KjLPvDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWnf9ORHMl6ENwj/GAFAQpXHFSJaS20HXF++FLOA3I8+vSGYH8PqXpUeNFaFf+JCi
	 khd9abgVNcH+pbwwyxEiP5BaMDgJAJuxgR8aUjDVcQ+Zy4dItTGRdNRw/kOz3zDBHk
	 d9CEp4QFARInytxK4nfHlsvqDbDbuErP9MFM21N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/63] power: rt9455: hide unused rt9455_boost_voltage_values
Date: Tue, 14 May 2024 12:19:31 +0200
Message-ID: <20240514100948.403872634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 452d8950db3e839aba1bb13bc5378f4bac11fa04 ]

The rt9455_boost_voltage_values[] array is only used when USB PHY
support is enabled, causing a W=1 warning otherwise:

drivers/power/supply/rt9455_charger.c:200:18: error: 'rt9455_boost_voltage_values' defined but not used [-Werror=unused-const-variable=]

Enclose the definition in the same #ifdef as the references to it.

Fixes: e86d69dd786e ("power_supply: Add support for Richtek RT9455 battery charger")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240403080702.3509288-10-arnd@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9455_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/rt9455_charger.c b/drivers/power/supply/rt9455_charger.c
index cfdbde9daf94b..70722c0709936 100644
--- a/drivers/power/supply/rt9455_charger.c
+++ b/drivers/power/supply/rt9455_charger.c
@@ -202,6 +202,7 @@ static const int rt9455_voreg_values[] = {
 	4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000, 4450000
 };
 
+#if IS_ENABLED(CONFIG_USB_PHY)
 /*
  * When the charger is in boost mode, REG02[7:2] represent boost output
  * voltage.
@@ -217,6 +218,7 @@ static const int rt9455_boost_voltage_values[] = {
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 	5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000, 5600000,
 };
+#endif
 
 /* REG07[3:0] (VMREG) in uV */
 static const int rt9455_vmreg_values[] = {
-- 
2.43.0



