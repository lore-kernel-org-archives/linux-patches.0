Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAF928CF42;
	Thu, 27 Nov 2025 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255777; cv=none; b=JR3PhS7JxXhdeAQHiIPgCF7KYyzlGt3EjZKa/aZXh96WeUaC0cl5+VFRw3iHPGMxGMoEB9YhEp22wEnlfG7yI6Ej5td4Scb9U8po/m8yTwUKsMmB5fHtLfu1zSCvvRlqiZl+6JBT3PgBQPtLVGYGvYClTBfW6IeacqLdgwzqTpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255777; c=relaxed/simple;
	bh=exdR06JmgNPUP9hYw2sVNAizqblQsGDP03UMrv3PIk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hC8PW9J1R/hlCIUZNuRHZZ3nndufF7CW0maenjaJCgY2+zfiMOemJ0opZCbeMnA45zlem0n8+dVIH3hLqOH8vM4J4/QVdMIS3ForlYsnIK7xUWzJjkEAI9m79oRzQr/ZeSYbDrg9O23kgbY2MlmbmhTs1PkXdTB1/hI60VMPy5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glN9Ss1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glN9Ss1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B85C4CEF8;
	Thu, 27 Nov 2025 15:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255776;
	bh=exdR06JmgNPUP9hYw2sVNAizqblQsGDP03UMrv3PIk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glN9Ss1VUyy0rSt+U/5uW9IdJABQBb7g8AfCGy5SCMUiXHzEaPxmedIFJWVEF6TDV
	 I0vpz+eA5V+ueLV01d8S2REqryA3YPA3M81/Xm758wMq87CevnXW8QRParXpILXkBS
	 oueP1YnxAGhahLU0IvnBytvTr9nHFl/+5pMWAGlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/175] platform/x86: intel-uncore-freq: fix all header kernel-doc warnings
Date: Thu, 27 Nov 2025 15:46:04 +0100
Message-ID: <20251127144047.012431720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit db30233361f94e1a84450c607989bdb671100fb6 ]

In file uncore-frequency/uncore-frequency-common.h,
correct all kernel-doc warnings by adding missing leading " *" to some
lines, adding a missing kernel-doc entry, and fixing a name typo.

Warning: uncore-frequency-common.h:50 bad line:
   Storage for kobject attribute elc_low_threshold_percent
Warning: uncore-frequency-common.h:52 bad line:
   Storage for kobject attribute elc_high_threshold_percent
Warning: uncore-frequency-common.h:54 bad line:
   Storage for kobject attribute elc_high_threshold_enable
Warning: uncore-frequency-common.h:92 struct member
 'min_freq_khz_kobj_attr' not described in 'uncore_data'
Warning: uncore-frequency-common.h:92 struct member
 'die_id_kobj_attr' not described in 'uncore_data'

Fixes: 24b6616355f7 ("platform/x86/intel-uncore-freq: Add efficiency latency control to sysfs interface")
Fixes: 416de0246f35 ("platform/x86: intel-uncore-freq: Fix types in sysfs callbacks")
Fixes: 247b43fcd872 ("platform/x86/intel-uncore-freq: Add attributes to show die_id")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20251111060938.1998542-1-rdunlap@infradead.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/uncore-frequency/uncore-frequency-common.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
index 70ae11519837e..0abe850ef54ea 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
@@ -40,7 +40,7 @@
  * @agent_type_mask:	Bit mask of all hardware agents for this domain
  * @uncore_attr_group:	Attribute group storage
  * @max_freq_khz_kobj_attr: Storage for kobject attribute max_freq_khz
- * @mix_freq_khz_kobj_attr: Storage for kobject attribute min_freq_khz
+ * @min_freq_khz_kobj_attr: Storage for kobject attribute min_freq_khz
  * @initial_max_freq_khz_kobj_attr: Storage for kobject attribute initial_max_freq_khz
  * @initial_min_freq_khz_kobj_attr: Storage for kobject attribute initial_min_freq_khz
  * @current_freq_khz_kobj_attr: Storage for kobject attribute current_freq_khz
@@ -48,13 +48,14 @@
  * @fabric_cluster_id_kobj_attr: Storage for kobject attribute fabric_cluster_id
  * @package_id_kobj_attr: Storage for kobject attribute package_id
  * @elc_low_threshold_percent_kobj_attr:
-		Storage for kobject attribute elc_low_threshold_percent
+ *		Storage for kobject attribute elc_low_threshold_percent
  * @elc_high_threshold_percent_kobj_attr:
-		Storage for kobject attribute elc_high_threshold_percent
+ *		Storage for kobject attribute elc_high_threshold_percent
  * @elc_high_threshold_enable_kobj_attr:
-		Storage for kobject attribute elc_high_threshold_enable
+ *		Storage for kobject attribute elc_high_threshold_enable
  * @elc_floor_freq_khz_kobj_attr: Storage for kobject attribute elc_floor_freq_khz
  * @agent_types_kobj_attr: Storage for kobject attribute agent_type
+ * @die_id_kobj_attr:	Attribute storage for die_id information
  * @uncore_attrs:	Attribute storage for group creation
  *
  * This structure is used to encapsulate all data related to uncore sysfs
-- 
2.51.0



