Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061495;
	b=gARlVFBSncU8FVXwKRfww7jGJ5DbLRBEdtsXyJYVsZg8e7r0NJQ+M8WgR+URkgpfdPnw
	 b6uELK1SE8Z5hX7KK8PMrazQLH3Qi5lYq4z9OkSi3Uvj2bwCIBZn5qtJdWf1BImrrENk+
	 GGOEn2YzJqVVOIsQN0AQaXKQc1KPNO70514QntU/Ct1A3v9KOM8981w/0fDYJ7QeS6Nfr
	 XahKqczq9gjqzrB6p6ScJ/0uDYvQ2KqqSUDvaPcxuLiF1+IOlBqYi/CeW44szTHlu0eO5
	 w7Q/XIkfaPjrgNRCypixIPk1iUF1oEiDvRtwe8scq0LZChvkRVnrGyWAkwJUdbxvv5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hEWpRGjQS5fGGTb2hM3l+JpanuOH3F9lIdw9iP/eoMw=;
	b=wMuOYV27rQ0/x4J6TjNqFgbP7uT/WljlqJG+I6T658aMbEkkKJx+ZKhiB8TKoSrqfJWm
	 E58WAZYf2cwJIkbgWR/QlASBSP+IgE90E2kz+bKJ4cxTmPuT6T47CPTGRMQW3ffIZGddk
	 HVxMemeTlcRQcn+wuM0gCfA3P8xovy/1sH0dxMb0IHv1dH5CrAaO4TglFfMjZTM2Wbaje
	 jTvW9HX0BVINULEVyG5gh2WtFBRgqlw2yeaxAN1rqZdLsLHM8dZjZ7u+l9risC7eBKapb
	 JHftWd+1OVTxMRtU0w2gSFw8le/aSSYG+uoO2puPWaudiDTsUwyC0/Uo4ga6svJSPNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa5Ivoeg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2CB606A339;
	Thu, 19 Nov 2026 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa5Ivoeg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7C01F000C4;
	Thu, 19 Nov 2026 04:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061495;
	bh=hEWpRGjQS5fGGTb2hM3l+JpanuOH3F9lIdw9iP/eoMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wa5Ivoeg/nlEpfCUZGzFNBptTkDaLCw3cQkLCtLf2F17ArQDTm6SVMRD5ViQJPAoc
	 dfB836YvGjfmbiLLqfSo3IizgLc5uAO6oimm0DnEkdzOO1nDpsdS8dNaPiKoStD9in
	 JfF24ZelUGaM9E82ShUzAiQcJTCpPqsOVkhFoY7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1573/1848] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 16:00:11 +0100
Message-ID: <20261118150025.426578539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/intel_telemetry_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel_telemetry_core.c b/drivers/platform/x86/intel_telemetry_core.c
index e4be40f73eebf..6a1e9df26ba1b 100644
--- a/drivers/platform/x86/intel_telemetry_core.c
+++ b/drivers/platform/x86/intel_telemetry_core.c
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



