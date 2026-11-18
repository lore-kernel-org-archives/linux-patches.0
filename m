Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056152;
	b=PBB91bQXGLNxAFot51n3T4zv2a3afGBiL8b93BPUHLOCQTI7BF0VA3oYk4fcbhipfEGc
	 zWE4N3RQFP4mFYrUc3z7gWiGrtwM1Fe5brfZj1ciDAwXGz7zKcxbwSx37gJ5C/t9/fTrG
	 uCzNbJDfUktKTSmN4YK0AwcyXNzlgeTBYZ1y6NokpE9KQpjPrvw1pZDjJIvQG+YHCtnq+
	 Fxf9gsPB9HpJZYY4o4b+SlzosEaM2ToMT+nU2JSmODq8LQH+XugM6mBC4LJL/bSCIxMAE
	 loJT6F8b9H6JIq68ckyJM1/c83I8nVezdKfoVGYd/Qwsqr1+p5GL03kfVqaUC2WwpQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Dm3uYoHap6ndWvhMzr+EtcLN/umG3V5Aj3H6Vu74etk=;
	b=n2wxWNpDNr+qkUCz/p2Np0uWdFvWxS/aiFzptswrmeyQECwtCLoouW4K8Zxsg3EiTypq
	 Ciuqutoa9vjtkngoKkf8ZV6xDe/IZ6aD1/vHiOjM0W3m6hfaOKe54bcmDUQzOesEbzA9X
	 QKx/I48uZvAdXAmYwd2vWeACgtc4VedNDbPAA+VFf1z4erEfkLTn6VOmAjJZ/g1C20XZG
	 6Ye+tbzx6tgt3NiBp/RROVmpMW04Io6g8F8nujzU/YlA4dBoIPny6MI4BhxagoHRkZKkk
	 2NYwxDfwCCK1xZ0JW63eihTqmZKIxuEEpghG4VqVhB+iaO0Fox6f3vzfRwW4kheUEHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8ZlcPuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843A4606A320;
	Thu, 19 Nov 2026 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8ZlcPuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C31F000C4;
	Thu, 19 Nov 2026 02:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056152;
	bh=Dm3uYoHap6ndWvhMzr+EtcLN/umG3V5Aj3H6Vu74etk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8ZlcPuCYua8lJDYKqHagr1AWjaBZj+Xnpj6O2f8V7fd7ryIpkxBtsq11tJJyEkXb
	 KrJqdMTsYd9V5Vj9lJOZbNR7vefwyAbNE8xxeCwjx7JT8IjVBsy1VDGle5LEpK6w+c
	 BPKxD82kMQabi+ssFQoMCND/P/I43gZsVv0x/nS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1859/2214] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:58:55 +0100
Message-ID: <20261118150125.715226791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



