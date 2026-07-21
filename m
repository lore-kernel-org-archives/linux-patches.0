Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61B40802F;
	Tue, 21 Jul 2026 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659179; cv=none; b=o/0leS5EEQJlo557PYnUUWWu2K5mRCU5QkdjOlGK2GYGLdkIuF4S5w9LBXiWlzEm1d3i4x01xhwKhm75CITYtZLQM6+d4LquaSxGwHMIubJlzG8tGLSfA2rRI7biNT72na1GXfTPBg06nDXXjo2MOoitNGC8a/IAEQMAlfwFHvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659179; c=relaxed/simple;
	bh=+Srg1x+9A/2DlAoiO9AAbTzNrcRpHJoXS/sXSg/BAmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5eKova/sezdVvGOEHlW44o02Y1UyJ5ALVMNbgIBY6wsxI3TnG6sHYzv2m6+BTB25db7UAjXFJJUPDT5pQbdgYjFTN+lzeMdegO+yY8PonbH1EvDKxD30/nrLu3prmFLk4yQuTkFd7iCcIQW3Eau7QKMsb9HVQj1QFK/58D9OzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ay2IPTZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ay2IPTZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC541F00A3A;
	Tue, 21 Jul 2026 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659178;
	bh=PSWXxCuec1oxEUBvZkQYUzs1fW9sEx48C1U4VZvJ5Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ay2IPTZYYfcW1eIzBCwDUF5X4XDdLZdUcvcY7eMc5VM98oAnelfsGzrdrezp4dx3z
	 1GjSnTCxewIjmUacsZn0IWSkRAGP0ASnULfidRZmtEdhIw1g8sCwGlaCJhm4nGCQH9
	 B6tf07NPAACU/AtYgEI2SZrAiKSe0rM8B610cVLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.18 1422/1611] pwm: rzg2l-gpt: Fix period_ticks type from u32 to u64
Date: Tue, 21 Jul 2026 17:25:38 +0200
Message-ID: <20260721152547.422117686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 2b40d72de9354a76f5e3bb71230a4210eaa92849 upstream.

period_ticks is used to store PWM period values that can exceed the 32-bit
range, so change its type from u32 to u64 to prevent overflow.

Cc: stable@kernel.org
Fixes: 061f087f5d0b ("pwm: Add support for RZ/G2L GPT")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260604095647.108654-2-biju.das.jz@bp.renesas.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-rzg2l-gpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-rzg2l-gpt.c b/drivers/pwm/pwm-rzg2l-gpt.c
index 4856af080e8e..c9dfa59bc1ea 100644
--- a/drivers/pwm/pwm-rzg2l-gpt.c
+++ b/drivers/pwm/pwm-rzg2l-gpt.c
@@ -81,7 +81,7 @@ struct rzg2l_gpt_chip {
 	void __iomem *mmio;
 	struct mutex lock; /* lock to protect shared channel resources */
 	unsigned long rate_khz;
-	u32 period_ticks[RZG2L_MAX_HW_CHANNELS];
+	u64 period_ticks[RZG2L_MAX_HW_CHANNELS];
 	u32 channel_request_count[RZG2L_MAX_HW_CHANNELS];
 	u32 channel_enable_count[RZG2L_MAX_HW_CHANNELS];
 };
-- 
2.55.0



