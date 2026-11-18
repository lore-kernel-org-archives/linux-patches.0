Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030571;
	b=GvElRQYFvQw4EB6ifo4xTTogMP+O/BoQcKtqyQpZFpmnrofKCrhiP6TlYGyomES5xefu
	 WYzY071t+xVUdxFzoACns9XXMt/2mPEkWHlQJF36HGxKCTELaZxa2SjxQNkZ2pgrBOSdw
	 Yl1mBqxvWe4jvex9S1L19O+23Xs7NxHrOfm8jCwHJkHQUSoK0IgP7y/gQxTwgPztic8dm
	 xcxor35ZgPhmMt4Wpslun7sBTaf8YvV4sQk6+XZXIaQQ21DEQLvA/zm+pT0+EUTw4VEXi
	 ocXh2hnmnhYyuIE5TmGoFV5BxG1zt0Gi2lQcmcMSBMKE9oCqRzaTfxTgiv4h31Nhp9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pkmSh/RLd6+JUWeBFElRWr7BppRanU/6LvJIMTHn1U=;
	b=DSpMCXYDc49ZOMZXsWxUtd5UGn2sXuJYo7JYNDRvq8RMzY4S+OJYF99i/5GVZq+1LmaI
	 4Cslzr3VJDCyfg41rDjwpnkmvMEGdYQJ53JbSB9wNo4bUpR3HPmsWoVOlSAApxZByy8p6
	 DIXKxV1LyIR09qRI7ZW0kc19tgyr24+c9VZGkPymBC5HChIU6M4xZjL7o3qCW3rZGF8Y6
	 HSs8qlmf/9HfyYXE78rL1j8Qw3mlE3Hy5f+HiZuaQCZWMXAETbjHfDb7e/KJ/9biseQFb
	 bNRIWjfeUEKQcwlU0gLqvCW+biqJRC1O/nW7OHOHUtVJZ10mBVIsnnrv/OJTh/gYeuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXuRlevb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2060606DD3F;
	Wed, 18 Nov 2026 19:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GXuRlevb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009771F000C4;
	Wed, 18 Nov 2026 19:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030571;
	bh=6pkmSh/RLd6+JUWeBFElRWr7BppRanU/6LvJIMTHn1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXuRlevbfEE/et88f3d1pmcpXnyTzE6OWikwga/tqvrmpLOsCu2s9A0Dl0dLxj7TJ
	 XlhrYjVptcRRP7OFA3XF1AEXDCfqq0bo0Ka8C22WIYD+5S8velYnzDJazpHbFQzjvP
	 dY5yN4RFbPLB5MonNUUwtmttIxw6O/yRFLHzw+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Szpila <bszpila@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0753/1756] platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118150039.623073717@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c0b814973c04..742325f6218e0 100644
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
@@ -764,7 +766,15 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
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



