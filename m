Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044028;
	b=aiPw7Bt5x6n0zWwHbCAD2y9qcm0y2WU3yojZUdrIU+IPXkXVSJbovuvSyBoatDY28nBw
	 j/faHhOHDW2rq9ow2AwDFwBZT6vXIeTnykDRLnulhZxMQqadrNhs45O6pBbpOGBI8X12W
	 W7P4vS36dLZk7t9OgJWIV6F93LPIjIWxmZ8xPODeHyUxVmBRpe53O3s7gAmY5x4DgZ9lq
	 QJkX90tF/U4AViAz/i7iKrcvdenaYRvA1LftfjMRrx0TZ4OTzkqLdCma+IPVPsg/ODKqO
	 jxveWz33n9e2PtoiKbWS5z7GsEBbj/r3fb+lc+qYLm1iebjs9h1SR6rl3hvizCq6Lfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WF3x1tEEhxrBbWyIHiD/j+ihD6p2xf1CwdqUszSIakY=;
	b=kD8K/HPSYUkyhIT6prolJqUvPMzXpFJFR3r/tz4f5Ucj9sE+pbPRbL0JxxK9G4Aa8PTx
	 fy1LCQf8bqabtK+flbunkrNw3utO4LDXmWP58rinuNW6wjYdWAeglZVWYZPeIyzmPM06g
	 GzN6nErcRfLwPPHqOQkGPVzVz2hAusciNABJepWj7vbn1KEq4s8gVwd6Cm05BodhKkIe2
	 VWNx4lsIADSx079qzxKDdT2jmidSlMIZVdLBmKWGmdmCp4TGuGGb9WOo0NRjAFURhpJ8J
	 6r1CdeZSfQ76x+ccVyoNX/l7gSGCB0Ntu09oGw7/xQ6bEWygW+WDT4ZdQVcla0pCpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUHMs+LW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF506606A32C;
	Wed, 18 Nov 2026 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUHMs+LW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B921F000C4;
	Wed, 18 Nov 2026 23:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044027;
	bh=WF3x1tEEhxrBbWyIHiD/j+ihD6p2xf1CwdqUszSIakY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUHMs+LWedXUXYucqS9IU29m5Yd0PC4V6fpyS3bByZ/V2dd98BPp+ofrZhL/0Z4Tb
	 0LuxUY+f0QZNivvBLglZx/uVNb8/o0qwiUPvY8iWNrZsLCN8Q5sX34Wa0XH1oHnBtm
	 OPf/b1IEhuUD5Du6avF+wjvNlbedHzs8zztWy1EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0422/2857] bootconfig: Fix integer overflow in initrd size check
Date: Wed, 18 Nov 2026 15:24:16 +0100
Message-ID: <20261118150216.577820917@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 7812d6dab0698001e50e8c2f901e17da3eb6f429 ]

Sashiko reported that in get_boot_config_from_initrd(), a crafted initrd
with a huge bootconfig size (such as 0xFFFFFFFF) can cause the pointer
arithmetic:

    data = ((void *)hdr) - size;

to wrap around on 32-bit systems (or when pointer subtraction overflows).
Because data wraps around, the subsequent bounds check:

    if ((unsigned long)data < initrd_start)

evaluates to false, bypassing the check. The kernel then calls
xbc_calc_checksum(data, size), which attempts to read 4GB of memory,
hitting unmapped pages and triggering a fatal kernel page fault during
early boot. Furthermore, on 64-bit systems with an initrd > 4.29 GB, an
unbounded 32-bit size can similarly bypass the initrd_start check.

Fix this by:
1. Ensuring the initrd is at least large enough to contain the bootconfig
   footer and verifying hdr is within the initrd bounds.
2. Checking that size does not exceed XBC_DATA_MAX and does not exceed
   the available space between initrd_start and hdr before performing
   pointer subtraction.

Link: https://lore.kernel.org/all/178905333479.213925.1358412668943562406.stgit@devnote2/

Fixes: de462e5f1071 ("bootconfig: Fix to remove bootconfig data from initrd while boot")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260910010137.EE0431F000FF@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/init/main.c b/init/main.c
index 78d0e33cb6ee6..cd1b46b008ca0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -275,7 +275,8 @@ static void * __init get_boot_config_from_initrd(size_t *_size)
 	u32 *hdr;
 	int i;
 
-	if (!initrd_end)
+	if (!initrd_end || initrd_end < initrd_start ||
+	    initrd_end - initrd_start < BOOTCONFIG_MAGIC_LEN + 8)
 		return NULL;
 
 	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
@@ -292,16 +293,26 @@ static void * __init get_boot_config_from_initrd(size_t *_size)
 
 found:
 	hdr = (u32 *)(data - 8);
+	if ((unsigned long)hdr < initrd_start)
+		return NULL;
+
 	size = le32_to_cpu(hdr[0]);
 	csum = le32_to_cpu(hdr[1]);
 
-	data = ((void *)hdr) - size;
-	if ((unsigned long)data < initrd_start) {
-		pr_err("bootconfig size %d is greater than initrd size %ld\n",
+	if (size > XBC_DATA_MAX) {
+		pr_err("bootconfig size %u is greater than max size %d\n",
+			size, XBC_DATA_MAX);
+		return NULL;
+	}
+
+	if (size > ((unsigned long)hdr - initrd_start)) {
+		pr_err("bootconfig size %u is greater than initrd size %lu\n",
 			size, initrd_end - initrd_start);
 		return NULL;
 	}
 
+	data = ((void *)hdr) - size;
+
 	if (xbc_calc_checksum(data, size) != csum) {
 		pr_err("bootconfig checksum failed\n");
 		return NULL;
@@ -400,12 +411,6 @@ static void __init setup_boot_config(void)
 		return;
 	}
 
-	if (size >= XBC_DATA_MAX) {
-		pr_err("bootconfig size %ld greater than max size %d\n",
-			(long)size, XBC_DATA_MAX);
-		return;
-	}
-
 	ret = xbc_init(data, size, &msg, &pos);
 	if (ret < 0) {
 		if (pos < 0)
-- 
2.53.0



