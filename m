Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE242E540B;
	Tue,  8 Jul 2025 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993570; cv=none; b=Dz77QPp0GeLvrdwAun0F6PsZ2muC7UkA4/s2yk9v0TphCtd5hefrOcmFBwdTiICEfovo26gZEEYqVDAHZxWGH9YyVzCMeqpSC0wimB6pUJeG4vILMS6nHYxNmaugnO95VSgacg71VHrUzL4bjJA754gtzAmdJWfHYyJhYXZ9rms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993570; c=relaxed/simple;
	bh=qSRpsC7DHJQudXRrYq8jHViiyS3RwlxaLU/4cb2/FfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRxC0nuS6V/1BEmV37ZrUSNCh/oql9FKbeMNJkeCxBgWJBfg18ETrSdBL4tWQSM4e6k2bqV+7mbkMS/APVRS9vMo8e+2Xf72JkA+k99VqoTObpitqrmwjhl6hSfgJWMDmW2cjVnpcoD8BcLRZXJlh76rCxhSQ8j8Qc+cOC19yhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bip3P8rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bip3P8rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D05C4CEED;
	Tue,  8 Jul 2025 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993569;
	bh=qSRpsC7DHJQudXRrYq8jHViiyS3RwlxaLU/4cb2/FfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bip3P8rbu/SYjxVXB8puG/2z87wtP5lKqDOfNinDd8n43h245verpDMBq178B3EVt
	 mtSCv1IKWTKlF48kb5xmUPl5QStCjipk/sLYJZT9i2nixqe8TmXnstyQdkjXLAv1ER
	 YlLu712G9hEDbX7SovCe2ztkkCBbaI0Ve8udXqhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Harry Austen <hpausten@protonmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 120/178] drm/xe: Allow dropping kunit dependency as built-in
Date: Tue,  8 Jul 2025 18:22:37 +0200
Message-ID: <20250708162239.737765907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Austen <hpausten@protonmail.com>

[ Upstream commit aa18d5769fcafe645a3ba01a9a69dde4f8dc8cc3 ]

Fix Kconfig symbol dependency on KUNIT, which isn't actually required
for XE to be built-in. However, if KUNIT is enabled, it must be built-in
too.

Fixes: 08987a8b6820 ("drm/xe: Fix build with KUNIT=m")
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Harry Austen <hpausten@protonmail.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20250627-xe-kunit-v2-2-756fe5cd56cf@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit a559434880b320b83733d739733250815aecf1b0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/Kconfig b/drivers/gpu/drm/xe/Kconfig
index 9a46aafcb33ba..0dc3512876b3a 100644
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config DRM_XE
 	tristate "Intel Xe Graphics"
-	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
+	depends on DRM && PCI && MMU
+	depends on KUNIT || !KUNIT
 	depends on INTEL_VSEC || !INTEL_VSEC
 	depends on X86_PLATFORM_DEVICES || !(X86 && ACPI)
 	select INTERVAL_TREE
-- 
2.39.5



