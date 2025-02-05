Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB732151988;
	Wed,  5 Feb 2025 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766360; cv=none; b=CD5WBsaoZaJdS2Tnw7czcJyaJpZsGcikUDuOGetQEHHA7szCFDwljaR2NPWy35xIkiy3fEfvt5+XzJea6YQ/nABIlQLTaUjfbnlZ5fom828Odbw4etXyDKgSn+m+0xQ8GKGQP92ou/E7VUFosdQgtUUtpg3EPkd8wZ4Xx1EeeMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766360; c=relaxed/simple;
	bh=BklsNzgkkuJ7ZHAU0p1xtYkuZnsSuD84V/MUeyxltd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emybjuPWtW2YkT/jeJFi1XjJRTvyp4sbdGwpG+DSgE+eXT7Hz1UO5sTittpB4vqoilsmLt88l3DiKF7q1XwzzJ4M6RzzTATASOxNGeHebhVfz9nyxRW0HvKFfRCnd2qBQEti0S3EnNI9BYx102GsgMajZO1IAnSuAWCjyM3kh/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEB7znQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEB7znQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0CAC4CED1;
	Wed,  5 Feb 2025 14:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766360;
	bh=BklsNzgkkuJ7ZHAU0p1xtYkuZnsSuD84V/MUeyxltd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEB7znQZRnRHc6mxP5438F60sq41EtMPVkooycHlCNzTtsob+juEs4HA7WwiNrqnH
	 PwiIcwca+4HI2GVTpaRC/TkWMuCvUKm+0p7Y6gQN9Envfw8dy3Re970IZxit+Xc8Zy
	 wM7vuoVpySN8QARI8E3WNNKxpRtFzkGmijJs1TfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 266/623] platform/x86: x86-android-tablets: Make variables only used locally static
Date: Wed,  5 Feb 2025 14:40:08 +0100
Message-ID: <20250205134506.406743191@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f6728073baa172be6223512fffd72796de891536 ]

Commit 06f876def346 ("platform/x86: x86-android-tablets: Add support for
Vexia EDU ATLA 10 tablet") omitted the static keyword from some variables
which are only used inside other.c .

Add the missing static keyword to these, this fixes the following warnings:

.../x86-android-tablets/other.c:605:12: sparse: sparse: symbol 'crystal_cove_pwrsrc_psy' was not declared. Should it be static?
.../x86-android-tablets/other.c:612:28: sparse: sparse: symbol 'vexia_edu_atla10_ulpmc_node' was not declared. Should it be static?

Fixes: 06f876def346 ("platform/x86: x86-android-tablets: Add support for Vexia EDU ATLA 10 tablet")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411301001.1glTy7Xm-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204204227.95757-3-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/other.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/other.c b/drivers/platform/x86/x86-android-tablets/other.c
index 735df818f76bf..3cd0db74c6c9c 100644
--- a/drivers/platform/x86/x86-android-tablets/other.c
+++ b/drivers/platform/x86/x86-android-tablets/other.c
@@ -602,14 +602,14 @@ const struct x86_dev_info whitelabel_tm800a550l_info __initconst = {
  * Vexia EDU ATLA 10 tablet, Android 4.2 / 4.4 + Guadalinex Ubuntu tablet
  * distributed to schools in the Spanish Andalucía region.
  */
-const char * const crystal_cove_pwrsrc_psy[] = { "crystal_cove_pwrsrc" };
+static const char * const crystal_cove_pwrsrc_psy[] = { "crystal_cove_pwrsrc" };
 
 static const struct property_entry vexia_edu_atla10_ulpmc_props[] = {
 	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", crystal_cove_pwrsrc_psy),
 	{ }
 };
 
-const struct software_node vexia_edu_atla10_ulpmc_node = {
+static const struct software_node vexia_edu_atla10_ulpmc_node = {
 	.properties = vexia_edu_atla10_ulpmc_props,
 };
 
-- 
2.39.5



