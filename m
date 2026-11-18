Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031546;
	b=P1IAtsJ2cbj/R7Y7PUq5yMZ5QXg+iJoI0PzTv4uJ05yGoNq9KSEPGetYnzX82WGiv8N2
	 7NzF0ysmkmH1FrNL7Xl5pDDrXPyhmrxpjnwMUJyAy1AwE+fMstidcxfT2smD8W62qnEYn
	 zay1TeUoboeTfl3NYzpjyHBeKr9ItgmzgTTYcXCnObsqdK0EBxp1kZKqk5FRzbqJVlzBs
	 QqH2gOQAWnrMdQkKTZcSmQfBYwvRGfpt2IO8jTYKboSJm+fo7S8tcZQnvjOzauJpHlMjT
	 VoWgIjjvWNK2+J0ByMdZSrNXI1CnX6hMTW/Dy9xiggnf5ON0DVthkGan81VxCBtl+aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jScYvz+kR+YZo3Ck67KjOF4EdSUIa2SIY6DgDfizT1Y=;
	b=FwOv0hlL13uqkpfKWZ/sebSekTxC5e/ZXRsKKzpZcbuaBP3qfswtosS9hebmaITkO5Tb
	 tVO5oO/bSNGwvhAAOfzTNpwRyQ/umLkF+gNq0EfWc9w0HNX4NgDs6uRJ4oh5Ocr1ZDRKw
	 9WUuv//nI7s35uzkR1jZNMqjdpoitYeyAazPIwKckJucHqTc+GM/k9vn52hleAB4GGrev
	 N/XXshtGbdLIM9XoBQd8QcQNtx9Wf7mr0/V0XCscNicl6TOqCzS7J9mHc73QRgsDZoSIb
	 m9bCNJoBpsl2IP8YFdqSl2sexM2VNSFmvdDtOIih7HHSGBCzNmOjOseFPwyT/SLpmEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fglssc2/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E5606A325;
	Wed, 18 Nov 2026 19:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fglssc2/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A211F1F000C4;
	Wed, 18 Nov 2026 19:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031546;
	bh=jScYvz+kR+YZo3Ck67KjOF4EdSUIa2SIY6DgDfizT1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fglssc2/G4/nq4coGgyKiKhLOKrbfsdTOj9zIMqQt8Xj1fEOfmKZFrg8UZ1bfK1Bn
	 D6wBR2k+hN8n5D5iMwIClNGe7mdda7rPszrJf9+gwo5VEPbiBDL5SudutqdqeipyZ1
	 /v1np6VLO5AwWZbOzDm4fUQmybS2+/Mw83zuiWcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1095/1756] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:53:42 +0100
Message-ID: <20261118150053.810906525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



