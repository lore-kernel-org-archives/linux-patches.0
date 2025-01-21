Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C21F561E;
	Tue, 21 Jan 2025 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482391; cv=none; b=kApDvrfiBUFLps4BIWRaHtdD3nEGQhn8hGibqyPtfzSG57vJEb1kQG5q0oeHM8G82MBpnY5LfRVnAYSmjQAtT17HGS/uR22ARpWoUJmImBHf/4eMT9UyGgRRxzge22hvPjVWSkJRmgWF2A4PEalQPIVlNLA3B0yy2baIMsPcv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482391; c=relaxed/simple;
	bh=thGXBkC61MdyeZF7R1QaNJtp1hFvUpfNwlh7kvLE1gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpIDRTj4t5yNhfR9fiS/mBAd0PiRDqJ7FRDQtp+ITNlsIPWP9r60+tAFXSvHcOllF5kcPfR2pECLFH++awxxnnUQ7bd7BKhsXu+Z6iz86vjWy99iG0WWr3qEeJqgFmEzUFBYf5iZ+eRQqqMtMGLbRrI6zlRFLaUuAL2zltZF+Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSr9Fkdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSr9Fkdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DC8C4CEDF;
	Tue, 21 Jan 2025 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482390;
	bh=thGXBkC61MdyeZF7R1QaNJtp1hFvUpfNwlh7kvLE1gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSr9FkdpboZdiJMiCru1CXK6bN5kedsJivJprq0LaqJ0Yfl/87Zp5WXTi0HDRFJzw
	 CxIWkXrW7a86wIJvVaF3AHO6mBtzimOUO8NZ1SSBusUDbC6k2PiWZ0px1y7Nzd3rPu
	 l1WgqqlMbwIj2SAJ9zDTXshUAyEsz2K2nXQAT8DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/122] drm/tests: helpers: Fix compiler warning
Date: Tue, 21 Jan 2025 18:51:21 +0100
Message-ID: <20250121174534.264451485@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit b9097e4c8bf3934e4e07e6f9b88741957fef351e ]

Delete one line break to make the format correct, resolving the
following warning during a W=1 build:

>> drivers/gpu/drm/tests/drm_kunit_helpers.c:324: warning: bad line: for a KUnit test

Fixes: caa714f86699 ("drm/tests: helpers: Add helper for drm_display_mode_from_cea_vic()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501032001.O6WY1VCW-lkp@intel.com/
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Tested-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250104165134.1695864-1-eleanor15x@gmail.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_kunit_helpers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_kunit_helpers.c b/drivers/gpu/drm/tests/drm_kunit_helpers.c
index 04a6b8cc62ac6..3c0b7824c0be3 100644
--- a/drivers/gpu/drm/tests/drm_kunit_helpers.c
+++ b/drivers/gpu/drm/tests/drm_kunit_helpers.c
@@ -320,8 +320,7 @@ static void kunit_action_drm_mode_destroy(void *ptr)
 }
 
 /**
- * drm_kunit_display_mode_from_cea_vic() - return a mode for CEA VIC
-					   for a KUnit test
+ * drm_kunit_display_mode_from_cea_vic() - return a mode for CEA VIC for a KUnit test
  * @test: The test context object
  * @dev: DRM device
  * @video_code: CEA VIC of the mode
-- 
2.39.5



