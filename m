Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C79A23BF9F;
	Mon, 23 Jun 2025 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685265; cv=none; b=KY6VMua1IaN0FxPPTnOloSO1kOA+YqAEDIprsPUJO5t6Zv2Zg4bLlNe+jD8tpmTDBwCcZnLVBYm5RReMHtd+Xd9Qn9Ypp3TWI6+VIa8VLE6DVdV1ljjdJctetQsFz8YB7WA1a8nYPXvyFPLFRvr20LppTl2SHWdIPpsHeaf1U7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685265; c=relaxed/simple;
	bh=6/SFAhZ5b4XNHgwp1WddKw18WHapjLncjGI16zPr0b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKVYrZpi/mzHvBaolRKOw6fSxBqp+l3OeTQqJ/T+Fm564lWKoZb3Yvo1zpWUJL473hlv7dfjYFuAy2Wp2LoVekm71fooJiYhTWdcd4j9rxcB967RNkICKBOojl9FWonYl66gTja6yE349dRSTJY5QrVk4RJNJpIhAZIdHr1rHa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfO2d1ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfO2d1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B3FC4CEEA;
	Mon, 23 Jun 2025 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685265;
	bh=6/SFAhZ5b4XNHgwp1WddKw18WHapjLncjGI16zPr0b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfO2d1eel+RwhSzuznQr7fkA8VZqyzkU8zStyJukxXy/EJ7y5GyZoYMugx8xZZI0A
	 TkZ470r6zce0lWfThL+p6lkG7miru139iwzTx5u2mcI433E1DzE5U4ISUTayqCJfvN
	 lXqQE75Gj7jXyn/yn+ikYbBE+A/IeKbNhuqMjabU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 219/592] ACPI: Add missing prototype for non CONFIG_SUSPEND/CONFIG_X86 case
Date: Mon, 23 Jun 2025 15:02:57 +0200
Message-ID: <20250623130705.497628572@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f2e93ed97301..fc372bbaa5476 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1125,13 +1125,13 @@ void acpi_os_set_prepare_extended_sleep(int (*func)(u8 sleep_state,
 
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
@@ -1140,6 +1140,13 @@ static inline int acpi_get_lps0_constraint(struct device *dev)
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
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
-- 
2.39.5



