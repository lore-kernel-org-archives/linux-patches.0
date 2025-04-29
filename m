Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B7527453;
	Tue, 29 Apr 2025 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945232; cv=none; b=pFO2TDPJgZsgxb437i+rOj4crBNe0Kyhlbb9m6gX+EhPFJzSQmLYCw+DaOBDPPvM2ycJlInVYpUa+HQcr0jUGos9UhuuBwZ0XHQK8kfjpMe6qUf+aYcFcd1NTnwNJZPFFMKp2eVR9jmE0RuIs4pkY4P4ast/yy6vGUuwY0FzVFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945232; c=relaxed/simple;
	bh=2rRHr3pMqFAziMk2PxoF8JhGLGm90YbfcxPPd8Kud0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVa+b0rYX/aqXwkR9bhcllE0IOhc2hBYY0tU0UZo1gudRo5hJlqBPFXOwfo2gbsOcClCWVxb6P6m0e/5yv3CJzBs5bMxUbQVjK4DMt9G1lcgWzZibIQ9BUsEvUIah19i2A4zC2Sa3LDMCu4z2yMkUxfM2vt9F04C5p8kdOHUEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhzGVdhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhzGVdhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374A4C4CEE3;
	Tue, 29 Apr 2025 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945232;
	bh=2rRHr3pMqFAziMk2PxoF8JhGLGm90YbfcxPPd8Kud0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhzGVdhztW5QK3UZfKVX0mIUIYDY9n5u9Jj4w9pUUepAHAGFCOpzpnOabXlzWJNAJ
	 CWrScyGZyBEUKZWKQ2ky/ZgS/wi0VUVPHS8cZBHWImkJ/pQPDWe98dMCKb4lbH2U0d
	 qkbAv5BH5/8fmXycMQoXNLYivsHe5rekXhx4UgrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 044/179] media: i2c: adv748x: Fix test pattern selection mask
Date: Tue, 29 Apr 2025 18:39:45 +0200
Message-ID: <20250429161051.187281385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

commit 9e38acacb9d809b97a0bdc5c76e725355a47158a upstream.

The mask to select the test-pattern in register ADV748X_SDP_FRP is
incorrect, it's the lower 3 bits which controls the pattern. The
GENMASK() macro is used incorrectly and the generated mask is 0x0e
instead of 0x07.

The result is that not all test patterns are selectable, and that in
some cases the wrong test pattern is activated. Fix this by correcting
the GENMASK().

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: fixed tiny typo in commit log: my -> by]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv748x/adv748x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -321,7 +321,7 @@ struct adv748x_state {
 
 /* Free run pattern select */
 #define ADV748X_SDP_FRP			0x14
-#define ADV748X_SDP_FRP_MASK		GENMASK(3, 1)
+#define ADV748X_SDP_FRP_MASK		GENMASK(2, 0)
 
 /* Saturation */
 #define ADV748X_SDP_SD_SAT_U		0xe3	/* user_map_rw_reg_e3 */


