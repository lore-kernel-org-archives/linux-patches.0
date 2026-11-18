Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019711;
	b=gjROhyVEGMNgBGWM+Nkg1EHjSGOzZXSoVoATrDLBL41LCWSHHyXC/IDIez9DqTW2Jcdb
	 U01bJvoQbo7Io33k1/H12vXPt/3fbuN3iYLjypBFYLltxrPiY0dg3w/d4OsGaMBOZctT8
	 FsAXHCbcGTk5XaRklB0ulUWslHzm9uuBbv3VzDdmZHBCTJZfyZ2n2cKapF5/Cjl8In9LK
	 0OJ0ag3Z/djxFcNxEGIaMgysJaxNQkb6xwOtpsQ3hJJBWiPSPtkpscmNHcUkKxaW9Caho
	 RI8Fy+sit0GfqkFa0Cy6rTbznYpDWimwj3Ex7humToDqyUEuIt4EAl9i5B+WK17wz4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gMC+jVq0MpEPtkOSnP5ni+dfnLr6LjuwOnKhpKL7jV4=;
	b=uzF92HuMUU7ymYFBTQC13fr6v5k88ZVk4zr+/qnZXgQcrDNLexn1ZyQiar1wxL33vkES
	 GOX8JTObX/o9pawlnn8/h21PidUeXMLI25xFIf4wUCWf9ZTfwHnO6J2PWoKDm6hOgPYZU
	 hP4QZjNgHsrCy82IdEcap9klLxjGl4vnFieWJzIe+0BLSOLkVkoNU1VHND3uqTjy0h70U
	 YNejDG4c+QHcAAvEVqWp8N0DPq49DvagP68mjf44danSI9MbNv8jyMknZ+/4zRXKDQQdA
	 r/mJBPP7WWGl2OHnmgC/EcBgUBMbv4p+2g+f57Ic3nPjHh6xBRh4diRvTb7a7pBx2Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfuLU7Z1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274FA606A320;
	Wed, 18 Nov 2026 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfuLU7Z1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E51F000C4;
	Wed, 18 Nov 2026 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019710;
	bh=gMC+jVq0MpEPtkOSnP5ni+dfnLr6LjuwOnKhpKL7jV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfuLU7Z1FD3bJh7fC3PPi/ylesbXpjHkw0fKE09CLX+7Qd+I6m0pVelsyls48tfMU
	 bq+ORWwwWDPNYDToklxAkAzqqOr5CKc0Z4fis0HVqghavce7Sj5FDTH+gLvr6iiooA
	 E5nSr21iE0UtO30xpKppz8pfXKkqJyscgWCO4CiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1692/2651] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150348.584581797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



