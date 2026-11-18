Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031834;
	b=XAvvDolGYsFBqtHkFhxvirQcSzVcEQvCD1z/GRugEnRmJFJttSlgDP8Hx2tHqoGaUTh0
	 bB6H7EMslhbfWB0lk2hPurXXpEYmE43o7gFPWKmJjG//dedglW//1az7qaPWFGORbPX2Q
	 N9wgDp8UqDQ1B568WH5SL+oOk9mdgHhW7KtZ+mf60FgFSn7C5FXy9N5OnB9+ePW7ntHSs
	 UuxbWSZ5AEZG5utn2nWHeVpzJCBn0UGIGzH2ri1OXE4st4ajD67pAOHVb0vk2dMjlR9GY
	 dIKYfmn7u9Si0da1MO0CFZZp0JqkW1kM7ZN60oJtVtmDea7f2f++Q9xEDEYQN5uOtqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4GL5FtQCn6FNsk3DunTrZVcWsHTt09chytMCUPqW5iQ=;
	b=LUfIgiUSOfebJgIkYafQM+XjGiOb5iOAwbY293Xxavm49ywo8GdCGdotErPaoDg+R8IQ
	 n+NCj0kqDZHWvjvFJq1mUXhzuilLAM33a5xtnaQ7s3HsF4VYgu7UjHVf5+0TWpa1Cs/SW
	 +7AXc+NYmy5VTDHT/odaumATr99EZ8kQ4dw8euZwwc79adqN6aWPlLiWE1Km67xBt1VLa
	 wUxsnNgTHPEF84qJTjn6VhZs8y7J8puyWGnn/4MJ21n8XiTRQonlfVvti6rmTpAUpkP2W
	 vlch1yfZ5jHuwBegN3y9kTirNZSLN4C7l/N2wqlZxqcYFd6e6C3FcUZixrTx8VCQdkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdoRu9J4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FB606A320;
	Wed, 18 Nov 2026 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdoRu9J4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA831F000C4;
	Wed, 18 Nov 2026 19:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031834;
	bh=4GL5FtQCn6FNsk3DunTrZVcWsHTt09chytMCUPqW5iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdoRu9J4W3S4X9RizvkUvdHx/hgKS43XTNQqx+Ukzzwb9lTEnY4elZxEQD7to5wp7
	 DMrrAckM1F0ZAgS+y0MJWZwPgwYQKccE/Yh5UGlb060x8kcD1NaB915Gk+wUxXl0IH
	 JFsMkjJPFQkUi3eP+8fhPmINPN4mf9gSyB5g7y54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1191/1756] platform/x86: hp-bioscfg: validate SPM state returned by firmware
Date: Wed, 18 Nov 2026 15:55:18 +0100
Message-ID: <20261118150057.292879561@linuxfoundation.org>
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



