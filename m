Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E0214A088;
	Wed,  5 Feb 2025 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765596; cv=none; b=e9NxtorkI/+xzszngCm/FqCCJvS7jvG/phDBZ+ensyv79n1g3zxZs0fA/MjC6VrTB24jzQLwmVPGIuPEuS7pVXS8xh3q6mmD3JBnG1/CPWoNEIvtIPGQFNwxYzR3yRbRa1GolfJtgjXPZXWmjAFMrWCG6ZRIbtLbIZwAmrwe66Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765596; c=relaxed/simple;
	bh=DDuzxaRDm/ONejRTV0TE81oV7xcFmgIarSXWezWueIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H00LpqvhcIQDdi3exxp++6wrrIy1m5kyczoUT4v0TMwUYL7Or/NScMhCa7gACT+vWXnl5V7OIxzhzLlATF5lA6FSAEmjx7yI1L3BHlbvlzc8sCEMuN1baqLuNXo3uRBVMhfiKDdO08Dd3fcLbkWRQ/B4rGU0p6SPGd+0FPS+a9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGWrYJGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGWrYJGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44026C4CED1;
	Wed,  5 Feb 2025 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765596;
	bh=DDuzxaRDm/ONejRTV0TE81oV7xcFmgIarSXWezWueIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGWrYJGe9YptpZYjSbHlXRMBcpMoOAXfcjzN0ShDQLSLFpdWDtvgADd99MN3IX+WI
	 JTJaxLzHoXMZYGiHsiGRI316NREraD2gdYg1U8b98msf/TMx8+XIEQIXx9F53bQMjH
	 lIGtZYzXZAh27zRYvl1LjpThGl7zy1WQhGANqAJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/590] platform/x86: x86-android-tablets: make platform data be static
Date: Wed,  5 Feb 2025 14:39:50 +0100
Message-ID: <20250205134504.271380156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



