Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6FB1DA60C;
	Tue,  8 Oct 2024 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390486; cv=none; b=SLH0LOuS48MqveffXtXP4L1qL4RYdVD2dd65jvYIQPEFZlONRD6GdoBhha3onIQjnnUjA7j5NmdxAnzsxbbDlI6wQ3aA6z+6a8tPXqaYlR+sd6pUVIT7rNPTf64ewdxfA2UnIo8xX/Fv+sApF4zHglrJG3IwLVy4tos5SL8Z5AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390486; c=relaxed/simple;
	bh=01I2Xl0jyLgXqc4/6GdgBiGrGiPwf/ai+FiZhaf26zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgWMhRrOC06STKNm2t32jAoj6d9XPpO+Ef9+w3tt5Tf5hSTlOsF4901TST8DGbfSws6LKdF/Adn0pmOr6N+NuOIsslfLworfdpTQ+EuOx32Tow8KIF6lCz6hIYNzGxxzWqB730am5IEZE1EJuoX1FlxU0spW/ZKjww3vbbikcac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRmmuT7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRmmuT7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE5AC4CEC7;
	Tue,  8 Oct 2024 12:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390485;
	bh=01I2Xl0jyLgXqc4/6GdgBiGrGiPwf/ai+FiZhaf26zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRmmuT7SHsd9ITE+ee1HRXG5VVjskHCuo/dPoLaXKfAgxJW2vy7NMLr2W2rWh3sYY
	 ZdP+Fgwwa/gD9QqwBR93Ih5/5zOb7mgQh0uvSLsszerm8lC3Vl4WNQ0CWGjMhWvZLB
	 rws2JAmMF6p5og7lRcAoFzk1owcQR6NkZJZDT1yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.10 304/482] dt-bindings: clock: exynos7885: Fix duplicated binding
Date: Tue,  8 Oct 2024 14:06:07 +0200
Message-ID: <20241008115700.399738937@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Virag <virag.david003@gmail.com>

commit abf3a3ea9acb5c886c8729191a670744ecd42024 upstream.

The numbering in Exynos7885's FSYS CMU bindings has 4 duplicated by
accident, with the rest of the bindings continuing with 5.

Fix this by moving CLK_MOUT_FSYS_USB30DRD_USER to the end as 11.

Since CLK_MOUT_FSYS_USB30DRD_USER is not used in any device tree as of
now, and there are no other clocks affected (maybe apart from
CLK_MOUT_FSYS_MMC_SDIO_USER which the number was shared with, also not
used in a device tree), this is the least impactful way to solve this
problem.

Fixes: cd268e309c29 ("dt-bindings: clock: Add bindings for Exynos7885 CMU_FSYS")
Cc: stable@vger.kernel.org
Signed-off-by: David Virag <virag.david003@gmail.com>
Link: https://lore.kernel.org/r/20240806121157.479212-2-virag.david003@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/clock/exynos7885.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/dt-bindings/clock/exynos7885.h
+++ b/include/dt-bindings/clock/exynos7885.h
@@ -136,12 +136,12 @@
 #define CLK_MOUT_FSYS_MMC_CARD_USER	2
 #define CLK_MOUT_FSYS_MMC_EMBD_USER	3
 #define CLK_MOUT_FSYS_MMC_SDIO_USER	4
-#define CLK_MOUT_FSYS_USB30DRD_USER	4
 #define CLK_GOUT_MMC_CARD_ACLK		5
 #define CLK_GOUT_MMC_CARD_SDCLKIN	6
 #define CLK_GOUT_MMC_EMBD_ACLK		7
 #define CLK_GOUT_MMC_EMBD_SDCLKIN	8
 #define CLK_GOUT_MMC_SDIO_ACLK		9
 #define CLK_GOUT_MMC_SDIO_SDCLKIN	10
+#define CLK_MOUT_FSYS_USB30DRD_USER	11
 
 #endif /* _DT_BINDINGS_CLOCK_EXYNOS_7885_H */


