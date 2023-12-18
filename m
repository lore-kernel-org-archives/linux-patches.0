Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6318129ED2;
	Mon, 18 Dec 2023 13:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSFx8+IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6A4C433C8;
	Mon, 18 Dec 2023 13:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907619;
	bh=udycksz3hEP0N45cKp96DPgNuhjSksDQuhnNmK+YHjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSFx8+IS7i29sA9KUTdWIBkGhImo383d0cRJU8FSgzzXmmhc9S1XKdOZe0DJGudtY
	 Dfc3W5YedkODiJmpXtLgC3zAQparTb/Y8vOXBwxaa6ZbfbLPApzsWW1hN40kZ2nb5u
	 vdgNZ+GSuGEB+r6DrXiYu7D6YZKnMbMuuScKH27A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/36] platform/x86: intel_telemetry: Fix kernel doc descriptions
Date: Mon, 18 Dec 2023 14:51:32 +0100
Message-ID: <20231218135042.618141313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
References: <20231218135041.876499958@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a6584711e64d9d12ab79a450ec3628fd35e4f476 ]

LKP found issues with a kernel doc in the driver:

core.c:116: warning: Function parameter or member 'ioss_evtconfig' not described in 'telemetry_update_events'
core.c:188: warning: Function parameter or member 'ioss_evtconfig' not described in 'telemetry_get_eventconfig'

It looks like it were copy'n'paste typos when these descriptions
had been introduced. Fix the typos.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310070743.WALmRGSY-lkp@intel.com/
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120150756.1661425-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_telemetry_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_telemetry_core.c b/drivers/platform/x86/intel_telemetry_core.c
index f378621b5fe9d..31bbfb5d24631 100644
--- a/drivers/platform/x86/intel_telemetry_core.c
+++ b/drivers/platform/x86/intel_telemetry_core.c
@@ -110,7 +110,7 @@ static const struct telemetry_core_ops telm_defpltops = {
 /**
  * telemetry_update_events() - Update telemetry Configuration
  * @pss_evtconfig: PSS related config. No change if num_evts = 0.
- * @pss_evtconfig: IOSS related config. No change if num_evts = 0.
+ * @ioss_evtconfig: IOSS related config. No change if num_evts = 0.
  *
  * This API updates the IOSS & PSS Telemetry configuration. Old config
  * is overwritten. Call telemetry_reset_events when logging is over
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(telemetry_reset_events);
 /**
  * telemetry_get_eventconfig() - Returns the pss and ioss events enabled
  * @pss_evtconfig: Pointer to PSS related configuration.
- * @pss_evtconfig: Pointer to IOSS related configuration.
+ * @ioss_evtconfig: Pointer to IOSS related configuration.
  * @pss_len:	   Number of u32 elements allocated for pss_evtconfig array
  * @ioss_len:	   Number of u32 elements allocated for ioss_evtconfig array
  *
-- 
2.43.0



