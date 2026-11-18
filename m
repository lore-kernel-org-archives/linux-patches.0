Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034568;
	b=yqkQyzUxqWSfM22tjCJlHsKCB60MoLwC2m0NA97Zr3cKwXXM7Z5cvBpCLhhb9JZTANMW
	 Crhqg4xgH/YKe4qn5nEcuf9TeBfV8B5ybWOL8tDPOEQ2hO6eaKHJvS9Zwiu0R9ZnO8ATP
	 sbVjpyZoI/wMhYy0yTYtZXI3dSAb7x3Im6Uj9PP872JVw21axYCbeIB24f1H7b81ecY4j
	 JEyvFThWEc4sL8LuNaqnYUhfYZFc6gvWgNaGjPx/qKDekO1T3WlME5Sl8dKqgOQW4jSLD
	 0tHliLTXi6a+++gbMRMc5ELADftSkKkC1XTwt1/1f4bKse4EhpRguKQgGzcZp4+nEOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bVfCXbk1Xkoi7yoi617iKgP7t3rdCpI2EIxiR0kW9/8=;
	b=FpOYK+BC1Gg7OBfR4New6tK0t9RuMQQv7rudMHkmMv+kgcIJ08CgVdXtsNhIQIH31FmG
	 v85TQ9jUf2N/UwiKNNikyZkCZtZ4z3Y6uOOgNsczj4VU9DUHcmAFWFYkDHtg6Qd0qmClp
	 smP+8uibSbhI5XIcZLIGDPbgu8TBLfSoypV9NbydnD5Wbh32twp+LzHE0ujxQtt9FTlSi
	 jh79vwglQGsxRlaZGMmzZplFbH7a5skEXXbnbKjSdQUJYnWIyKkgZ1FxIeQzVQDvlUP20
	 OowglSH4P0E89binkk9ElLLl4ITO1fCDNtWq9HcrNAZuBW2bPGlO4dwo2+I7f2jHZ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aNAFHDL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352DC606A320;
	Wed, 18 Nov 2026 20:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2aNAFHDL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1D71F000C4;
	Wed, 18 Nov 2026 20:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034568;
	bh=bVfCXbk1Xkoi7yoi617iKgP7t3rdCpI2EIxiR0kW9/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aNAFHDLy/h8re9ontXtajIwE/5B0Qqcrrsf6NYViIa6XXDgYp6gXbKKmq07RrFzF
	 j1tsycZBMvOskbWcsOCx5LFnN03uvhD9TwEeDRIFy2cspqUujaTqKqMSLQifLBz7mD
	 e8ZRXyXGCqZTaS56mRH7vTV5eNPXFtxgbXEVgtlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0415/3318] platform/x86: ISST: Validate parameter for frequency and priority
Date: Wed, 18 Nov 2026 15:17:17 +0100
Message-ID: <20261118150328.972158694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 574b59bb4b6bfcfd1f639d02f1041b314d43a2e6 ]

Validate range for frequency and proportional priority while setting
CLOS parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-5-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/speed_select_if/isst_tpmi_core.c       | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index 8ba207a3908dc..01dfb41a52b80 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -508,6 +508,9 @@ static long isst_if_core_power_state(void __user *argp)
 
 #define SST_MAX_CLOS			3
 
+#define SST_MAX_FREQ			0xff
+#define SST_CLOS_MAX_PRIORITY		0x0f
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -527,6 +530,15 @@ static long isst_if_clos_param(void __user *argp)
 		if (power_domain_info->write_blocked)
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
-- 
2.53.0



