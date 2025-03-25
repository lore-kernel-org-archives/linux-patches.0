Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C70269AF1;
	Tue, 25 Mar 2025 12:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906080; cv=none; b=WaZQnHVBlZD/QLgJ8T7+JOUuukedYuK6Vc4iXKYUEsUyeAHBV7J8HBcOmtBrOF7rZiHSBaI4KV69FxqdcND8WF9h61WaybjObZj9Im6MIMUYF8IlOCzhqoVhbOTddpb4Pue/FBhNF5CWVEsuS1vuhSOSP92wI2KXPZU7F6a6TU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906080; c=relaxed/simple;
	bh=eyds6wM7M6uzmEB3D/lGJdA3lnfmbZH9CI7rCO93Rpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwuIpnONMkyo0exCMbalYHKXIAmXUs3IhpHJi6ord+o8YB4VLZRMRK9UBSEekWtdguVq/ZsoBmIVoPU+DfDO8bvydARoGIS3YWkCeziq7jj+zrnnY69w4vbNgUmm/nTAGBFaksgHy1Djob5JgT/hC20AaWiD5mQV5NE20i5qDCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkKfF0Uo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkKfF0Uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4F6C4CEE4;
	Tue, 25 Mar 2025 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906079;
	bh=eyds6wM7M6uzmEB3D/lGJdA3lnfmbZH9CI7rCO93Rpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkKfF0UoehMx5+tSkCQ21ErhhqJcm6RufWRqNrC0rkbrsRfb7/atKoAzyfbe4Cdz7
	 V0vqU1o821qGZpZN3AecFpqO7RA++Of0PASAqTM5TnpacucJwRydE0mY/cCl2COELa
	 fBYH2CXEjw+JyncdHjj34b7Q2qvRYGhJzhTrDEcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.13 093/119] pmdomain: amlogic: fix T7 ISP secpower
Date: Tue, 25 Mar 2025 08:22:31 -0400
Message-ID: <20250325122151.437472884@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

commit ef17b519088ee0c167cf507820609732ec8bad1a upstream.

ISP and MIPI_ISP, these two have a parent-child relationship,
ISP depends on MIPI_ISP.

Fixes: ca75e4b214c6 ("pmdomain: amlogic: Add support for T7 power domains controller")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250303-fix-t7-pwrc-v1-1-b563612bcd86@amlogic.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/amlogic/meson-secure-pwrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/amlogic/meson-secure-pwrc.c
+++ b/drivers/pmdomain/amlogic/meson-secure-pwrc.c
@@ -221,7 +221,7 @@ static const struct meson_secure_pwrc_do
 	SEC_PD(T7_VI_CLK2,	0),
 	/* ETH is for ethernet online wakeup, and should be always on */
 	SEC_PD(T7_ETH,		GENPD_FLAG_ALWAYS_ON),
-	SEC_PD(T7_ISP,		0),
+	TOP_PD(T7_ISP,		0, PWRC_T7_MIPI_ISP_ID),
 	SEC_PD(T7_MIPI_ISP,	0),
 	TOP_PD(T7_GDC,		0, PWRC_T7_NIC3_ID),
 	TOP_PD(T7_DEWARP,	0, PWRC_T7_NIC3_ID),


