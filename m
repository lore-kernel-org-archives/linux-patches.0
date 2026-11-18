Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041305;
	b=3lHUkdJNpziagx0J8a7j0+CgAJpMcL5NcdNP/19/SorEZMcJJvJLh2xYII5nv/ieOrCk
	 bvF7OzAwImhhai6ap/6seGJlgrsy200p1jyyELu5Y/qE1467MTOzxAjd5LrCgNFHyV0lO
	 7bQ0dwy+kHnavDk2ZghTI5O/dGVekiNl/+ez706aHj52HHvWII9X9uJARinlUxsMcCizg
	 jMj9BzzhNC/AxTywKbntABHz4gUu4RHyaXazaU3PZONW+FgQPHF2Mv6jANyg/0MlbBl+u
	 smLg3wmNp1soJ9elHvPaGLBiLwKIDnBiXWqUxqXNlG65/ainSUB8k6xgEVZ1tMniCbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6nU5ebeJ4ie/eMLRLXjIkVOdd66hJJsW9nmoRp+4W48=;
	b=SOFfiw87awI6RQufNQiGuhDIyA6MGKcyn3f3V86dgbFhQdbQFbp8aLQPABLsyNLYtPOK
	 L9Rjxiy26qxvWOm60okb5cyKykJluvNRcGXJoGpaYjJTaAwB0yXcOzdd7cOUVrog9M5qI
	 OCLYOoOyUelUKJMaCMbmzQ2E0jliD5ocziUtmgXXcGNSfsJMJB/XSPdeHrtueLpjUPPOP
	 EYc6H4DCaBzlYQA1fEalgczuf5dJxzF+upPkk3vFY8vMevQZI4go8Hr+n+uTadYGYlcRP
	 cJ2/VNm3Wcjua9A9McIkrfmHIV8npxiTCw+bHsM68tOQgTihWD4/Q/+MWUdDaN9I7ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NgAU/QwL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68394606A31C;
	Wed, 18 Nov 2026 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgAU/QwL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4371F000C4;
	Wed, 18 Nov 2026 22:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041305;
	bh=6nU5ebeJ4ie/eMLRLXjIkVOdd66hJJsW9nmoRp+4W48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgAU/QwLw+4yuuYwRnYJoQtnAOhpc5Uq04JCZ4of9une177drBTCjpRn0z//aJC91
	 C3IXNUi879CiPbms5Ef3iCoQcbgrMHegAAhFdid80YKARUymQnO4MFZOTQGmjOA7Bm
	 tYbbVtRwXqlhJhz8mF9YAzbkHpLDciAdGf1iXTLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2767/3318] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:56:29 +0100
Message-ID: <20261118150443.732943862@linuxfoundation.org>
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
index e4be40f73eebf..6a1e9df26ba1b 100644
--- a/drivers/platform/x86/intel/telemetry/core.c
+++ b/drivers/platform/x86/intel/telemetry/core.c
@@ -51,6 +51,10 @@ static int telemetry_def_get_eventconfig(
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



