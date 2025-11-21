Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92D131578E;
	Fri, 21 Nov 2025 13:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731465; cv=none; b=IJXMpzDHClJCUmRuH8upJPDuKyH/4W55TQbTbV81JdI2CG+AbXjIqjrWU8CjnTxsDmnpCWI1YyQ0U+ZW+Hgr8qumeB3ePQCNJbDwa7p1tVXWDNKbFv6w1l/LDuvthnjNSKeswNP+KW4+d1ANQ8zzn7sTZBrGGCh/6yFwn/YRWQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731465; c=relaxed/simple;
	bh=1jPEKcaGvnY4tBXJSX7zQpRXDuqy07sU66iciVmL8uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amtWnc/xLfwZvyZRFHOGJwWtcRV6W3WPBMdnC7q2vbqIJjD+wHi22tghD7+16o2VzxNhKW0mnfCM2lzfx7Zgkd4M7FNjWiceEjwBkmxtHunumZ/CXZc2G0P8hijuzCjWNDW66/jUv5ZtguhmAH9C+4jKmt1av9tQigA7veNAPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls4H9xsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls4H9xsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094CBC4CEF1;
	Fri, 21 Nov 2025 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731465;
	bh=1jPEKcaGvnY4tBXJSX7zQpRXDuqy07sU66iciVmL8uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ls4H9xsZRFBPZtputMgSR7z0UMwfVB4MDwXFZ4b2FXlsxRgwKQSSE6M1Vli18JY1u
	 t1iRR955dhmemYZg6aF8I/PM7jyAHeJtc+wp/ktItBL5oOmK6r2tZl6nYUOavLulPI
	 CoYPbaHPJnnWAuDrWGjftv+QVn5KU4T4Yb6PjT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Alexey Charkov <alchark@gmail.com>,
	Hugh Cole-Baker <sigmaris@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 190/247] mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4
Date: Fri, 21 Nov 2025 14:12:17 +0100
Message-ID: <20251121130201.542591476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit a28352cf2d2f8380e7aca8cb61682396dca7a991 upstream.

strbin signal delay under 0x8 configuration is not stable after massive
test. The recommandation of it should be 0x4.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Tested-by: Alexey Charkov <alchark@gmail.com>
Tested-by: Hugh Cole-Baker <sigmaris@gmail.com>
Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -94,7 +94,7 @@
 #define DLL_TXCLK_TAPNUM_DEFAULT	0x10
 #define DLL_TXCLK_TAPNUM_90_DEGREES	0xA
 #define DLL_TXCLK_TAPNUM_FROM_SW	BIT(24)
-#define DLL_STRBIN_TAPNUM_DEFAULT	0x8
+#define DLL_STRBIN_TAPNUM_DEFAULT	0x4
 #define DLL_STRBIN_TAPNUM_FROM_SW	BIT(24)
 #define DLL_STRBIN_DELAY_NUM_SEL	BIT(26)
 #define DLL_STRBIN_DELAY_NUM_OFFSET	16


