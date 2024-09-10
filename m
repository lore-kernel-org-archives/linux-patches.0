Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAE0192D87;
	Tue, 10 Sep 2024 10:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964789; cv=none; b=kFg391EVeJ25FhH9+bmTSA+8Jkb/tlVvyihDXmqxB98YIQf1/DA+zEGpPMGvxg6qZWhk08LuwBCdzUFVO8dZwvAQRa3gZSZMFMaX3xGlPWEnI0S005pgDFrrDHWo7XQX9n8o9VaYi6XrsWgSuWYmqyQuXhvxwtzxQF1mPQQPp10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964789; c=relaxed/simple;
	bh=7NT3pIOs8NvLo2txsIe0fCpIt+7ORtcbLQHHX/ALJNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVrBE/T+TXH2+/ov9tOS79E6bQWBTq+dt8zo7YcS2DPO7eZbE+6frGbfdFYZBrxZBgFJBI2TZPISmBZIweGEegRgeHx5Il7pFsbTui3sP991RnDWxFt++xbC5mc+kgPVCDsyKYu7thLMfn4vO1EkPxJcs1Zpr84bcOadFZ5rX7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B2DJ45l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B2DJ45l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595A5C4CECE;
	Tue, 10 Sep 2024 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964788;
	bh=7NT3pIOs8NvLo2txsIe0fCpIt+7ORtcbLQHHX/ALJNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B2DJ45ljgeT+p0ZNtO1MZb8pGT67HnSkt145Sn/MYZAZgbQ8ZabB2RjP83nUhhQI
	 HwciL1l/7mLnv9XrDJeqU3ixeeaKi1E2Za2ncW+rUkFujeLnoFfAP6PdG7kcGe6nmo
	 kDY0g5p/NTT54d/fXVLG5MnKmy1B/tYd2kmjRYKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/186] i2c: Fix conditional for substituting empty ACPI functions
Date: Tue, 10 Sep 2024 11:31:39 +0200
Message-ID: <20240910092554.823141388@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
index a670ae129f4b9..cbd2025a002ea 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -991,7 +991,7 @@ static inline int of_i2c_get_board_info(struct device *dev,
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI)
+#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 u32 i2c_acpi_find_bus_speed(struct device *dev);
-- 
2.43.0



