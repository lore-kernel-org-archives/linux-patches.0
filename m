Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5387DA6A;
	Wed,  5 Feb 2025 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766142; cv=none; b=ogUVVOZrgvricP0qgz9YK7QbPMCoqQj6tK9HKm2YzjLiZb2tHyEwn7IsfojaprwI3+yIc/mjsqfsa8bDnB2O727Mh9ArDRp8wY5XcnkKBWLdqvZqyhpuaSQZ+kEna+h81lh03v/0jZc00YsFMQDpRAsykyWVM6qP8M4WeHFHecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766142; c=relaxed/simple;
	bh=xlmhOtS1GSNXMVjmq51FUb/rJDiIe4++xFz5gkPLjac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QK9Ar7EoEc/84tTIc2BtD4C7oQ55Dz30TpYimRrrwDQYnH021Uhx/5DeXWDSn5tSYWAdvV3/Sx6F/OAOnJCAj0ECqnkXqyXXKmCIea4ky0Du9NeaEBSiEZPahIDPQms4e8mPjE0JBaeLQCmTQWDQ7hf7QQAV2+4pJhZjF0nag0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObdfoupB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObdfoupB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC08C4CED1;
	Wed,  5 Feb 2025 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766142;
	bh=xlmhOtS1GSNXMVjmq51FUb/rJDiIe4++xFz5gkPLjac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObdfoupBTtx0BNbT8s5TyIOzEZ1oTLPOpVrEwiAQMuQAUbtoHjn/RdC+Uvz9D7RqC
	 MAVkQKqklG3emJhHmc7/S8kY5E092saPGNNxMY2H022V78pGZBOcuICpHnvlXMbVBT
	 WNnCy3eSJsg8AumgBLYpQ7r3XjRBn6FRPW+G1UG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 246/623] platform/x86: x86-android-tablets: make platform data be static
Date: Wed,  5 Feb 2025 14:39:48 +0100
Message-ID: <20250205134505.637544378@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 6e0fb1bdb71cf8078c8532617e565e3db22c0d3c ]

make lenovo_yoga_tab2_1380_bq24190_pdata and lenovo_yoga_tab2_1380_modules
to be static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410160432.oJAPbrW9-lkp@intel.com/
Fixes: 3eee73ad42c3 ("platform/x86: x86-android-tablets: Add Lenovo Yoga Tablet 2 Pro 1380F/L data")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/daafd1371e7e9946217712ce8720e29cd5c52f7a.1732161310.git.xiaopei01@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/lenovo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/lenovo.c b/drivers/platform/x86/x86-android-tablets/lenovo.c
index ae087f1471c17..a60efbaf4817f 100644
--- a/drivers/platform/x86/x86-android-tablets/lenovo.c
+++ b/drivers/platform/x86/x86-android-tablets/lenovo.c
@@ -601,7 +601,7 @@ static const struct regulator_init_data lenovo_yoga_tab2_1380_bq24190_vbus_init_
 	.num_consumer_supplies = 1,
 };
 
-struct bq24190_platform_data lenovo_yoga_tab2_1380_bq24190_pdata = {
+static struct bq24190_platform_data lenovo_yoga_tab2_1380_bq24190_pdata = {
 	.regulator_init_data = &lenovo_yoga_tab2_1380_bq24190_vbus_init_data,
 };
 
@@ -726,7 +726,7 @@ static const struct platform_device_info lenovo_yoga_tab2_1380_pdevs[] __initcon
 	},
 };
 
-const char * const lenovo_yoga_tab2_1380_modules[] __initconst = {
+static const char * const lenovo_yoga_tab2_1380_modules[] __initconst = {
 	"bq24190_charger",            /* For the Vbus regulator for lc824206xa */
 	NULL
 };
-- 
2.39.5



