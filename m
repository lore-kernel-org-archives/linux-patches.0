Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030591;
	b=lDpSr3lb77dPVdCgb3JjyxrIl8RQCG35LxFA3ed+adUI7hb1XgviqopsPSBCG7nMyQNY
	 etQ7xFmiMc2PggoeKYg9AXY7UzyrD4F0gzP5F2hza+QJQFte3aCVOZ5OxK4pFvdjjZixL
	 T8+Q+Bw1Ftcf3sA6XnsNBK2JIU0j/oJb09XEN/InsbHTmpj0rVDDH7zXubW1xQOXg/UR1
	 0tIeiKkUB78mQF99XNZhBgtUthAh+b/PJkqbiXVLpaWrT17NPo3GLp+J/U9dOdlFehg8X
	 R7DidziJMo9LksIF7ol+0tEU1Ru8lT3P6enFNp/0Mzhswy9u+TvkQebgtO8UckvHXDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8NZny8nt9Uwm9uLwdEUoRlKXHyJuj90cFgGryiok4Sc=;
	b=Z9F3bhaXTRkYLXwVkyUqblTVbPFhwCIqP6neEWWI0aFfCz6M+9Wuw7lOIzGPGLuje576
	 JImd/wVnGOmGEu1WcwGyFuStzs95jQBQQBMgpTRz5H8NAm7hO/C1dY4eIwwyI8ednuLJy
	 eKs9uTrm08TIsDyRB0Njg2xOZGVcu3wSkUtzt0QF1j7btzNoaq23TOe+TecPzyz0A/Gpq
	 Nwyl/PcyXQLNRKgjU3qsVncdocumD0F12a+rV26YKBKv+8dDIb7DHusn+lhUgTD8rBm+a
	 3lSjXoIC/nx6nyLLL4SvNwIxOWRrSC/69mDw0CtDGkWcPVlqxnp9X5C9VH9vlIdEM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYgPU8Oq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EBC606F255;
	Wed, 18 Nov 2026 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYgPU8Oq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518601F000CF;
	Wed, 18 Nov 2026 19:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030590;
	bh=8NZny8nt9Uwm9uLwdEUoRlKXHyJuj90cFgGryiok4Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYgPU8OqbjZSUQFQqNEA9inlV0LPOirqJoG5J2BoQrss87mmn/z+TkfrrZm+LqCWB
	 WrKmH2+FsTuGkUA6I+nVIY+S4K9ZnKLKTrD4DiqpZHzYI9+4WkTyXMzcxu+hYp/MjV
	 vQoj9UEjp6q1V7vutYibtkBK9N9teGBT63L8LFlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0760/1756] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:48:07 +0100
Message-ID: <20261118150039.882202630@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 8f30b035a6676e292ee8e54334711d9905dd0495 ]

Return -ENOMEM if of_iomap() fails, before reading or configuring
the timer register block.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 9d2aa8c7961a ("ARM/clocksource: use automatic DT probing for ux500 PRCMU")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260911060917.94310-1-bolin.liu@seu.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 2fc93e46cea38..1af223b0e8963 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -52,6 +52,8 @@ static struct clocksource clocksource_dbx500_prcmu = {
 static int __init clksrc_dbx500_prcmu_init(struct device_node *node)
 {
 	clksrc_dbx500_timer_base = of_iomap(node, 0);
+	if (!clksrc_dbx500_timer_base)
+		return -ENOMEM;
 
 	/*
 	 * The A9 sub system expects the timer to be configured as
-- 
2.53.0



