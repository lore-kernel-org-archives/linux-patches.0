Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055667;
	b=OjEigus0X/uvwKj9HcHTBuLgjS8+4HPkf/1gdIuXmbx76ZRrNPRdoXWmTyMLydg9JGmh
	 4CBWKWoxjKwTyAEX8+MQurJz+UAGGVyAlHiT5sIy+NvP8D99C45BIsOge59l4SOj7Ty9p
	 RkNFD+MEiKgnNSQjlWjNXYTePQhassID+fA/y/TLLBgi96bh3BnYz60tyN6Hmrbdppxd+
	 hPq0NDTR4Uxoa6+WEfefnmWuO+9EKL1pci8l3Rq1uT+ZbxzD2SnPCosgFm2ZO9OoM25jn
	 PTgcEkiuBRpDHcATdM021UrUHXCVTv7NuHiAdq9Y8esgorlYogYvOJAf7A8nddJ56AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INXs/SM4CHS6Adbz++ygApxWFrWnFvjFDvxmAtTrirI=;
	b=PufsSsnCJH/OsCMcSCUVCHpitiG/+1eGDJBJJgRC8uzHrGLg+mp4FhJ88ziMfyPe8NND
	 8EezY4KOrNLj2ZKP8CE+8uAorLf2K1GXhRx0jVAlFDImIttxkt1TZDvaSyjbfhPmLc3aq
	 gz1xJnvhBZCpb8aSCXjOcXbv0Tzpgb4X+hPz2nmi6PSd1fRHWcFMFp+icbgo/A8hPGbcy
	 SH7PsBmZADeud4EU7IPcEVNZCPHhBRA64hEymq/cgrH5DS+ku1KGQx2S4gDHL+cBYD+Lz
	 MYJW1Qw7ClIdYMRDdHJZFagJkOxrnL0rQmQ15JVKu5pDeXlFe6UKl/qEbxp0M2tJC0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao74H9kB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE38606A31C;
	Thu, 19 Nov 2026 02:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ao74H9kB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9C91F000C4;
	Thu, 19 Nov 2026 02:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055667;
	bh=INXs/SM4CHS6Adbz++ygApxWFrWnFvjFDvxmAtTrirI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ao74H9kBVs4mb5USGyzbvl+rpjsqeM+GnTEJOrdw/t0vwbKm9SJ9iIvm9bkIm1amp
	 3mDn0D+1L5+lgj+VKaLLKFQX7YtSH+yYAE2kfn1Pj8t3XxXxPLhSXJbHTvOG0V0+fx
	 RZT/AUr8Hzp0/YO9McGp6QhgcKf82IWQlKK6ok0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1712/2214] clocksource/drivers/dbx500-prcmu: Check timer register mapping
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150120.247841310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



