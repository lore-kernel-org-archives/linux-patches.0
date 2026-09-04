Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07807408035;
	Fri,  4 Sep 2026 05:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499846; cv=none; b=RvKHSYkpLtLTG6EVUTu/gCKKfh3fjpoJheaZOAQaTlFlxSworcJCkwZ3VJVP4TJCfWShKXa3VIm221q2YWd1qdpdD8vE1XH9bXEqwzbz8hBX0p1vnKafNsIa9Pt21QCeLb7CvK9r8inalZ6dX4Z/TIEm228xl5xnBkYCfI6Q+bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499846; c=relaxed/simple;
	bh=JawT5TWAhoI5/GsVZmYl0BSVszIHVGYYfsCtVI8iLwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YaoC0VQUG7xuvPZ18yHbikLPAvhNIVaR62UwdByGnUcEr7gks+LLBPmJdzKoG+b5sWF5eVKAKyfSppo6sJoz4X7kBkFtyYSez+O/l/PbglKXZ6334JSQao3opii4SwLormJnxL0wr3MQEonCK8En8dBVNZzoq2XX/5EmBmVKfs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8t2Hmhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8t2Hmhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BF51F00A3D;
	Fri,  4 Sep 2026 05:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499844;
	bh=w9UMb7TVxh325hIfuZY5H0fINtJKh3k6RBBtDGX10/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8t2Hmhm6LF1AHqa1zGbhn+P9AqwV2BYyOei6uo5wThmIgZHjvufzI2eblfNjeCx1
	 6t7VKj7J3Ljd73XaGu6M2xaNKc43BpWqlMmOdf39VnxDM4T+0zCKTnZ4jTDKWBygLP
	 aX4TIh+yBpHA8E6fQ83FGUpLX2s+fKZ0jcoGbkLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 561/713] platform/x86: ISST: Validate parameter for frequency and priority
Date: Fri,  4 Sep 2026 06:58:49 +0200
Message-ID: <20260904045816.394787798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 574b59bb4b6bfcfd1f639d02f1041b314d43a2e6 upstream.

Validate range for frequency and proportional priority while setting
CLOS parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-5-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -661,6 +661,9 @@ static long isst_if_core_power_state(voi
 
 #define SST_MAX_CLOS			3
 
+#define SST_MAX_FREQ			0xff
+#define SST_CLOS_MAX_PRIORITY		0x0f
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -680,6 +683,15 @@ static long isst_if_clos_param(void __us
 		if (power_domain_info->write_blocked || !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		if (!in_range(clos_param.min_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.max_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.prop_prio, 0, SST_CLOS_MAX_PRIORITY + 1))
+			return -EINVAL;
+
 		_write_cp_info("clos.min_freq", clos_param.min_freq_mhz,
 			       (SST_CLOS_CONFIG_0_OFFSET + clos_param.clos * SST_REG_SIZE),
 			       SST_CLOS_CONFIG_MIN_START, SST_CLOS_CONFIG_MIN_WIDTH,


