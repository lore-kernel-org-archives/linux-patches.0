Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619116;
	b=smdqNduSHcYc3xY7WYFxM64BVqsEx2gAP7FZIhz84mj6CayOIOBHsNTQFqOqM05onBSY
	 fWT5holOJr8TfJkxKdUF/dbQWOziO5t+U5UHvyY+eRncnbh45Xy1rvaUr0V00PzsCQTQO
	 ypLLaUOERJ2Q/+21UThmFWSmjh//rORGCHHDXJQlsFDGQshUDSWh8um9BUYTOlrAbilnW
	 HHheLu8YHYpT/iqXpi2wOTPzX4ZzOYl3K0y+I4KJ0WH0qekPlNMYHY8HGExvTCFUUyU/x
	 FoN0vPWpyVrhxtsbNJMTkr7YmvwBKGYRf3dMeWmMqIHsi0NVJB2r5bRGolCFh8u2JkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JuCAiGiP6ch73ajTEFd3MClrq9aQxxIbvItwKrRw9zM=;
	b=LoTpFaVanfYPovBknT6kK/Vr0fbJzni0nkdK51TMAYTLvPEaeOB9of5hTQ+ZSVUkUEea
	 pke0WjGngkfSz53bcbWoUJWYRKaxw6iYMflvkomIDY5b4fF65b/V6OUlSFTbqbYceiQjM
	 aW9Ja4GgmlIzWuLm44vGm0Gi/QZQeyQI8oY+1sTvetEGonfVuu/hdF51OZMzErC41Y5xk
	 jZHjM5inm4MgagmaoO0KXvUbKVul+1xdBlbEemeX22f5gZ2IrS85axlqyJ4njOLhHPU3d
	 g0T/tV/6/PT37gw81x3tzjnZsVQoueHOmXXYUi0hz80YFALHiKeCjiU87sv7TQjXgNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHcnpggi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFA7606A31E;
	Wed, 25 Nov 2026 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHcnpggi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59941F000D0;
	Wed, 25 Nov 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619116;
	bh=JuCAiGiP6ch73ajTEFd3MClrq9aQxxIbvItwKrRw9zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHcnpggiHkR3b6k7ItQc6fx+YIuGbfLTdQKp0PiotJDFKL3gdT9BNC9Mg6WkF5D6X
	 gR4Aw3u/X7N3ANahXcBHk7aFQw0PJcj+q4/ESGMXrX0ay0B7ZEVY01/eEdY6GS9U2W
	 TZneYaXA5mdE6vvX/pDwBtwbbZ1Ydn8iahcHOPXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Petr Oros <poros@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0493/1005] dpll: notify about a reference sync pair only if it was added
Date: Wed, 25 Nov 2026 15:30:31 +0100
Message-ID: <20261125143833.294242606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7a3837929d049dac1f931620f30b100993ce2594 ]

dpll_pin_ref_sync_pair_add() sends a pin change notification even when
xa_insert() fails and nothing has changed. zl3073x gets -EBUSY when
another channel has already added the same pair and ignores it, so user
space is notified about a change that did not happen.

Send the notification only after a successful insert.

Found by code review. Reproduced on a ZL30732A board with kprobes on
dpll_pin_ref_sync_pair_add() and __dpll_pin_change_ntf(): loading the
driver adds one pair twice and the add failing with -EBUSY sends a
notification. With this patch it does not, and the successful add still
does. A test module adding one pair twice shows the same on the monitor
group.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Petr Oros <poros@redhat.com>
Link: https://patch.msgid.link/20261105131145.1010406-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 8389983f42569..277692d12d3d1 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -1081,7 +1081,8 @@ int dpll_pin_ref_sync_pair_add(struct dpll_pin *pin,
 	mutex_lock(&dpll_lock);
 	ret = xa_insert(&pin->ref_sync_pins, ref_sync_pin->id,
 			ref_sync_pin, GFP_KERNEL);
-	__dpll_pin_change_ntf(pin);
+	if (!ret)
+		__dpll_pin_change_ntf(pin);
 	mutex_unlock(&dpll_lock);
 
 	return ret;
-- 
2.53.0



