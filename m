Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048983;
	b=bR0rEibLmcqtJ+BI2dmkvJcYoOwe5no631vmqWfMjEfMo+YrNbemQCH7dUsYJ5hbUkC2
	 C6WT1G6cf6TkICFiAYgPTb5F5BqRBYmH4XBnd7ZOEzLWkn8uWlraynt2OY7JN7PbZySfM
	 QUV1Mg2e/m8Ckt2RWZ8Bg9uhR5Z9XhKjGMG4IqTVHNn8GMgprg+EjmOFom9yoakDUn9kC
	 kGMPxYuaxKQXYmDh8gwGS0o8KbE5Q+IsVEiLB4oon4yzRSTwgntmn35YxIwZt3Wbtuf4i
	 oR2l1w5+AyZ9FT4uBSJ/8mjEkPa+WJeieBFpOU/lq55rMlcPuNMeRHId7G9pMMTfQaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tv0+R1iOQkxiU9rFFaeBIaT9ygx0XRZg3Qfz0sjab2c=;
	b=xA5l15XPXhSDl8JQM1fAEBPNU515twq/FObTN+WPVsfz/c9uJKW88w/TmNWS+kQS8rmo
	 lCrVsDgNveR02+c9q3/d6eBsNA4tJIU34eNMv7EpXmGYd+YPnNdq6m2+5S+P9u+duU1+8
	 bnbbHjMshyCD6EdqP0w/IS3GdQMYSjr4gZTF7WrH/ianCQO6Yj7K7cmEVj1Stp8Rgocnl
	 5m+aGHYdpa4dmcIjism2gAXxgjXC3No0Y36Ucx11hGTzeBFQwt8TSXYLI47x1sLiFWEV0
	 JJuY7XkbEB7cyjOoUwtBnIB9k6cY1qa2f1d1nMApcVlvRQA8E4jbs3eyZ1wb7uE3wlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sitvrubx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76829606A320;
	Thu, 19 Nov 2026 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sitvrubx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA3C1F000C4;
	Thu, 19 Nov 2026 00:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048983;
	bh=Tv0+R1iOQkxiU9rFFaeBIaT9ygx0XRZg3Qfz0sjab2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SitvrubxW3x1Xrfam28LcLr4n09eANPMCTrmd8gUqLjFk1EX2MlBAAFQeSfKkUiW3
	 qcQncTxwkWrsRJA9st9X0CdfbZaBrpOMPJwegwETojbhjd+He/kZk3qXPMZZP8oXhm
	 NK7Fg62ymhmeAAXtjpc8o0fkjwbki/umLs8JaXVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Szpila <bszpila@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2172/2857] platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150319.609515281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2febfef7943f9..02d7533ff8e81 100644
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
@@ -678,7 +680,15 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
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



