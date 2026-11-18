Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020129;
	b=TwNfqZpyVJSvadAPEewUxIg46nBxwQNonxqu1o+cBfmVoz1+JuxRHQ84kMFJaeJvq1Fs
	 b2AN1UHmqsHIN55DSsY/QOpeW+kJZy9+61dDoVWCxM7wiItN+JdZ60NbjpA6jYzfw5WAl
	 itTEHUkI1MImi8qc3tYeycZQ0m5XYKLbdYVjPus2AHTwt7HieMSr3qusNpqWo0VpgwQob
	 mkoiRKj9vn2jXsLsA+4mZMbB8U8UoFQw/4Q6ryJAQo/0NwfzIy+1Yw3wogeMzdhNg+mXZ
	 DePrJB0WSfJf+3GFXDdhRhaQXG0ETfPDB32kbg0RLcFcUQ7W8pzC7mZ/Qntt0UwxLEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qWmnYqwszQgCs69prm0RP79jtXy9UFLNzsI15+D7P5Q=;
	b=k4UR0UAztpgXgRlxRVe0m7Gj1iPFOpZlErLFOExUxZP1MlrdhD5mml2wliWwrOpJGhir
	 5tqs1PQvi1y/WUHS1ucJENZZfxFa4yUz10E2I6dipkJ8pYFW2nlGQKHOND70W1izi9U2E
	 0o4sf32Zh7MAT5G3s2yATmNCbqKyMemMldGP+CYZjpP5QS83rBWYb21yEMMEnhNZieCph
	 OW+TWbVxxs8eLchNerVlKgeJU9L0b5Gu/Y6OLbpYPeOXBruM74zMvkfqWHapW4vtxk4U4
	 cfD4LKZrj5q5CCvKMajB5+3jhrF8gRgdj2SFuzbsc/RcPUUKRToU4EV+foki7KB5Zuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pM+AHwSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67AC606A336;
	Wed, 18 Nov 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pM+AHwSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076531F000C7;
	Wed, 18 Nov 2026 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020129;
	bh=qWmnYqwszQgCs69prm0RP79jtXy9UFLNzsI15+D7P5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pM+AHwSaWgAKc4S8Eorr3DM5gP8hCaxsb2jesgxqVNjtUl30YQthjBB7gzXH/cHsf
	 xhDZTpoIjewGYGgPztk1GPAzKV8ZXpL3g48dDoKqg2UmJ5F9xq/zJNn3mC0Hx7BJwb
	 Wq9PT2NCIuEb23ImOrvtQL8LwSqjwpjzgsgGVJfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1843/2651] platform/x86: hp-bioscfg: validate SPM state returned by firmware
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150353.421874788@linuxfoundation.org>
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
index 040964ed50ced..343b2356943e3 100644
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



