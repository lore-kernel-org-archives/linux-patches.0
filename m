Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062561;
	b=dxjFXKOJ4RKEvhNvSQSEz9Cbo00mvDFO12tqQbEJxZFsJX3fjBl6YwvxqYDFwFfvhpWv
	 ZRDLZemekGya3zx0eGvFGILNidPqnEJm5Kwui32Xiw27Fo4ySWNNiIIjuOO57vg/WMEgV
	 5CBqM1z8VMrTLMfdDr73h7BmXdcKCxBPAoFJD8p/qUT/O2Q0eXfZA/c3ZE1PQhZh+7Oje
	 sm4Y9/uIJ1qO/w/nPj7B/t88lB4YJzVJ0CeT6kE0/FpTz/YqQ7nOLtKmJDGKLie+YskpK
	 r+54yLeeVvRLLj8Wyw3b68Sqr9FDmROHWPh1ERqZp18o4v7APGXJpi+syFi3wmneB+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vpfREyNDvdkqCDYf/Rx4qmhaHMH5i1LbQh/IwxtLe0s=;
	b=sCEuINioAC1jqWP8s5uk7ydlf5M0aR8MTjbihU3rlYpaBg5Lf/kAw5dlRVP2nqM40hEl
	 LVTqtHkmGTv/HQ7YNYdqyLxyTG9OZzlNq+Hh1JasRnkpFKofoIrPlyzEQ+f5iLER1qbtB
	 VzM8RgHVG+zSDW2PJdX5TN0TOv+dGY3SypmKwdTvQDzsdtsO50RYIpslnash/I2jtfAaH
	 NJCmwD8C3nmPPdhnMjxW8BZcNlOBMiWa+vmfHpAQ7XkPRZkNQoGp+AK8DzDYNmjNybZ1p
	 qB01G7rtH9HfO/v+CRFZ7i3Xf9v6veteKgTd6P20aNItbT1ycFEE58f86ovSfjQo1wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPwDSlgP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA8606A333;
	Sat,  7 Nov 2026 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPwDSlgP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EF11F008BE;
	Sat,  7 Nov 2026 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062561;
	bh=vpfREyNDvdkqCDYf/Rx4qmhaHMH5i1LbQh/IwxtLe0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPwDSlgPujvORoCxyZaaxH4mm+D12tFgD9r+P6ICphK/Iw0Ml7YxWm0yW0E+m6OT9
	 D6+yYxvagmIVrzss3w9i6IOEgdw3eWPyZukbgpvWYIgwPqATnhc6eJgyWu/f1Xocf+
	 3nU0gUwQZOAiVGqXPh+qRNMjqcHqfz2U8yd+Sgm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1407/1536] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Sat,  7 Nov 2026 08:57:03 -0500
Message-ID: <20261107135037.341635786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 6dc0549f79005..3d3302c900caf 100644
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



