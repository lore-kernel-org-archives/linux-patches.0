Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E3618E021;
	Tue, 10 Sep 2024 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962395; cv=none; b=lHtEu2xqGH/WuZZmUWaI/zMQUypMS6PH+Dn0UUE5S+LCQFBtPdzurtYqqS7stSLkZZf3rRdCH3is0xApWgwq6p/IH6VSRvWabKYGxTBB82oaXad95/GaMZl/hRRfyfYR20IFb4LP6LrmGmemXeBAhJUX/qCIwgUAYHzeklqrXBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962395; c=relaxed/simple;
	bh=W98qHv4ih54cDTpLGA7HSaP4Q/0CDSZNAEIMv8uzO7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIrLJhi1HeNDuGUWxXcg5SrB1dEqppjVtis1WCgK4C5ylAPhwlYDvAT0eVYv3Caccjg6t9Xa3XL4IeV0uj57sPyfnwf1gb/Cpuv4GA5DLzBCxGiFyQF1H0LFZgcvg0ksSXjGZPofAYUx6mE5yBwE0UcnsKXrOnbRUP/3HN3AjL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHYZ2aJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHYZ2aJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4574EC4CEC3;
	Tue, 10 Sep 2024 09:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962395;
	bh=W98qHv4ih54cDTpLGA7HSaP4Q/0CDSZNAEIMv8uzO7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHYZ2aJ3RhX0vyS3nShAU7yGF+GVnw6NuUzFbfgdK7oHkNWzUtvWKKOfa1VUfx4tW
	 If4fd2kAgzeVQAhwQgmvXScHEMMmwbKoS1dRYawuwgNwsNhxevXmWtATS2TCmaXOrq
	 87WEJd7c1X+6XZzSU4VskPSh0oieDmyu+yLGuLBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/121] i2c: Fix conditional for substituting empty ACPI functions
Date: Tue, 10 Sep 2024 11:31:17 +0200
Message-ID: <20240910092545.846795102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit f17c06c6608ad4ecd2ccf321753fb511812d821b ]

Add IS_ENABLED(CONFIG_I2C) to the conditional around a bunch of ACPI
functions.

The conditional around these functions depended only on CONFIG_ACPI.
But the functions are implemented in I2C core, so are only present if
CONFIG_I2C is enabled.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index af2b799d7a665..fee64a24f9877 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -979,7 +979,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 u32 i2c_acpi_find_bus_speed(struct device *dev);
-- 
2.43.0



