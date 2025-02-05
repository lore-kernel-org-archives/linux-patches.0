Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898BE14B959;
	Wed,  5 Feb 2025 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765770; cv=none; b=jXoMv3tTycuqDt+SIpXiqRHVSWZqmHgZaavy7jkp3ZFgiOiyobaBMj1MakWjAakIUVvN/uuT7tUCLgup//oDraVuQ4u/ZN2uOtcwEopjBsfdtXntZFkUdqYi3vZrWjl8QUZnZkpSDkFjUyzmHeGtF2rdnWmmjOWQyTrGiKoHQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765770; c=relaxed/simple;
	bh=7q21dvIFbvssZmzMhahlzCh9Ydl1kl3xTHD1yg+wBOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrw0jmxfNJr+OOFLPIPRE31UjQjqanjvsJyDC2rNvQQzhZEchSDNmtb4gip2rWrngNiwGENPqPmSula6PSUwwVyqg+0p5sfDiZb3Dpuu/x+OBvU+v4d/yK+PE8kb1Z/vPULNF3e5kora9bdTvCE2JEYj6NeUdhLwxs+UmS+pi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3kRwJ1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3kRwJ1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832EFC4CED1;
	Wed,  5 Feb 2025 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765770;
	bh=7q21dvIFbvssZmzMhahlzCh9Ydl1kl3xTHD1yg+wBOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3kRwJ1hT99SF7rhs3vD7Ih/0sE1qHdAmj3ueU9Zz8XhwrXNOEO/LfpdM3S6mOn9w
	 iAMYMG3o2RNrZdj4f//e/MKZj+itNwyVrNcUyMz7uKaH1q8F/tylDBBTwT4DwrUy3u
	 JKw+UOBrkdzCSq5C/OtbFY4S9+KjV89zk2mrUmRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Desnes Nunes <desnesn@redhat.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/393] media: dvb-usb-v2: af9035: fix ISO C90 compilation error on af9035_i2c_master_xfer
Date: Wed,  5 Feb 2025 14:43:36 +0100
Message-ID: <20250205134431.675686025@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Desnes Nunes <desnesn@redhat.com>

[ Upstream commit c36b9ad1a8add3c114e25fe167efa217a813b0c7 ]

This fixes a 'ISO C90 forbids mixed declarations and code' compilation
error on af9035_i2c_master_xfer, which is caused by the sanity check added
on user controlled msg[i], before declaring the demodulator register.

Fixes: 7bf744f2de0a ("media: dvb-usb-v2: af9035: Fix null-ptr-deref in af9035_i2c_master_xfer")
Signed-off-by: Desnes Nunes <desnesn@redhat.com>
Link: https://lore.kernel.org/r/20240919172755.196907-1-desnesn@redhat.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 4eb7dd4599b7e..7caf5e90721a4 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -322,13 +322,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
+			/* demod access via firmware interface */
+			u32 reg;
+
 			if (msg[0].len < 3 || msg[1].len < 1) {
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
-			/* demod access via firmware interface */
-			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
-					msg[0].buf[2];
+
+			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
+				msg[0].buf[2];
 
 			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
@@ -385,13 +388,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_i2c_addr[0]) ||
 			   (msg[0].addr == state->af9033_i2c_addr[1])) {
+			/* demod access via firmware interface */
+			u32 reg;
+
 			if (msg[0].len < 3) {
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
-			/* demod access via firmware interface */
-			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
-					msg[0].buf[2];
+
+			reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
+				msg[0].buf[2];
 
 			if (msg[0].addr == state->af9033_i2c_addr[1])
 				reg |= 0x100000;
-- 
2.39.5



