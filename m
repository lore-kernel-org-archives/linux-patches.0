Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027358;
	b=MpJjON0+OPknaWofYtjmfFHonS2RpEvw2L6P/eh5Jl5C1NpRBuJKnJ4nRAPfBTowwX9O
	 sgBXuyyM6QLfYlrcEJxxdBgNyojmwCNI1ozWJsCXIXiFPUG5zuVyEjQntBCngfU2otJAD
	 QWlmxCQFUvFpq78nMNSntOj+JRRacM2fBCm6P1KMaJzu7lJGG3oGsAQ2Shq79LpPuCH3k
	 l50i5OvYfZyUkgbgskmt51knI6d6RhLAAXNAU/IfjSmQv9if/zKMhEJu7KjQY3IycD60s
	 H1zY1tVB8aUMtm6P1xcuj+No6QGi5d2m+D5dfq+DGm2X/bRW0g+p4U3n9WuXnggEXDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTgofsyfQK4UMESvlIY4BFc2DGnQ6UyMeUqnLldB8V8=;
	b=OWq6b1yJL1HBrZO0EqnbahSwOCQJPxuoREH+mOWDf275Gf4q/BT2ONaSI/JNxJj5ogGB
	 xvUc9bLbgt6hI5YxF2oQgvsf/EJiyQGFMS/OSoBgBts2fSRodSXU8pdF47mqOk4c2qLXj
	 UEZmcETK8E20/HdM0Xmwb5Cey9f312+/wA8mHu/7sxC3QsZxuvHgaGyV3Dylt0WNxwAyk
	 OMU7Midv6SFkyt6mwnhcHG4wQFo0mC/9ZDBjdgM5TGyVGV8EjOsMH1YaufUfMEhCemONZ
	 hbUqg5wGZXZFN5xdsTPHggqZ5td0i5qr7/UzAnzn4RZZYr9hKWhBHWbLN+rtx6r2Jsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbPvAVz9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C26606A33D;
	Wed, 18 Nov 2026 18:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FbPvAVz9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA8C1F000C4;
	Wed, 18 Nov 2026 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027358;
	bh=QTgofsyfQK4UMESvlIY4BFc2DGnQ6UyMeUqnLldB8V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbPvAVz9CEdRnst8Qd3w2h5jI5isFepI5f4epyR9Nkd+EWeASYP9NzO1CmC0kzF0N
	 bWy4vKTkqT7UbDI+KrlpUAx6JcWGvq/Wh2SrmIuK2IrYYL0GQen0OP8KrZIeBqgaKD
	 xocp85Ql1C/l4NFK6tYC4o6P0AAGCKd1pD6NW/N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1761/2151] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150225.991311694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 9dd8b9a337af844291edcd9139c927d0f7958dbe ]

In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
stack buffer 'buf', but it is initialized to 'count'.

Initialize 'left' to sizeof(buf) instead of 'count'.

Fixes: 9f637f793602 ("IB/usnic: Expose flows via debugfs")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261017185028.1019445-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 10a8cd5ba076e..ece7c6e714997 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t flowinfo_read(struct file *f, char __user *data,
 
 	qp_flow = f->private_data;
 	ptr = buf;
-	left = count;
+	left = sizeof(buf);
 
 	if (*ppos > 0)
 		return 0;
-- 
2.53.0



