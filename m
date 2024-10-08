Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99471DF728;
	Tue,  8 Oct 2024 12:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392254; cv=none; b=iqhfrahcnLt9AC4hx9dEEW0xTEfmA0Rnt/Uf1B8IEp2sLe7gNVC7pTdFPpZMJWgQmSv+k9dpn1rjmZdOnioyoKtD0lntk4LRWjxag403g8sm3uE/gBobxe4eni9PgxxABmVOqC+4rfzQ8P7ZS/yV3bbY8g5IOMxzLODzRqF4vaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392254; c=relaxed/simple;
	bh=SwDBiWCyxfm0uOoymBnzzlatXjXYWxjgPJl/ooXgius=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9ULypX5KJYSHGFd+Jfn6OrE8Zi9j2ucn+l+9sNzNfTZxitcEj4fqxoiYHguObLy6enKtmPCWse3dgNz/UJnfLfLYQ9e5edrm4iQl8P8Uw7yrXqh87ZywvmaQ3RNMi2+kYeI2SUbWtWwbKRfWp1K085V8q6a0rRsDSEstTY3PT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrqDb62C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrqDb62C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4972AC4CEC7;
	Tue,  8 Oct 2024 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392254;
	bh=SwDBiWCyxfm0uOoymBnzzlatXjXYWxjgPJl/ooXgius=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrqDb62C4n8dLrUs3Fugm7+/ohivFLDoArQmlko2zY509wtdVgET74VpdOiblY4ha
	 Ez7MGlTiWPevVCeXJ11j6yKHZ8eNroZCfJpxWz4MXdaeQPQswTFKn5ihM2SoT8JjaO
	 dKfP1x+pqg/Yy4ZmdsRyQKIl7XMAqOzjJk89lGFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Virag <virag.david003@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.11 361/558] dt-bindings: clock: exynos7885: Fix duplicated binding
Date: Tue,  8 Oct 2024 14:06:31 +0200
Message-ID: <20241008115716.504472759@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


