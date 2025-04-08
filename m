Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D7A26982F;
	Tue,  8 Apr 2025 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116793; cv=none; b=WYuT13pjP/8W6ySXm+dkzaygBW//mCC9yD4aYTn/jvLwh8IU+L7tSLr0i1n7bgIdChGmYDRrn79N5+tO2WI7aAJO+OKvDa4tPvl5Iw4+GJsk8pgxe/S2ME7snUUkgGARIXAaUesCaddfQvlr4pQ9dclgYN1DbbgLEE2MzeJDGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116793; c=relaxed/simple;
	bh=RM6T8D0NuKBOuQq+FcYvEEUglPAyyhH2GGZdLWXLIfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8Pu3EVjD4sGq+daK5wA6pl5H7QDSqDr24U1hPrCwBAVDluJWcCzcSbfEqWYEAMxoxWVvwBpgBzalrzeVzLc0Xsrb3hKiRGCsaaC7CUBBEh9IphWAp0BfZulUU5g8mqNDCYz/jbtCiZwa/eiyJT/1gy+it+cWxZPxKE17mrnsVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFoZKxrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFoZKxrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F063C4CEE5;
	Tue,  8 Apr 2025 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116792;
	bh=RM6T8D0NuKBOuQq+FcYvEEUglPAyyhH2GGZdLWXLIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFoZKxrrhBp/3YNa1gP/+xcj9cFcLdjoakHUfoYl9WB4y0s3mgZBZ6SKVcZReIeEj
	 X4lM7EdNG1N+kaxLO36eFXUyKLSd30cnM6HUIrGVurADyiyvIMSArmbILid5TWX7ro
	 VjuewJcUkeRsVjbXcOUYcqcsRT+lE7ItI/MDVFvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/423] net: dsa: rtl8366rb: dont prompt users for LED control
Date: Tue,  8 Apr 2025 12:49:57 +0200
Message-ID: <20250408104852.069146449@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c34424eb3be4c01db831428c0d7d483701ae820f ]

Make NET_DSA_REALTEK_RTL8366RB_LEDS a hidden symbol.
It seems very unlikely user would want to intentionally
disable it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250228004534.3428681-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 10687722d14c0..d6eb6713e5f6b 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -44,7 +44,7 @@ config NET_DSA_REALTEK_RTL8366RB
 	  Select to enable support for Realtek RTL8366RB.
 
 config NET_DSA_REALTEK_RTL8366RB_LEDS
-	bool "Support RTL8366RB LED control"
+	bool
 	depends on (LEDS_CLASS=y || LEDS_CLASS=NET_DSA_REALTEK_RTL8366RB)
 	depends on NET_DSA_REALTEK_RTL8366RB
 	default NET_DSA_REALTEK_RTL8366RB
-- 
2.39.5



