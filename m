Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAFD7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70B7C433EF;
	Tue, 10 Jan 2023 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375756;
	bh=sivQZ7fBkirVjV4uvmddVbqfmKT1DffMkbAStZfykFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmEkzi2lrKk+cmKfnuco5lQ1wXbW9p1G36vGFqpgIIqVuuNiT4mN8Bcv4dgDAclEs
	 XiEooktJRjZqnLLYJPVwNCIpp4H5hekJp1orOU85koLyrjEhzBglE8if1Sbc5J9wBi
	 rZukfKCNYB9GqjxxpfaAd839vAhX/dii8savt+fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 271/290] thermal: int340x: Add missing attribute for data rate base
Date: Tue, 10 Jan 2023 19:06:03 +0100
Message-Id: <20230110180041.306932515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit b878d3ba9bb41cddb73ba4b56e5552f0a638daca upstream.

Commit 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM
driver")' added rfi_restriction_data_rate_base string, mmio details and
documentation, but missed adding attribute to sysfs.

Add missing sysfs attribute.

Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
Cc: 5.11+ <stable@vger.kernel.org> # v5.11+
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -172,6 +172,7 @@ static const struct attribute_group fivr
 RFIM_SHOW(rfi_restriction_run_busy, 1)
 RFIM_SHOW(rfi_restriction_err_code, 1)
 RFIM_SHOW(rfi_restriction_data_rate, 1)
+RFIM_SHOW(rfi_restriction_data_rate_base, 1)
 RFIM_SHOW(ddr_data_rate_point_0, 1)
 RFIM_SHOW(ddr_data_rate_point_1, 1)
 RFIM_SHOW(ddr_data_rate_point_2, 1)
@@ -181,11 +182,13 @@ RFIM_SHOW(rfi_disable, 1)
 RFIM_STORE(rfi_restriction_run_busy, 1)
 RFIM_STORE(rfi_restriction_err_code, 1)
 RFIM_STORE(rfi_restriction_data_rate, 1)
+RFIM_STORE(rfi_restriction_data_rate_base, 1)
 RFIM_STORE(rfi_disable, 1)
 
 static DEVICE_ATTR_RW(rfi_restriction_run_busy);
 static DEVICE_ATTR_RW(rfi_restriction_err_code);
 static DEVICE_ATTR_RW(rfi_restriction_data_rate);
+static DEVICE_ATTR_RW(rfi_restriction_data_rate_base);
 static DEVICE_ATTR_RO(ddr_data_rate_point_0);
 static DEVICE_ATTR_RO(ddr_data_rate_point_1);
 static DEVICE_ATTR_RO(ddr_data_rate_point_2);
@@ -248,6 +251,7 @@ static struct attribute *dvfs_attrs[] =
 	&dev_attr_rfi_restriction_run_busy.attr,
 	&dev_attr_rfi_restriction_err_code.attr,
 	&dev_attr_rfi_restriction_data_rate.attr,
+	&dev_attr_rfi_restriction_data_rate_base.attr,
 	&dev_attr_ddr_data_rate_point_0.attr,
 	&dev_attr_ddr_data_rate_point_1.attr,
 	&dev_attr_ddr_data_rate_point_2.attr,


