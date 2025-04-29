Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E64621ABC6;
	Tue, 29 Apr 2025 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949929; cv=none; b=dn/nm7gK0SQqWe3hLZy5ZFamKz4WRXrUsSeFw6PEJR0yF3ZgNxmJF88Ocu5Knw8VaQC7i5S8sYRAStvJI/FFkEC2XqI74cBcE5IZQQQkPq/Lf3Y6apoLVbJR4l1HWa4oysD158O1r83HrcYqoQ5+rYBqwbk+pdmGLpbpf0fFnYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949929; c=relaxed/simple;
	bh=o74VeRs5svJQtpPHktm5fQDFvtByhAUGm+K09ehbdZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Btnj1M9iSG5UCY5M/t/VEZRnAzx8aNi1aupIFK2ZF9ubixsd78suJPkDFR20LVsfR8zJt5KCb5QYYS70/wAe9o9e+md4awKEwjby6AJ4+T4SaXf3GIlbqQEhyMIXOd/s1+YuvkL6QTDxg8SsnGGQp5yoJHV0s8q+HMNaQI2VdbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k6iskxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k6iskxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7B1C4CEE3;
	Tue, 29 Apr 2025 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949929;
	bh=o74VeRs5svJQtpPHktm5fQDFvtByhAUGm+K09ehbdZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k6iskxMJPzIZi0zBqoiNt1Ylf8Naf7st+ZvkOVLky0s0FUrhThaEvCKQTtFcscqi
	 aadv+zFiVlbgid9CRlAAF7zzyJ1OW1c4IE9XdMCklQhspvQWzwDYejen7Mjvg6NcSE
	 W/FTs0O6MsdwC371Aa/dTQAODJHZHgzoYmMWTixo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/167] parisc: PDT: Fix missing prototype warning
Date: Tue, 29 Apr 2025 18:43:30 +0200
Message-ID: <20250429161055.872867057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit b899981750dcb958ceffa4462d903963ee494aa2 ]

As reported by the kernel test robot, the following error occurs:

arch/parisc/kernel/pdt.c:65:6: warning: no previous prototype for 'arch_report_meminfo' [-Wmissing-prototypes]
      65 | void arch_report_meminfo(struct seq_file *m)
         |      ^~~~~~~~~~~~~~~~~~~

arch_report_meminfo() is declared in include/linux/proc_fs.h and only
defined when CONFIG_PROC_FS is enabled. Wrap its definition in #ifdef
CONFIG_PROC_FS to fix the -Wmissing-prototypes warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502082315.IPaHaTyM-lkp@intel.com/
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/pdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/kernel/pdt.c b/arch/parisc/kernel/pdt.c
index e391b175f5ece..7dbb241a9fb77 100644
--- a/arch/parisc/kernel/pdt.c
+++ b/arch/parisc/kernel/pdt.c
@@ -62,6 +62,7 @@ static unsigned long pdt_entry[MAX_PDT_ENTRIES] __page_aligned_bss;
 #define PDT_ADDR_PERM_ERR	(pdt_type != PDT_PDC ? 2UL : 0UL)
 #define PDT_ADDR_SINGLE_ERR	1UL
 
+#ifdef CONFIG_PROC_FS
 /* report PDT entries via /proc/meminfo */
 void arch_report_meminfo(struct seq_file *m)
 {
@@ -73,6 +74,7 @@ void arch_report_meminfo(struct seq_file *m)
 	seq_printf(m, "PDT_cur_entries: %7lu\n",
 			pdt_status.pdt_entries);
 }
+#endif
 
 static int get_info_pat_new(void)
 {
-- 
2.39.5



