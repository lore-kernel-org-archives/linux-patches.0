Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E602BDC03;
	Wed, 25 Feb 2026 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002759; cv=none; b=r0NdFFjPomZnWs2DeQne46kNq6GcYomlyMryqH/q2hNoxNq7ciMdJxQhrvFxdCsiq3cImTP1cQ88JZA6Lw2XzFhaWq2Ba9Y8dRSddC61aZAUcSgCaBGyDSi/1rqUimhK2IdkYSBrlDMSS3TpgZOnW0L+HSoMM0A3/y8SdOY3mb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002759; c=relaxed/simple;
	bh=Yq1cG3+VatBPD1LUa2XXVOh4QjQAywe4c6qim2Qjqyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfsD/JYYg2xdml2ucrgKQww1yVqL08k1B03Yx52E0qOib+1ANjuBVOfTj/s1QO0aZt/wk9JiMFP8jMhn+qS2rrXkgQLZnGSaRVFIS1cxHwAXcSEDYvrR+f08GgqMdrofLG4Elmmt2EtOqSRJ1cpWMPOVQcUlL5vNzP8a8Fq0wOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYyLIVwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYyLIVwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3A5C116D0;
	Wed, 25 Feb 2026 06:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002759;
	bh=Yq1cG3+VatBPD1LUa2XXVOh4QjQAywe4c6qim2Qjqyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYyLIVwayRhdWg/N9Us78bDv8/TUGwXLodcz+35XcuOwsx0CqjcZkPtro1IBmBsXF
	 DdGJ7aiMoIFkpbglUiKXthKF9W6uV/EfXBPDx4TBMt9s1FRgMMBmRUH5QQquVFfX/y
	 2R0DTCgrQ11meG4l/g9i/eTesf9yUL74IczRC90E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 587/641] drm/i915/acpi: free _DSM package when no connectors
Date: Tue, 24 Feb 2026 17:25:13 -0800
Message-ID: <20260225012402.735288824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 57b85fd53fccfdf14ce7b36d919c31aa752255f8 ]

acpi_evaluate_dsm_typed() returns an ACPI package in pkg.
When pkg->package.count == 0, we returned without freeing pkg,
leaking memory. Free pkg before returning on the empty case.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Fixes: 337d7a1621c7 ("drm/i915: Fix invalid access to ACPI _DSM objects")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260109032549.1826303-1-kaushlendra.kumar@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit c0a27a0ca8a34e96d08bb05a2c5d5ccf63fb8dc0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/display/intel_acpi.c b/drivers/gpu/drm/i915/display/intel_acpi.c
index 1addd62882413..1e8b9d1756988 100644
--- a/drivers/gpu/drm/i915/display/intel_acpi.c
+++ b/drivers/gpu/drm/i915/display/intel_acpi.c
@@ -96,6 +96,7 @@ static void intel_dsm_platform_mux_info(acpi_handle dhandle)
 
 	if (!pkg->package.count) {
 		DRM_DEBUG_DRIVER("no connection in _DSM\n");
+		ACPI_FREE(pkg);
 		return;
 	}
 
-- 
2.51.0



