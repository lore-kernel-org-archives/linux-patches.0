Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042061;
	b=qq0CcNrRFTD+KKvdTSC55CEFgp++IMvnkdoxyYLQbVeCtvkfAxZBKgoWhCRJpnP41tOv
	 V15w+SIKOywxV0RGRvIWdl/BieOIBtlFiSHsYDa7uc0gkHKQSX4f5MUQJ5+manEGwe8cx
	 PFh3pTwmCfHUMG2EEA2mvpJOEKggNZUSDLLuMe3J0dP3XRX7Kl7ICPL8DDG3nz5RbeQOG
	 fALrmBlc3TOutZQU6p6rujFVrGQfKE1wn7fs1X7jyBFeeXeB91jeykiF7hOuq9SKSpgiR
	 HhjglsTAd66Ut2bGYt2BY7nvyBUBqUFFlwZstw0BBJMVQABVfov5oYwYnUfvFs1Rtsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wxoty4/tgWby9JB2vFZNbS/YKkYzBGWnx8YaRm5eeqs=;
	b=Zgp1qlVgVOVBNxsWdYTB6A1RLtAyNeYIvBeDcINSE0bUHQ2ZiWwC/JBkuzhdJLzhVyCT
	 hJgt796+LVne71NiiwQEDVcjMWuAFoKqwS3pi5RUrvxcUm1aVuc21SEiLsfgWJUPhKzkg
	 lXdZcwNC3pt7nW5dntOOGROaexme+K9PVtRb3JgrvXdJesK0KboExM3XzOSwmAJq8xtI9
	 Z044rTLeZVt4mrCHFE45t1FFv+EvGsHLyhNWGbUSCYfk5nelYXy5FpgX6NxuN4Jd2ybcc
	 VdPcME7Xn9jBX+In/d8W8Q5CHvhMvyFUerehzAXl3XHyDxj5Xw5vCcfP0sOELOgzLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4cdCjuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863D606A320;
	Wed, 18 Nov 2026 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T4cdCjuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBD61F000C4;
	Wed, 18 Nov 2026 22:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042061;
	bh=Wxoty4/tgWby9JB2vFZNbS/YKkYzBGWnx8YaRm5eeqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4cdCjuCTIulxuwgYqdHsGCtOcOufKdInRbtxrnBD6UdMeAtHRjaGlq8wcJN37V1v
	 4U9UdkUZVbwWQa3AfB0hYaDU/8+Hu7w3BDXgGMxmGfBLeLELIW6xlFXQdAdkEpk9HB
	 d7zLN1tXnSH9LBrNQRJ2/3GonCY7jFi4m9HCDk0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3037/3318] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150451.284980898@linuxfoundation.org>
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



