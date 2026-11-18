Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026409;
	b=kM3MsHg+9aGM5bF4mol1+RqDgrRDmbj8cr/HFYwC5+qKrwKJYSNVWwDhniF1FQKPaVbK
	 iQtxA+z0//Y6aCcGQN+5iEqPutkD41WbwaJ9XxYLaCEHaKQpap2xgWFRKhFQtF/GwjLXc
	 Y25IsfvSl4b4/lxDPEgHvsh7ufJRlbiWhbX8mex06auOZvvMMWjgidoDvaoC2DQp8XNq9
	 55m/T9CwIg9Afs4QA9QkUyY+RlO8Qk+cpNhW/Vveh2gkcjN9IKrXrQC69CSobrcqMfnIy
	 0VpEz/fU5tKLHlsnHbKXal7VFxcLLAPacRfrBs9OvGplKsKi+vCCq4q3Mr9x/PI4V9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PEcuI8zw3TjBp7GqeyaNNIguXYUgOTLEMD01j0/PDQI=;
	b=udFE8s30K1iNBgrOmRCzflbFJ8irl2k3h0rvYtluYVq+Rz/I1hFZlYgq7+9mLcZ7tIs8
	 9p3Ps7z3FbicCuWZdfqEl3VAdUDL7mUbvM5XYWoBZkYMq/YJ+fSQ4rVxlF7phQ2OE/DrY
	 Hka0VxAc9uTBHLEPZIMphIChwvjU5JAiL2MBam01kYfGc90vq6vLr0CmM6UA9Xik7WaOE
	 G57vON1uJ6umqpujh4NQaAYmJ297EtvNiWD/C+LKWbotcMVxh8aZA56ie5CUb4OMzBuYR
	 1sCQYJHuvrI+MTNJafroo7ql2D45sMCYpDqJhAJMHeX2WFZN5OFM0D9Nn/LsWNazNGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/xo+w9L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1DE606A330;
	Wed, 18 Nov 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/xo+w9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE41F000C4;
	Wed, 18 Nov 2026 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026409;
	bh=PEcuI8zw3TjBp7GqeyaNNIguXYUgOTLEMD01j0/PDQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/xo+w9LcjxO2AfFS/ZcrgO2OK6xQcxM4XkXTUC1REr7QfR9a2QnYVo9NL5wl974G
	 w1nTApv7FplSpDH8SmpsUY6zVm7bZrUWq33DKThOq9BhsIe358khh/VFXZYjllAOBN
	 GMaZbl7Cdz6pxunsVjahh3CXmA9NNHPPchf/+VEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1384/2151] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150212.416938971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrova Alyona <aga@itb.spb.ru>

[ Upstream commit 1b55ec81926eb7f6e4fad692fa4040a569e9daf7 ]

telemetry_def_get_trace_verbosity() returns success without initializing
the output verbosity value.

The default telemetry operations are installed when the core driver is
initialized and again by telemetry_clear_pltdata() when the platform
driver is removed. The telemetry debugfs files can remain available after
the platform driver removal.

A subsequent read of pss_trace_verbosity or ioss_trace_verbosity calls
telemetry_get_trace_verbosity(), which may use the default callback and
return success without setting verbosity. The uninitialized value is then
passed to seq_printf().

Validate the output pointer and initialize the default verbosity to zero
so callers never use an uninitialized value after a successful call.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 378f956e3f93 ("platform/x86: Add Intel Telemetry Core Driver")
Signed-off-by: Aleksandrova Alyona <aga@itb.spb.ru>
Link: https://patch.msgid.link/20260917110812.2831-1-aga@itb.spb.ru
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/telemetry/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel/telemetry/core.c b/drivers/platform/x86/intel/telemetry/core.c
index f312864b8d07a..62299524a07b2 100644
--- a/drivers/platform/x86/intel/telemetry/core.c
+++ b/drivers/platform/x86/intel/telemetry/core.c
@@ -24,6 +24,10 @@ static struct telemetry_core_config telm_core_conf;
 static int telemetry_def_get_trace_verbosity(enum telemetry_unit telem_unit,
 					     u32 *verbosity)
 {
+	if (!verbosity)
+		return -EINVAL;
+
+	*verbosity = 0;
 	return 0;
 }
 
-- 
2.53.0



