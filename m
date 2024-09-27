Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB011865ED;
	Fri, 27 Sep 2024 12:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440117; cv=none; b=QZhazkpSe/bw0DhVLOp9EJdlJOIdc6MS5tCEoIXW0MmxmjFBwmzaD0+NKKO+XJZOaAGNqzKmbb3PCBn2fPLdSALcguzQs1APIqKvSVQTnZcjPfiO4u9RgT99/L0Fg/iLXViubldKLYl3gI/GxlWWVDkFtqFFTlRE9kRb2QaAyjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440117; c=relaxed/simple;
	bh=KY8dKhyDSm1qZS6wh4d1rfFHRpPq23nKLZ/oCXwDvmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eUzm2e/+wW3Z6gHEqd8sQYiiQCIKDNahyjEKrSp/TgCIpJ8UT8eJ4jgAmHYiZuI5ACTr5ZcYYmsf/iEpcHRAoiX9fp+UIYs2si5Eko0gX7Z7xaFDefobXwJ87dNRjz0YmX2RZYYm7bFnZuLal1osAim9rtMaLPx/Xgn8BnvoVS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEoBdA2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEoBdA2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1F0C4CEC4;
	Fri, 27 Sep 2024 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440117;
	bh=KY8dKhyDSm1qZS6wh4d1rfFHRpPq23nKLZ/oCXwDvmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEoBdA2OYT2pGxzwho/m+wkhsq8jgHG4Y2zZUtUv8GQEfNLmbdMOOqMWeZwOczPYp
	 ytR9I335+gPLQR/LtUnh606JkqK4kUKfRtR8EfNdXPC27lz6mOQhWPK7qxx5HxUFqD
	 y4Vc+Kv+i2M524o/94zP8aurOuONuOSwbPLVb7A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 38/58] platform/x86/amd: pmf: Make ASUS GA403 quirk generic
Date: Fri, 27 Sep 2024 14:23:40 +0200
Message-ID: <20240927121720.323255491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit d34af755a533271f39cc7d86e49c0e74fde63a37 ]

The original quirk should match to GA403U so that the full
range of GA403U models can benefit.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20240831003905.1060977-1-luke@ljones.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/pmf-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/pmf-quirks.c b/drivers/platform/x86/amd/pmf/pmf-quirks.c
index 460444cda1b29..48870ca52b413 100644
--- a/drivers/platform/x86/amd/pmf/pmf-quirks.c
+++ b/drivers/platform/x86/amd/pmf/pmf-quirks.c
@@ -25,7 +25,7 @@ static const struct dmi_system_id fwbug_list[] = {
 		.ident = "ROG Zephyrus G14",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GA403UV"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA403U"),
 		},
 		.driver_data = &quirk_no_sps_bug,
 	},
-- 
2.43.0



