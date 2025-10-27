Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD130313546;
	Mon, 27 Oct 2025 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593312; cv=none; b=H0UbfZWW/aGoFbvrX0xA3EYIBnM/G5xNUP18quKV9LSw8YKEcOOMo+l/Ae5Q2YLYtvqXotAtIKkc/LjvCQOEj6hQMHVIQXqcEBGJQh1+rtMqxmz0w1H+Y/GzH3EOyn6r5d3YjsY7MBMSoQOC067SOqAGFyWm3BWTdg7Hv8Q6K60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593312; c=relaxed/simple;
	bh=8rO9UwtA+mdgzqrMvr17LaoWatG9kO8T0wzswi6CwPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTEFFpJiSv1vvAZlikR1jhoeJixi9Zt4JmtZI3+LxRMksq2Z4JstxZriiMRcOYQnBsQR+sQksZ/hoayvpydjrWlT6qHxk73XxG1/nDqTJCnQn7vwho2iMALTWwCGjzAeOGcdhH1e0QqWzTj+uNVai9Wphf1lrftDuHAr3aul1lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVlv37en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVlv37en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F3FC4CEF1;
	Mon, 27 Oct 2025 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593311;
	bh=8rO9UwtA+mdgzqrMvr17LaoWatG9kO8T0wzswi6CwPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVlv37enSJb5OwS1rRMDnWFMo6/VgLURBnvM2ko4zmj8Fa9IRGFII1mm7HDPyaXMk
	 KurEGVn8g3BQqJG+qSpGfPYzCyehmDHDrxIbFt+yH3Dgv/oEYOFsIiCPaY9tgJmxRC
	 ZTACVtKtkh+6wz5isQYTTV8FXVogBeLTiAPYEyuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	kernel test robot <lkp@intel.com>,
	Gabriele Monaco <gmonaco@redhat.com>
Subject: [PATCH 6.17 094/184] rv: Make rtapp/pagefault monitor depends on CONFIG_MMU
Date: Mon, 27 Oct 2025 19:36:16 +0100
Message-ID: <20251027183517.433890638@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 3d62f95bd8450cebb4a4741bf83949cd54edd4a3 upstream.

There is no page fault without MMU. Compiling the rtapp/pagefault monitor
without CONFIG_MMU fails as page fault tracepoints' definitions are not
available.

Make rtapp/pagefault monitor depends on CONFIG_MMU.

Fixes: 9162620eb604 ("rv: Add rtapp_pagefault monitor")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509260455.6Z9Vkty4-lkp@intel.com/
Cc: stable@vger.kernel.org
Reviewed-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/r/20251002082317.973839-1-namcao@linutronix.de
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/rv/monitors/pagefault/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/rv/monitors/pagefault/Kconfig b/kernel/trace/rv/monitors/pagefault/Kconfig
index 5e16625f1653..0e013f00c33b 100644
--- a/kernel/trace/rv/monitors/pagefault/Kconfig
+++ b/kernel/trace/rv/monitors/pagefault/Kconfig
@@ -5,6 +5,7 @@ config RV_MON_PAGEFAULT
 	select RV_LTL_MONITOR
 	depends on RV_MON_RTAPP
 	depends on X86 || RISCV
+	depends on MMU
 	default y
 	select LTL_MON_EVENTS_ID
 	bool "pagefault monitor"
-- 
2.51.1



