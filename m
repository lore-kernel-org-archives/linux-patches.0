Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BA726A08F;
	Tue, 16 Dec 2025 11:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884648; cv=none; b=M+Hgg16UKj+xw1AUeKkl/u73MUMAHg3bmyob5XVJK0luWZKXyCjhsoM57DlUJdQdu3GJGrRh29kL/j4YmLlPASwEUefT0wbYXqOwwzUtL0BcY3qUZ89FvIJdddsTQSkhvm+kOfP+BrZBcY0WvekBOiFNlUZcwjYfOX6NUFlSjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884648; c=relaxed/simple;
	bh=xdbWwxOCt6VEYahmOeOtBYH/PVHgZR4M8OetVfhoRcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJDHVn4GJLAA0h7CynbinjJxL+tgSDxLpeUF3lME3N8smXW4Q8sMWyM3ZtcejgpQgwtfVTCzRjnQz1WDDk1a9dFx+fozc18W6BzZSFSN77eVRR9LDWUajJXr6Q4DAAxZuYPqJpI1hNYF2OIahCtzmOpAehsb/3ZfO0XsLTlFEx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5DQo3bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5DQo3bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732FCC4CEF1;
	Tue, 16 Dec 2025 11:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884647;
	bh=xdbWwxOCt6VEYahmOeOtBYH/PVHgZR4M8OetVfhoRcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5DQo3bzMBeGiPWCl7Qf8DD/KgcNtzD66NTkPBaExKp9n9RIiqUkGdavviy48aNKG
	 EYB1JtkrUueymuaLT0vVH+DCjzI9wN+AnxN4YJwck3jS4yNzdL3rAnoUWsoBggNKTg
	 L1L+6W1VTPgX8QG4jUa/1S/y0VNrULDz9JnSEMfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/354] ARM: dts: samsung: exynos4210-i9100: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:13:45 +0100
Message-ID: <20251216111330.265321639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 863d69923bdb6f414d0a3f504f1dfaeacbc00b09 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-3-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4210-i9100.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
index 0d8495792a702..0394b948443b3 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-i9100.dts
@@ -853,6 +853,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&vtf_reg>;
-- 
2.51.0



