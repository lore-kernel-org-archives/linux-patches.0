Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5FA847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B33C433EF;
	Fri, 10 Mar 2023 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456783;
	bh=enrpPGyCyXmJUJ1zT9AXYi/ZX6uyEVhhZZIeMLKtn7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywq3qyxUSpKZ21w9NYJvfsgMNHBFPzrcUxDJ69VVz3Ejc8dyHE7m14GIzBvkSj+1y
	 ozOJyHbBjvd1OXzMRkLkW5+KrBYuzXaDVCSP3I8nQfMd6qOpTwTaBiuLz3R0AlCmJW
	 WwhOJ45agmN0NhWDtQsbCTyfi9iAv1A4lBXa3kwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 123/211] thermal: intel: BXT_PMIC: select REGMAP instead of depending on it
Date: Fri, 10 Mar 2023 14:38:23 +0100
Message-Id: <20230310133722.469398039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1467fb960349dfa5e300658f1a409dde2cfb0c51 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: b474303ffd57 ("thermal: add Intel BXT WhiskeyCove PMIC thermal driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/Kconfig b/drivers/thermal/intel/Kconfig
index f0c8456792509..e3cfad10d5dd4 100644
--- a/drivers/thermal/intel/Kconfig
+++ b/drivers/thermal/intel/Kconfig
@@ -64,7 +64,8 @@ endmenu
 
 config INTEL_BXT_PMIC_THERMAL
 	tristate "Intel Broxton PMIC thermal driver"
-	depends on X86 && INTEL_SOC_PMIC_BXTWC && REGMAP
+	depends on X86 && INTEL_SOC_PMIC_BXTWC
+	select REGMAP
 	help
 	  Select this driver for Intel Broxton PMIC with ADC channels monitoring
 	  system temperature measurements and alerts.
-- 
2.39.2



