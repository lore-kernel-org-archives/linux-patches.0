Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC302D2483;
	Tue, 16 Dec 2025 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886341; cv=none; b=Y84Vlow4JG85Q78pvCQlZmuhbR5C+vHZE8cTxSgXpGfY0jCWFJ2NCMtzoMEZauBr9P8+glJ6GBNZHfcab/vqlX7JdOJQg5a7Yvwy7iDzLcmO3Xj6jVwXt1bzl3mR0e1ujJwG9LSSiftbQUZIr2FPdXdmBYsMNw//VrZU74+LmnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886341; c=relaxed/simple;
	bh=uvpniry1LWCXolcrA62CURqXemUjO8OXfszET5OnZIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUoK4atF2qUuoqgAFB+PXxoGiVxZ2QH2Von0i8Lx0l5tfjNm/yZ0RIp40ghJyebjmlO2WnassZOqmGvlBjOFz98o+EX1XAjqKR33MuEg6DGeivDQugz+g4VnJVU5pBczHMaXVOAhZ60Eq9j9QAV6Q6+0Zawi4ofYUj5QgGZbNZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMdwXbF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMdwXbF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36DBC4CEF1;
	Tue, 16 Dec 2025 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886341;
	bh=uvpniry1LWCXolcrA62CURqXemUjO8OXfszET5OnZIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMdwXbF120nU8rrkkADKZ5M4npZwuB6e6d7FE0IbpI90CxSIjO+TKaGR1+EZjeCqm
	 GNeneaieJWalC/ZXmqhnMHjDMAdfdizTw7woFBlOy36xVN10HImiVVEYobopbHVl8j
	 qJxi25pqUMz9uWCQc365uwclbJfpSuToGF2JWYMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 408/507] clk: keystone: fix compile testing
Date: Tue, 16 Dec 2025 12:14:09 +0100
Message-ID: <20251216111400.245304875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit b276445e98fe28609688fb85b89a81b803910e63 ]

Some keystone clock drivers can be selected when COMPILE_TEST is
enabled but since commit b745c0794e2f ("clk: keystone: Add sci-clk
driver support") they are never actually built.

Enable compile testing by allowing the build system to process the
keystone drivers.

Fixes: b745c0794e2f ("clk: keystone: Add sci-clk driver support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 18ed29cfdc113..12b4688131f11 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -124,8 +124,7 @@ obj-$(CONFIG_ARCH_HISI)			+= hisilicon/
 obj-y					+= imgtec/
 obj-y					+= imx/
 obj-y					+= ingenic/
-obj-$(CONFIG_ARCH_K3)			+= keystone/
-obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
+obj-y					+= keystone/
 obj-y					+= mediatek/
 obj-$(CONFIG_ARCH_MESON)		+= meson/
 obj-y					+= microchip/
-- 
2.51.0



