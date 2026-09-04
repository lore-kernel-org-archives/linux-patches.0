Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF033ECBCF;
	Fri,  4 Sep 2026 06:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502743; cv=none; b=BOoNwzURL6OmHDbDdKVowX7XnguwOE2sZ9YPdPm3fjaiWIjeBwHmiTzmitFSqXTMiK8QzO8VJwla0WkIR6IOpwDJpXyCjjfDvh9ezDzz2GEcn5tZ+VP08AzsJkenc4CvzmfWjDerXqxPPp+APfKwZXKTj3jhNVovqvgToOT2v8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502743; c=relaxed/simple;
	bh=Pus0Z1O3MQHTe7ClrwkHL9DfBflUzg1Ixftu4AnIMdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PisZM2qtGaypxtP1XYmZ84Ro8R+tpQuYTuaX2cEsGVsR/XgyJHPOxHvwkYolkChS6L0E9JVfY9h/d0/w1drNvlfF91C85oR3uYy89UgGVsaLRv+8ncXwFgqE+oYnM9kiae9BxH8msn5wgzHpcKgw+HSBS38rIdniXILrW7ohQ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTjT6Ukw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTjT6Ukw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83F71F00A3D;
	Fri,  4 Sep 2026 06:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502742;
	bh=gUv5xPi91rMimdbdQPn4noqtvVvQuJnMmDb7gO/Qf8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTjT6UkwIWNG5N9Sb6E5B4WDPEUzXi75mZXVnToLTx+/E8JLjl9juB0XmS1cJcVmu
	 Exim8Q2iIZov1/2M6H0Oy+eFhBjdaetneyYBc3jTPuLgZp8aul5/+/v93hHSmXci+O
	 ch51tigwwZfkAx33+CstQqr1zvUZOJqFrVJ7VpCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 312/403] platform/x86: ISST: Just allow 2 bits for SST feature enable
Date: Fri,  4 Sep 2026 07:01:55 +0200
Message-ID: <20260904045741.935745065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 0f377f2b47646abe6ec3616ae6a8670d9ff7eb86 upstream.

Currently only 2 features SST-TF and SST-BF are supported, so only allow
bit 0 and bit 1.

Fixes: ea009e4769fa3 ("platform/x86: ISST: Add SST-PP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-7-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -841,6 +841,7 @@ static long isst_if_clos_assoc(void __us
 
 #define SST_PP_FEATURE_STATE_START	8
 #define SST_PP_FEATURE_STATE_WIDTH	8
+#define SST_PP_FEATURE_STATE_VALID_MASK	GENMASK(1, 0)
 
 #define SST_BF_FEATURE_SUPPORTED_START	12
 #define SST_BF_FEATURE_SUPPORTED_WIDTH	1
@@ -991,6 +992,9 @@ static int isst_if_set_perf_feature(void
 	if (power_domain_info->write_blocked)
 		return -EPERM;
 
+	if (perf_feature.feature & ~SST_PP_FEATURE_STATE_VALID_MASK)
+		return -EINVAL;
+
 	_write_pp_info("perf_feature", perf_feature.feature, SST_PP_CONTROL_OFFSET,
 		       SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH,
 		       SST_MUL_FACTOR_NONE)


