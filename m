Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3821A433;
	Mon, 23 Jun 2025 21:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714245; cv=none; b=lbbjVo5PPxOzW6GzSAsYg/FogUBpOKtaUWI2kuA7vXBweGcwpcxi0hCneGzTIeg8m+32nJWN/APs4WRsPgR2SloJmoSVYXSDsCzvnKkhXSgh7wQGMsetGa766uLstYBC9qmmE7DjGx2fxPgBzaonNoVScO1VW/491ZUWpTL3vhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714245; c=relaxed/simple;
	bh=v/zq1zdfC2J3AHYSxGY/RIfpBGftO3RIj7Y0SNy/8Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVZ8Vbrcqbk8Z3hV6Iu0fRFQuahWxfa59gE0gSOAtsLJYGhZBrk+Pq3ejfJqObBX4EOnQL+Qn3hO8/Xtq9NNNZ/utUabhGYqHWQxduJh3D2sJlbKT06R53MSSumSzFLedAsJq6mp9I48MZ9wxt17aqpcS7QEpYZNsoK1rqTJmj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVzGOgig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVzGOgig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00513C4CEF0;
	Mon, 23 Jun 2025 21:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714245;
	bh=v/zq1zdfC2J3AHYSxGY/RIfpBGftO3RIj7Y0SNy/8Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVzGOgigY7i3R5PPyf3JNXru/pRke6mCttWjPbQmXyi+tCtLhhCpw6+XtWDKGNGj+
	 f99xiHv2YdKf9D84BP90gK3jzY0oTju2dtmgI4OJqPOfD14Ojjug40DjTsLhoSlhLY
	 g+WcAQ6zuHyePdKekihghQ3PMxqBQT5cwZHiey+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/290] ACPI: Add missing prototype for non CONFIG_SUSPEND/CONFIG_X86 case
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130630.689498210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e1bdbbc98279164d910d2de82a745f090a8b249f ]

acpi_register_lps0_dev() and acpi_unregister_lps0_dev() may be used
in drivers that don't require CONFIG_SUSPEND or compile on !X86.

Add prototypes for those cases.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502191627.fRgoBwcZ-lkp@intel.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250407183656.1503446-1-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1b76d2f83eac6..7c6f4006389da 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1098,13 +1098,13 @@ void acpi_os_set_prepare_extended_sleep(int (*func)(u8 sleep_state,
 
 acpi_status acpi_os_prepare_extended_sleep(u8 sleep_state,
 					   u32 val_a, u32 val_b);
-#if defined(CONFIG_SUSPEND) && defined(CONFIG_X86)
 struct acpi_s2idle_dev_ops {
 	struct list_head list_node;
 	void (*prepare)(void);
 	void (*check)(void);
 	void (*restore)(void);
 };
+#if defined(CONFIG_SUSPEND) && defined(CONFIG_X86)
 int acpi_register_lps0_dev(struct acpi_s2idle_dev_ops *arg);
 void acpi_unregister_lps0_dev(struct acpi_s2idle_dev_ops *arg);
 int acpi_get_lps0_constraint(struct acpi_device *adev);
@@ -1113,6 +1113,13 @@ static inline int acpi_get_lps0_constraint(struct device *dev)
 {
 	return ACPI_STATE_UNKNOWN;
 }
+static inline int acpi_register_lps0_dev(struct acpi_s2idle_dev_ops *arg)
+{
+	return -ENODEV;
+}
+static inline void acpi_unregister_lps0_dev(struct acpi_s2idle_dev_ops *arg)
+{
+}
 #endif /* CONFIG_SUSPEND && CONFIG_X86 */
 #ifndef CONFIG_IA64
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
-- 
2.39.5



