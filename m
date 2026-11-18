Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040584;
	b=xd+vq1gsbijghK0Q+1Yj1gTIIfV7PsWr0tdcMbOP1J/K+uLkfqEypVUbV1p4UQx420KK
	 zGvHBCL9e49wvYhfXxjRVYaUhy9TF/nWXuH3wEQ2j16t33ojQ0r9/UHFRMyb+9jAUXeE6
	 IeuKZ14WWUiuxcf6dlMsn6LGXWkriHaHJnTZvplFN4Us5uW0mIf+za+Zbgs2ltb/+yPFm
	 /f0Kmow7opet9UDzzga8KJPSMeTC9WGnqnXU0fpuE6vSolc+QkxREIM/ip+rWb8mUFnyE
	 UvIkxvZS1b4y+zHDG0xtLNBxalA4N8tKuKsnO+IKCefgOdQ6HnJasT3jKHYUKCBIRxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+d9WZ8XO7nE2ihjoP1tByouzdlbN0+P/ZOjG22ahJYs=;
	b=M0dOzjest+CMCvmNvPCQqBjPGR1h0DlYIHtlsYDD+54PIzL3NnUy2l19CHKe32rn91yH
	 KgqEiV8NAghHUNN2q3KjwTgLpI+3Nr4/EjmvXWHt5RtTSYTYbjwON9XLiFNvnmaR0tzOo
	 0W3GvpUKyZHysP0KRPdx5XgyHwdKw8tVXiQm+/oo7Amritha+tUVoDYIs+cwVpo+QtPtC
	 DAX1U5z5HdBWbadAmHi7gCaetIGkuX08kQGyO/aqboYhA+4ENqOOLLC1VTFzHHTYKboKF
	 gP8MnbouNUVe4eqOWnUzgcvNstnj/bCt0jpCgKB4apSVOqH6Xs2nVoBG0CCCRrrg9Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcymQ1Yr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A279606A31C;
	Wed, 18 Nov 2026 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcymQ1Yr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6B01F000C4;
	Wed, 18 Nov 2026 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040584;
	bh=+d9WZ8XO7nE2ihjoP1tByouzdlbN0+P/ZOjG22ahJYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcymQ1YrNfmNs0CcRViucPxqDd54JJXxkrQv6OjTPQSxpRTT7pLk5KduVMsNAtzDN
	 lYrF2RYOm7iDbwz2i6ZH1ZTkwJXZYR/gnmcyIF0nvyVDQYO15oRtZusZxWg1y8RYYy
	 OKFEImWN343S4YGKJzoR4bTtz/LlXYRHvqreEShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Szpila <bszpila@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2510/3318] platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data
Date: Wed, 18 Nov 2026 15:52:12 +0100
Message-ID: <20261118150436.668880261@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65549c3a67486..f4a71a6297742 100644
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
@@ -717,7 +719,15 @@ static int cros_typec_register_altmodes(struct cros_typec_data *typec, int port_
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



