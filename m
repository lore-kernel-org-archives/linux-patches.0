Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF3F3090C6;
	Wed,  3 Dec 2025 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776153; cv=none; b=ZqjV3TVrObYGJe+nXkwHZ0xFqY6RmQ1yY704xLj2znnlfVErpd9bbC1YbGLU3Ck1aesr81a7aJB3zU4nFLpOuR39z2gmX2HdV3JLndWqaH5cmuTtXaMSVc+/CFhE/BFdoBiQqyQix5HqdjS194WmWaU9EKVX4dq+E4ETAmT8mw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776153; c=relaxed/simple;
	bh=2/bMq2ETbTyl2xGre8AZ65yZquJcfM9q8uiVZp1mAr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br0qaohC3ZJ0d7/oP1zYW07V+SVtbBSmMqgVWU/SPcMF4NfLTVuUnsa6lnBrzErB82CrNdyghLWKIbH2MBgSOx5W6PhunDj2AggJe1hE6/fHs5DzsIZG55NkJXiVxaW51OLqP855DmGfIHnogyL/c065BvQsWI0JvYBhszKQY98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzXUdl6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzXUdl6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260F5C4CEF5;
	Wed,  3 Dec 2025 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776153;
	bh=2/bMq2ETbTyl2xGre8AZ65yZquJcfM9q8uiVZp1mAr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzXUdl6+A0k0CUXSnkgLTLqk44j1nlHQ1LHxBESu4oAJ/q05oH+sssePSwhc1bNSp
	 rm2xfsNpXEiS9kjFsYztxJhWYxfQQcxugPiZ2IdHEmFTIhzJCxqq6CT8bBKA+SyYEg
	 Y2Jb40zaTVG5LuMvJNkP4UWjIU7dKNNOmx1HAezQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/300] media: fix uninitialized symbol warnings
Date: Wed,  3 Dec 2025 16:24:59 +0100
Message-ID: <20251203152404.143835612@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

[ Upstream commit b4c441310c3baaa7c39a5457e305ca93c7a0400d ]

Initialize variables to fix these smatch warnings
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'protocol'.
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'scancode'.
drivers/media/i2c/ir-kbd-i2c.c:339 ir_key_poll() error: uninitialized
symbol 'toggle'.
drivers/media/tuners/xc4000.c:1102 xc_debug_dump() error: uninitialized
symbol 'adc_envelope'.
drivers/media/tuners/xc4000.c:1108 xc_debug_dump() error: uninitialized
symbol 'lock_status'.
drivers/media/tuners/xc4000.c:1123 xc_debug_dump() error: uninitialized
symbol 'frame_lines'.
drivers/media/tuners/xc4000.c:1127 xc_debug_dump() error: uninitialized
symbol 'quality'.
drivers/media/tuners/xc5000.c:645 xc_debug_dump() error: uninitialized
symbol 'adc_envelope'.
drivers/media/tuners/xc5000.c:651 xc_debug_dump() error: uninitialized
symbol 'lock_status'.
drivers/media/tuners/xc5000.c:665 xc_debug_dump() error: uninitialized
symbol 'frame_lines'.
drivers/media/tuners/xc5000.c:668 xc_debug_dump() error: uninitialized
symbol 'quality'.
drivers/media/tuners/xc5000.c:671 xc_debug_dump() error: uninitialized
symbol 'snr'.
drivers/media/tuners/xc5000.c:674 xc_debug_dump() error: uninitialized
symbol 'totalgain'.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: dropped ' = 0' from rc in ir-kbd-i2c.c, not needed]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ir-kbd-i2c.c |  6 +++---
 drivers/media/tuners/xc4000.c  |  8 ++++----
 drivers/media/tuners/xc5000.c  | 12 ++++++------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 56674173524fd..0c1c54b5a6f5e 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -284,9 +284,9 @@ static int get_key_avermedia_cardbus(struct IR_i2c *ir, enum rc_proto *protocol,
 
 static int ir_key_poll(struct IR_i2c *ir)
 {
-	enum rc_proto protocol;
-	u32 scancode;
-	u8 toggle;
+	enum rc_proto protocol = 0;
+	u32 scancode = 0;
+	u8 toggle = 0;
 	int rc;
 
 	dev_dbg(&ir->rc->dev, "%s\n", __func__);
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index 849df4d1c573c..c8aa193e04e71 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1089,12 +1089,12 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 
 static void xc_debug_dump(struct xc4000_priv *priv)
 {
-	u16	adc_envelope;
+	u16	adc_envelope = 0;
 	u32	freq_error_hz = 0;
-	u16	lock_status;
+	u16	lock_status = 0;
 	u32	hsync_freq_hz = 0;
-	u16	frame_lines;
-	u16	quality;
+	u16	frame_lines = 0;
+	u16	quality = 0;
 	u16	signal = 0;
 	u16	noise = 0;
 	u8	hw_majorversion = 0, hw_minorversion = 0;
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index ec9a3cd4784e1..a28481edd22ed 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -622,14 +622,14 @@ static int xc5000_fwupload(struct dvb_frontend *fe,
 
 static void xc_debug_dump(struct xc5000_priv *priv)
 {
-	u16 adc_envelope;
+	u16 adc_envelope = 0;
 	u32 freq_error_hz = 0;
-	u16 lock_status;
+	u16 lock_status = 0;
 	u32 hsync_freq_hz = 0;
-	u16 frame_lines;
-	u16 quality;
-	u16 snr;
-	u16 totalgain;
+	u16 frame_lines = 0;
+	u16 quality = 0;
+	u16 snr = 0;
+	u16 totalgain = 0;
 	u8 hw_majorversion = 0, hw_minorversion = 0;
 	u8 fw_majorversion = 0, fw_minorversion = 0;
 	u16 fw_buildversion = 0;
-- 
2.51.0



