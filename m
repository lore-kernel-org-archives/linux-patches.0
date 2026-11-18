Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041661;
	b=UFrShR/W5uLI4sR/3Te7Ox1ghemZnlAYCTuttzVY5XVX7eEAWKiTXHiUzdw5xCp/KoBw
	 x5UkTcPjAb1EbTvGFLrsqqvSnfz5aJ2mBIe1atgxNp4fykMNKFQCh7R7S811uSWBgc2Pc
	 vN1pZYFlr9OXnKzdgxh8c0KFFP/BU93EwSyUJepHc9V/NpC2PmbalZUBxdNPUwxpcvf6t
	 HqOk0Y0+cOrYrAGyQJqpbAcHo46BCkBLsc8i2NsVMPS4PltxmiImh+EuoHm8niCd4zqWs
	 gfGASTsbtBQfq7ae67Ktaafzlc8DGlZrLA9YiDCvuMib2Crk3VSRQWZoD57vPu86iKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CG+scKQooMA9py/cjKOaUk6S40WnAne3IQ/HCxlZAsg=;
	b=Nc4Y49OXLcGQxoB+nU7iQ6HpWQZRw8iJu91mh8EVgO/ALGKVWV6Y6Fw3J4Vg5Kj0nTWZ
	 Db6VHncthK7xY8tkffXdM2bfbSZtv7yc3zWUgCPV1GA4xgRfEyFNjIciIcS+gpsvZpHwG
	 MJZD2LeIvGiN6eIgikNDZbUTpESdWcV2qGPDbhbZACKDYd/36WTm5X4DdAwBU/wxRQ204
	 /XdkpFE3rhmx2AQv+swVK6iAZJPnP3zd1yts9K+ZSMXUoba73rCTALRZTbqxGgXYyih6v
	 oGLwYerWKfXi2RHLxGJIRe37eF9m8wEEbZ9JH/8KWxzyoyIdbIXZRgVGouZSvK2GU9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YE4UxXG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E110F606A31C;
	Wed, 18 Nov 2026 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YE4UxXG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD1C1F000C4;
	Wed, 18 Nov 2026 22:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041660;
	bh=CG+scKQooMA9py/cjKOaUk6S40WnAne3IQ/HCxlZAsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YE4UxXG4HFKicjOHKWRb1wOHqCngQdbgQXf2HPDd7zH/JpLVeAqGrTpKh63d89JZf
	 5DRDes1c3825AckdLdKg4kdxBeJHGL9/gXCBwu7yz1/PWofqdk8hkcJVbCO+diWipX
	 +lywAq3ou1Hgz1tpNEHnHfwrXHE7OVv3GwLkeoyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2851/3318] platform/x86: hp-bioscfg: validate SPM state returned by firmware
Date: Wed, 18 Nov 2026 15:57:53 +0100
Message-ID: <20261118150446.129482397@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 35fb43f1576e1352077afc33a535007e0568480c ]

status_show() indexes the 3-entry spm_state_types[] with the state byte
returned by firmware. update_spm_state() stores the same byte, which
key_mechanism_show() uses to index the 3-entry spm_mechanism_types[].
Neither is range checked, so a state above 2 makes the world-readable
status and key_mechanism files print a string from a pointer read past
the array.

Return -EIO for an out of range state.

Compile tested only.

Fixes: b2715aa2e135 ("platform/x86: hp-bioscfg: spmobj-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20261007134711.473857-8-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
index 46882298e92b2..dbc37c1fe57bf 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2022 HP Development Company, L.P.
  */
 
+#include <linux/array_size.h>
 #include "bioscfg.h"
 
 static const char * const spm_state_types[] = {
@@ -115,6 +116,9 @@ static ssize_t update_spm_state(void)
 	if (ret < 0)
 		return ret;
 
+	if (data.state >= ARRAY_SIZE(spm_mechanism_types))
+		return -EIO;
+
 	bioscfg_drv.spm_data.mechanism = data.state;
 	if (bioscfg_drv.spm_data.mechanism)
 		bioscfg_drv.spm_data.is_enabled = 1;
@@ -150,6 +154,9 @@ static ssize_t status_show(struct kobject *kobj, struct kobj_attribute
 	if (ret < 0)
 		return ret;
 
+	if (data.state >= ARRAY_SIZE(spm_state_types))
+		return -EIO;
+
 	/*
 	 * 'status' is a read-only file that returns ASCII text in
 	 * JSON format reporting the status information.
-- 
2.53.0



