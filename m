Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDE2405845;
	Tue, 21 Jul 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655069; cv=none; b=eWHuoWiC266yZhE7j2ZU67ef9BSUc3osTjDbuB534xQgt4AEbfBmdgAiqgoq5Is9e5D8gyJ+QMWcyaQKABnKAFhlLXVgqYKJrjjylYqiBDzYmCYLF5Qruh3V2/l7AgGSNvrll2BoFSS90fTpDLgLFj9ScQe0Ra0Po3V/gezeQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655069; c=relaxed/simple;
	bh=qBCoPWZ1hkA2MQrIsujUTk4Z98afKMZ4vHtDboj2pmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rE+mxIAy7WEVPVAVhQiDTAiuWTOjKY+9KTRz6PYg9UnM5svxEC85+9tj7UNwCBPgDnjMVuo1yYNXgZegoaR86PgPyqkw6hiWMCQG2hVupbxs/sDExSXrhEF+qLnuQq0EY6R8Ys5pL7WfdZyYcYjuUeNxOHvrjbqrJ5ftEZa5Fdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFAO9k4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFAO9k4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC291F000E9;
	Tue, 21 Jul 2026 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655068;
	bh=huI6vhBRLAlspCriag7UbNsdX2cXOvw0k/wruXLhsjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFAO9k4MuaQFNgjbkqL7OA/4DKJpwBhb+NbJtxGHRpOBDXuOqEXFh450CcXodjz47
	 W8T9or/hvYVxmwJpq9iE4D23EOlkA1ehw9I7GDvJlrnKgJE4b+SgFTiM4D2Tg0Eplg
	 rK2TdPq6g0UQ2AyaSuLz1B8Qmij5aB1uPheoFKRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 7.1 1937/2077] pwm: rzg2l-gpt: Fix period_ticks type from u32 to u64
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152638.395106408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pwm/pwm-rzg2l-gpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


