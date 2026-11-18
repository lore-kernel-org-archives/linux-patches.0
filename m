Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050191;
	b=tHbzNolWjKhMYJ4t1xrDWFCOSSP1yXBB329DmeJmWSv33fZHxUQ5v19lBAVYKhoFisHw
	 oBbMfBhxZV7ceRaBD7aWNApaW1S+FuKbiTf7nYML1+5HFtOhdspEvWsJJi98uFhGiuvfv
	 kEq/emvhgsh4gBnPjo07Ga1uUuT3nxZUe5SpMA9ZJDKrBpc5o8sbUVxsf0sF90KsZNyUR
	 kWjx8ccVwsvvYTCvrzC98XK0ur2qQbV5GgIdlhfNumfszF3E5OUcZIIqG1dtv4A1hyR5t
	 Uz6E2Mn55QN0PPP6g29uJ/RuGARY5zGe1zvbjB8Dclv7IDDOjFLwjI4LKLMadt7MnTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PHoscyjE+1Oa1oRxVumxa5R9LvkluhJaeKKbp8WQz/I=;
	b=uL/FNwD7wCxsty4xsoBzfOl8TKz7E9ddgvHrmLNlv2XHB9ATyNNhRqINJn30Tor5LRu5
	 A7/d8x/pVhV9ybopE93gnyyNO9RZ4mUBUURxjTHOOYJOW38UI0tnCVucnSHHbvpvCF7vl
	 rWyIE1fZOFvvvAaTPyo2Av9d8myHPFyRpPrdmGFbXWYes6JgGlEr2sIE3x9GUH1Zv6fPD
	 jSQnk6vDwVWoWeLGzh4tXMse6qZppCW5wiQnb4KJiWaDjNHKR/yh/dGcWElI6ecFotbER
	 kV38lyOauOJiX2zs6ibeyZUE/ZMNDy9/96ZfY/QwBnhCAcJ2JsepDs15l/XceLmgsvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U4kV/n2c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84AD606A31C;
	Thu, 19 Nov 2026 01:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4kV/n2c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B341F000C4;
	Thu, 19 Nov 2026 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050191;
	bh=PHoscyjE+1Oa1oRxVumxa5R9LvkluhJaeKKbp8WQz/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4kV/n2cJD5ih5eIv4NX6Jpebg7gmsgIlVfwd7wvg+e6BwOV1B7+Ks7pqCpPRTJ4g
	 sFRs+UMcFadxjNNYhiOPsjmc+z78HmLNt+cLn9ATSDjsZQYjhQT/cNUOGt11/u9iVP
	 cOQKMeU7BFTkv6eYeC6ZmYJhQpuPwMFo9IsceWdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2618/2857] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 16:00:52 +0100
Message-ID: <20261118150335.840147851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



