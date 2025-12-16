Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA9346E7B;
	Tue, 16 Dec 2025 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886323; cv=none; b=MMvnLpI/l9UunaOaG2sZTQN+kdBsj47tQJrP5n827vduxptBBGl6gb9cfLJa6AMskuOUbpZjToWsbrn3zndVdX0i9mR8oViGG9CK6vw5CFbz4yeV13uyX+tA/JgBhVK3O8XMqpsGoPlkMftHnaeY+edtBDpovl5uzQ1JlS8qoVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886323; c=relaxed/simple;
	bh=jJQdRgRfozLROvCzBa7f4BR4B5hkuwrFRETdmmvNIj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl1XNo1nNyiAnMK0nW4lyYojFFN3EUIOpoSLSaCc6NpusC7gLc9s71VL84YKWgRCaQ9a4BH/ECgt3Pxyo6xEqLV+V+IvKWddy2d4KJYPtzIc9iVWGQQgt5B3z//rpmejNxbKo+KqX2aV0mrDZy4lo4VvKp5L3K4Y8p4biNiveAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibLEcZE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibLEcZE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F78C19423;
	Tue, 16 Dec 2025 11:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886323;
	bh=jJQdRgRfozLROvCzBa7f4BR4B5hkuwrFRETdmmvNIj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibLEcZE+j9V0SIqWqnuIt1RZnihI/NGiSf/aIbafuJ93lf6mBHxQdxg+uog6Jajsk
	 YIA7SukcIbKREYMGZghC7V+AoAews8DD6t2wckSf54UjAHQVJCg9oKNbiHL7Pvly1n
	 sfl42UQjLgoY5R5t9NphaHpCryV1m9FqqcTUydxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 386/507] ARM: dts: samsung: universal_c210: turn off SDIO WLAN chip during system suspend
Date: Tue, 16 Dec 2025 12:13:47 +0100
Message-ID: <20251216111359.442452019@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 97aee67e2406ea381408915e606c5f86448f3949 ]

Commit 8c3170628a9c ("wifi: brcmfmac: keep power during suspend if board
requires it") changed default behavior of the BRCMFMAC driver, which now
keeps SDIO card powered during system suspend to enable optional support
for WOWL. This feature is not supported by the legacy Exynos4 based
boards and leads to WLAN disfunction after system suspend/resume cycle.
Fix this by annotating SDIO host used by WLAN chip with
'cap-power-off-card' property, which should have been there from the
beginning.

Fixes: f1b0ffaa686f ("ARM: dts: exynos: Enable WLAN support for the UniversalC210 board")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20251126102618.3103517-2-m.szyprowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts b/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
index bdc30f8cf748f..91490693432b6 100644
--- a/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/samsung/exynos4210-universal_c210.dts
@@ -610,6 +610,7 @@ &sdhci_3 {
 	#size-cells = <0>;
 
 	non-removable;
+	cap-power-off-card;
 	bus-width = <4>;
 	mmc-pwrseq = <&wlan_pwrseq>;
 	vmmc-supply = <&ldo5_reg>;
-- 
2.51.0



