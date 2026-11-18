Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052789;
	b=4275BXq9t6B6GMEMuEZUSviNgz5B5iVzy7hyXNLkCQg18g3vUML2quCfv76ENXrCn5cB
	 bR7T5YqiIQ55+bRDRVRRMMLPvV9gZBlZZ4KmbMzHjV+ANpiOO0bfELb+n0FxfDkfBO80I
	 d0AhBuxoCsgrR2LhSpl6FN73rf37GvRmtDzuqpeAC7XC1jkpbQDVPSZg7lQjTbU0Ndaxs
	 /WJN67Km2ow+tV6eEpaBynnaHadVXhgtsKbCy1pEzIHfZ5fw+eVn0RR9XUrG5uzasG04J
	 9EHQclb0Ajonyq6uhXXaavAlh+348uh1rbyrCc5ZoN5HJ56BoZ9phE3PXYd6EDwlUHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8gfuznA3hRGWnumoFstrcruBThSiWKroSSynffUpaQw=;
	b=wBCPsQLUoL4CJrbGzuK+JIJFRtVuqJL28VTSsYU5L1LoskODI9mxBDZHYtbTrtFk9/VR
	 0StgHBvDjOEnlWlmrys72motLOZRi7EH6cNUhP//ijc6pvTvvLby73oum4wLgE/eWs4QU
	 dWP9fLG660RDGonAMqhPGloqVFismDKp++j12vN1RAqgkj73LRuFk4/IMZmx/qaY//dWP
	 oP4t2fNnr5C1xEV0zZjwqf6V3RHaxSG0c5iAjMNWIJSOY9qxpusLIZC3CI4D2LagBDz8B
	 DGuiAZEuN3e0sy3P5ix9iJ57CeeLF4bVH7RWTIE3nrN3h1l7sW8nu/14zQCvksbSwFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8QGciVn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF4C606A32A;
	Thu, 19 Nov 2026 01:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8QGciVn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0391F000C4;
	Thu, 19 Nov 2026 01:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052789;
	bh=8gfuznA3hRGWnumoFstrcruBThSiWKroSSynffUpaQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8QGciVn/+hjI6hlKjBozE/e5xvPfZ0y5AL6EAjC7TPxqmSvwhFwQHW8XolHbRUVl
	 PLs2qWWqtKbK3fXh62CG3arrTofhJvMAU97PrkOYGQMnGkg0JiIN4JFKQzuKlMN8eI
	 0JMKkRLVWRj5kwJ81QWu6YfEN3ODGNPQL7y5O9vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0690/2214] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Wed, 18 Nov 2026 15:39:26 +0100
Message-ID: <20261118150039.330954931@linuxfoundation.org>
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
index e24e220e56eea..398043a4e8705 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -870,10 +870,10 @@ static int __init maple_bus_init(void)
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



