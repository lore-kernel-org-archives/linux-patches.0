Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B062571AC;
	Tue, 25 Mar 2025 12:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906115; cv=none; b=LRraEd6QEtl/ft9zgMDH16XFWy45ZKshJnvfE5DmGkcfu80TWIRHXAvYDR2aa+nFbsDOeBxIVzNWeFSftv2HOp4y3udmfrn3vVj1up4b2STNKzv6KiV3iu9HBGvOZa6DXGnFxaI/VloeT5LgbLKGo94n6cfVVAT/ucm9wFLGfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906115; c=relaxed/simple;
	bh=VDhiAA8SNoZgNrsVJHiaZgn4RAudsHgDFFZyi2P/AAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5iSvGgxYJewcJUlrlJhJJM3EYevKcRXLahKAmYRD3yb8EUZ8wNDtJwquj+X1eJiSS8HTIHJkFRb5o8SirzCUaUIYPZ8VxcH74vJz9c+qZj1xg5kZ1UkAiH6nes9oL2JzXDXaO77VyDC+Il/PHVwwRRqSRsEx220raGRhVe9iuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13LboX0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13LboX0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F98C4CEED;
	Tue, 25 Mar 2025 12:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906115;
	bh=VDhiAA8SNoZgNrsVJHiaZgn4RAudsHgDFFZyi2P/AAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13LboX0IPdWZ0mWdQikFASn+cO0LyFMoip+hKJCeqHhFGFAbAVJFKb2zUfpPTjF9W
	 3JzjQ8Z5ttKHWVpGlW1HID/FkCRV2jkvn0C5YzDafnYawO2wzSdKClowDFtAthfaZI
	 187nSDPOJ2Qh9lF0dEMKZQxl6C2FNNwVd0BCGRss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/77] ARM: davinci: da850: fix selecting ARCH_DAVINCI_DA8XX
Date: Tue, 25 Mar 2025 08:22:17 -0400
Message-ID: <20250325122144.936056960@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 45d5fe1c53baaed1fb3043f45d1e15ebb4bbe86a ]

Chips in the DA850 family need to have ARCH_DAVINCI_DA8XX to be selected
in order to enable some peripheral drivers.

This was accidentally removed in a previous commit.

Fixes: dec85a95167a ("ARM: davinci: clean up platform support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 2a8a9fe46586d..3fa15f3422409 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -27,6 +27,7 @@ config ARCH_DAVINCI_DA830
 
 config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
+	select ARCH_DAVINCI_DA8XX
 	select DAVINCI_CP_INTC
 
 config ARCH_DAVINCI_DA8XX
-- 
2.39.5



