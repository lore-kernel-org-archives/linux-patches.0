Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018191;
	b=a5zKnOdr8kVNUVQ8zSh1DZUVFX5TYOVE/Pg8/O+UKApivKnk4paVanAdoGecQbieDiYp
	 LDdz5VF9VXxfWk7FThMxNwdv8xpkdQI5lo2+tU1OQ9uVBCbyAZGnkJ02Aso5uiutKgDdT
	 ViWZ0o0yymM1OiYImJ3cSKVn9o6xwjlzjtY9xDRqyTmBDyT+HiUfP3IQp15B6ZDeS6O7M
	 S85F9eN6fcpbiercgUFLGSADJtbpTWK2CFyyC2iKuaWugUGWJDshGUOPTKQFomb+O1x4X
	 CtAe3M8MmHfrizpbwGXke9e+wV7Hf90vsIm3/FVfFW1CvDJuH0u9qFW2M5NGSJjJDzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AUp6e9mxlB3dU4TE960HtGmDWAdt5QDw/phe6B3dBlI=;
	b=Fk38Y/ADZeldDu5nMuJ1kSghIdQUqMvZSTGZNZIJUkfxqSC8XMnKnBhcOhctgEaLZL6D
	 3/hYIOxtxZ0D7JW8mDAgdxMHgncsnlMD6+kvnClZjMgC6FQr2DjuwBguoIoCSPC27bzWB
	 RZF0Mt5hYXNGvaDbIjV3lU1PPyz1WgWPwt0w0T5setobyer15zXAhGPWLati9IDXDU2zj
	 kY6DJkjDb645yy+IavLBo5foGPzI3CJlJpQNZcf2Samw+A/h7kSUuLBsij2lx7PWSRhcq
	 Te0MwCiQg/3leMyWU/kDx24CiW3CYhgScGaCxA0ANIsP1G7KTfGLA+gny4eVFwVMVKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlxAQCwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66DC606A32A;
	Wed, 18 Nov 2026 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlxAQCwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE21F000C4;
	Wed, 18 Nov 2026 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018190;
	bh=AUp6e9mxlB3dU4TE960HtGmDWAdt5QDw/phe6B3dBlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlxAQCwUCvXhdqjXUr4zJmTcXuvTtwqz6r4dcO77I9iwEUAQQeVXlP43YBHNCM1rr
	 cSEzscalrABGeBKTaNqrDQxCs0HKvxMAaM6CNV3X/TxJFnX2cD+pa6fFjDbTHK/ssP
	 00eKaJNkKx6ZQKVwxgxn7sPyKlBlyG68FaSOCvRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Szpila <bszpila@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1152/2651] platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118150329.480286454@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Szpila <bszpila@google.com>

[ Upstream commit 317e7abcaf60b79765dcf35c014edac8b9d37a6e ]

cros_typec_register_altmodes() iterates over sop_disc->svid_count and
sop_disc->svids[i].mode_count from the EC_CMD_TYPEC_DISCOVERY response
without validating their bounds.

port->disc_data is allocated as a buffer of EC_PROTO2_MAX_RESPONSE_SIZE
bytes, and each SVID entry contains a fixed mode_vdo[6] array. If the EC
returns an out-of-bounds svid_count or mode_count, the loops read past
the end of the mode_vdo array or the disc_data buffer.

Validate that the discovery response with svid_count entries fits within
EC_PROTO2_MAX_RESPONSE_SIZE using struct_size(), and ensure each SVID's
mode_count does not exceed ARRAY_SIZE(sop_disc->svids[i].mode_vdo)
before registering altmodes.

Fixes: de0f49487db3 ("platform/chrome: cros_ec_typec: Register partner altmodes")
Signed-off-by: Bartosz Szpila <bszpila@google.com>
Reviewed-by: Andrei Kuchynski <akuchynski@chromium.org>
Link: https://lore.kernel.org/r/20261001085714.1086242-1-bszpila@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 50a68819ceb7b..4427897eb3f59 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -7,8 +7,10 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/array_size.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/overflow.h>
 #include <linux/platform_data/cros_ec_commands.h>
 #include <linux/platform_data/cros_usbpd_notify.h>
 #include <linux/platform_device.h>
@@ -894,7 +896,15 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
 	int ret = 0;
 	int i, j;
 
+	if (struct_size(sop_disc, svids, sop_disc->svid_count) > EC_PROTO2_MAX_RESPONSE_SIZE)
+		return -EINVAL;
+
 	for (i = 0; i < sop_disc->svid_count; i++) {
+		if (sop_disc->svids[i].mode_count > ARRAY_SIZE(sop_disc->svids[i].mode_vdo)) {
+			ret = -EINVAL;
+			goto err_cleanup;
+		}
+
 		for (j = 0; j < sop_disc->svids[i].mode_count; j++) {
 			memset(&desc, 0, sizeof(desc));
 			desc.svid = sop_disc->svids[i].svid;
-- 
2.53.0



