Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025107;
	b=cXJ76UNH7UZ79FosYj+V8hcaqxTIBgw2k7WGviBNuQyizA+M5DvV0gyYMhprcLKsxy8e
	 xD7RynzEmJVF6d7syUKTzYbjnGN3gjPQd27568ETqlDDnLHc+E046vWM1RWKVG/U89QH3
	 uNDauzA63SerlP7BbmgN6zYItJtheRoA2DTMAaoI+zuA48qfHqJaNW+nTUSE/nlS2cOHS
	 tN/CwaF6ryfMPN2lphsREUJN8dR+akrEvGvLn86Pu83VJlF5qrNPEylbZqXlGK3SzL9k7
	 tYZvaPywjDrl5h6HoW2sdJ+o50bCl4uQhX1XfHTlsWKCSxb7U+WXBrJtOo12Zxz6utQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q2d7ICwAmzPUIfA5Ur74/Q4Xa1iukMZjUsvvVfGw9xQ=;
	b=IeGl4s+JqgEe7rg2jhihuahBedJ4NbnKBuAIGNEW96l4MlpqSr1qBuB7ZsNKyXCLRwsK
	 VAq+w3Aoz+/C+nWX1XJX5lxV+o0b3v3T+W2ifpYFkV+/lA3O8+mFl3+a5S0KZFpxIiU/7
	 02jiB1bLnQkEZ2F5V691zTBx8rS37nepPYfOw+3qNdXIylpyTnU4Tlzd7b33fIf+JmpoT
	 vJAgyo1y7gGIyr/bwYAxNc3EtpW5HbYIehhiYHMlUvzFbwYTFbdsgDVm7c60vVvgcV5HY
	 9L0Csbp75lrGxAeYilbCWnGTZP+7uMDTdCH7IjjXLKOw/7VRz9pILbESjeijrEdAtPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZCqLRYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A05606A31C;
	Wed, 18 Nov 2026 18:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZCqLRYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080CB1F000C4;
	Wed, 18 Nov 2026 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025107;
	bh=Q2d7ICwAmzPUIfA5Ur74/Q4Xa1iukMZjUsvvVfGw9xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZCqLRYdZpYf2fhw4sqvyc17jL6gipqsbAyhqyZY/8jXOywkbzrxAeggG9V+iaAu8
	 H+9oj4l93cQRhVBQ/4Fvw2CVQWAuQDFtv0TUe70cUKsLFkBqUwyQgLs5CuRxbEuJYZ
	 P/7enTPTDLK/md/xw5o6200DFBXAOLvI3SA2QuqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Szpila <bszpila@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0961/2151] platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150157.529389629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 03ca776a837fb..76a50cee59c01 100644
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
@@ -893,7 +895,15 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
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



