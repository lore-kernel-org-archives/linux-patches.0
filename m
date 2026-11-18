Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036819;
	b=CLFRq96HN47aRs5KAHiqByAj4YLKE71nJaFh1b1LJYiUMAZN+rogn1cetmMSl1Bv3uHM
	 fRqZ7DmQBuAxCOrRCn6JvItu+JcU/gWblE51RbqJjY/yhVmF3jPKAuhw9OxhUF7abFZeW
	 4c0IcLhdMo/cvEK7e46G7bEZcUWkm51AG/99R3MgSQTxtsfa3n3JZ2wttfF6nb8SAekh4
	 in8WImoTQZdhgdLVpuREw6ilchwdXjXn4VxdVGZxm6/z5jXrNVI0yXiMdg56BV2HbCIwC
	 UK4dUFAi2ceXpQC2WD2SoZWV6+RbkkBpU6QiGKs0qJpK3sn1tGhE5iqMksMgQH/HI9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5WjR64t0pGVKSDufAsOH7hPkYzW4q9sXgDR5UoRbSc=;
	b=Cyh4NqeFbmhU1+VKZIxBGFgtd/nnraAjmnYNLpJOqmkDO3295tBRY+7jt6WfELeCad9T
	 aUnqhpYazG8Qrtw958UE3mLO82LA0YvkPnyigC5QbzxlKzBfvqlc10YxRFsjh0+Q7bA6X
	 0Ux0k3d9vDmbjFc6/N+N3d+QLd+q55FN6bC82SdtMeCPmCGctbf56EW+V5kNom1xxm+Mh
	 WBn5PbZHkRdNIajguCiYFYJ29h3Ih5x5n6KigJt9VIbyieoslJ5xcy9Rz/nPCd/qspS8/
	 nrlFwE1uihMZfQyGEsJnRSXYYosh4xzEvcgH0sSoYF8Tkn7SjbIJDFFmlj80rEkOIjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqOl15xh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95723606A31C;
	Wed, 18 Nov 2026 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqOl15xh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9201F000C5;
	Wed, 18 Nov 2026 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036819;
	bh=c5WjR64t0pGVKSDufAsOH7hPkYzW4q9sXgDR5UoRbSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqOl15xh021g43SfcMbwvRebU8W2uGP+NYL6bWcwXVboBO45uaewpch5cK09ELG9g
	 AyW/96Vj4unPB+k+aAihrIVf/XnJ6+rcFXSkBMM9Tp1ORGayWPHXM9lw0bFwL6ER0F
	 gsh2NTb/lP0AeFvXF0+Moe1AoTt+kX5WeHLBl2QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1193/3318] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Wed, 18 Nov 2026 15:30:15 +0100
Message-ID: <20261118150355.959850512@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e3ef44e77b40e3cecfb34757ff3c15ecceea0309 ]

The Maple DMA and VBLANK handlers are registered with
&maple_unsupported_device as their dev_id. Passing NULL to free_irq()
cannot find either action, so the handlers remain registered and the
IRQ core warns.

Use the same cookie when freeing both handlers on the error paths.

Fixes: b3c69e248176 ("maple: more robust device detection.")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-By: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/maple/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index e05473c5c267f..d5e052e90ba48 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -863,10 +863,10 @@ static int __init maple_bus_init(void)
 	kmem_cache_destroy(maple_queue_cache);
 
 cleanup_bothirqs:
-	free_irq(HW_EVENT_VSYNC, 0);
+	free_irq(HW_EVENT_VSYNC, &maple_unsupported_device);
 
 cleanup_irq:
-	free_irq(HW_EVENT_MAPLE_DMA, 0);
+	free_irq(HW_EVENT_MAPLE_DMA, &maple_unsupported_device);
 
 cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
-- 
2.53.0



