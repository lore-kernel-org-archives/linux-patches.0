Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0534FF66;
	Tue,  6 Jan 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720122; cv=none; b=pV0n6EhElaxeIv7reltctYAcdjPu6MO1hGnHc+mjgWjwTYaMS+4bfTVQRGMTkeZnF6LzlNidjq/OcHuTMMUwBSYE0eSW0Im83hiqrywNHKSWTAFB2jJVqzsx9c8iO4ePdp9BQ06cui+AZQbp1vS0/AnFAlT8aFrw6CEAJGUSqRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720122; c=relaxed/simple;
	bh=hxia4oB1gKOFCFUracMyOs3zog3WqjNk4Uq5TDVgv6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq+BtttMsSezWVmgBFwNd+P0n5mSLoVWW2h5v9+mX5DxsS44RPA6cWjVBWC8qYklnqWCZh508IUk0bxbn7ysstBR3cMHoACGizSC7yYyQ/rVzxBNoaA9YpO58bjRl1/OtHHLDO2PF8a56bIdajcD3trlYUkjM/UYMginNOugXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyFNod5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyFNod5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFBBC116C6;
	Tue,  6 Jan 2026 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720122;
	bh=hxia4oB1gKOFCFUracMyOs3zog3WqjNk4Uq5TDVgv6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyFNod5yfcEEJ+JaBGcUI9n6MSAPEIkZv4XfGffP+zVCTSPDC23sUY+UAHGJ25KOG
	 n5ZJnLgTz8zIxwoeE+Pk5wX89qMxdoqTp2qhtYUa6ege+MlacB1R1JOzqCb5aCTQjG
	 oE1FJZ1FNPigMdujemE8rqp/2IA5/U+Kkc557f04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 108/567] mmc: sdhci-of-arasan: Increase CD stable timeout to 2 seconds
Date: Tue,  6 Jan 2026 17:58:10 +0100
Message-ID: <20260106170455.324239907@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

commit a9c4c9085ec8ce3ce01be21b75184789e74f5f19 upstream.

On Xilinx/AMD platforms, the CD stable bit take slightly longer than
one second(about an additional 100ms) to assert after a host
controller reset. Although no functional failure observed with the
existing one second delay but to ensure reliable initialization, increase
the CD stable timeout to 2 seconds.

Fixes: e251709aaddb ("mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-arasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -99,7 +99,7 @@
 #define HIWORD_UPDATE(val, mask, shift) \
 		((val) << (shift) | (mask) << ((shift) + 16))
 
-#define CD_STABLE_TIMEOUT_US		1000000
+#define CD_STABLE_TIMEOUT_US		2000000
 #define CD_STABLE_MAX_SLEEP_US		10
 
 /**


