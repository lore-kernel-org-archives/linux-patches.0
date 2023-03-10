Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E332F36
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E25FC433D2;
	Fri, 10 Mar 2023 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458604;
	bh=UszNZULP8SX9tR1oLOSCJpA7L4oX4LpBoTgnhNMxF9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1UVK5Or59kehbfcujfmNSmqIBFFJ8+wUkIoxBsyC32qKAc+eSmrDoCc3RZiEF1JK
	 /rxhCJBCeF7/wIPCCHZFpU95Xg2TeSFgcNQz9vRhqKg+bufiCvrtj7DmgjUrSoHlXV
	 mW10Ulx/UEAmV9TUeztjQQRTxc5dew0F6OM8zkDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/357] m68k: /proc/hardware should depend on PROC_FS
Date: Fri, 10 Mar 2023 14:36:10 +0100
Message-Id: <20230310133737.562469417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 1e5b5df65af99013b4d31607ddb3ca5731dbe44d ]

When CONFIG_PROC_FS is not set, there is a build error for an unused
function. Make PROC_HARDWARE depend on PROC_FS to prevent this error.

In file included from ../arch/m68k/kernel/setup.c:3:
../arch/m68k/kernel/setup_mm.c:477:12: error: 'hardware_proc_show' defined but not used [-Werror=unused-function]
  477 | static int hardware_proc_show(struct seq_file *m, void *v)
      |            ^~~~~~~~~~~~~~~~~~

Fixes: 66d857b08b8c ("m68k: merge m68k and m68knommu arch directories") # v3.0
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20230209010825.24136-1-rdunlap@infradead.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.devices | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 3e9b0b826f8a1..6fb693bb0771c 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -19,6 +19,7 @@ config HEARTBEAT
 # We have a dedicated heartbeat LED. :-)
 config PROC_HARDWARE
 	bool "/proc/hardware support"
+	depends on PROC_FS
 	help
 	  Say Y here to support the /proc/hardware file, which gives you
 	  access to information about the machine you're running on,
-- 
2.39.2



