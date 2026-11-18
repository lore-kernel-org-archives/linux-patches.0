Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061903;
	b=qN7ck3EwMyXvbKkx1Ux/GWcbnP3N5gR5W0N5EM+2Prsg1wCSVdTufQWGxPpceu5Gn0ZR
	 GfuoVrlZcXnXD+18iuf2W3DzStYPLWi1ZMIN7QHOg68zHdsu+5LcLDgxUz9cA7D5MUUZ5
	 uOfvqT6o6N/OBAr7jIVGjPR8M8cjZWU5Z6md6O7/zl+iwNp3omJWxk9RPoTZMHoTWJlf+
	 zL6QoX3SHbimNjnvO7CEO8jWvYev/tqqV/l+T9Z3iN417hJwt73B6Q+aPaUPTxxFpoI7l
	 caB9zaPoSLSTbibYqwBDwR5+mtWUrYnifG5d4TLzb4Xb8ZK+RWcmApOOTautMScoQow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sO0DbsmSdTLYvF9Q5QNXFDSfV5MSj3KRwADArsV31g=;
	b=x9D5VxQ5KBQVR33BvA/7x4SZ/qZcC7JvdfPyH9Od0I9FOY0ZhbqmhTSOBH0p6SgkSaMa
	 GtJk0CrnLXRsBP/GlloXJsFGBzAI27NBduRZxrwRi7ddsDgxsiCMYGaUKUksI0hS6zJDY
	 d42F4x/SLrD6ouRPmVAqV8ypRFc2UT0LRkfeCRYZw4SE7lNbUYsx0Au7sJtJ+R14Me+3R
	 8j8zKfrDBEnj0n5pY5D22iPSoqhTCOO2a+1si+HBAY2dZFofD7/Vpt2qvtIb2QYtVOyha
	 yJh+4uO23i84zPk9dsqzlqPWjCm4O2cBIj3rngH6GUGyf0csxrs8QMyAsXfWakViF5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSQC3CgN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359B8606A320;
	Thu, 19 Nov 2026 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSQC3CgN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8B71F000C4;
	Thu, 19 Nov 2026 04:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061903;
	bh=7sO0DbsmSdTLYvF9Q5QNXFDSfV5MSj3KRwADArsV31g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSQC3CgNzVbdz/jmIsnFt8nV/r16jQl3nH/Hd1tx9zQC48Mk1eKTkSOdzViJ6h9s2
	 qBr7OoX4iHUCSopQCeX/v0es9V1wpKrL2kWmkdB6JDZOd8tjpIhesD52jQZYcDfSjI
	 EokHQkcZM/CrcGl6jaNkHWN3A8Taby9JHk27Ngos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1718/1848] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 16:02:36 +0100
Message-ID: <20261118150031.578177496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e5a3f02fb0789..f2ad0cdba3ce2 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -77,7 +77,7 @@ static ssize_t flowinfo_read(struct file *f, char __user *data,
 
 	qp_flow = f->private_data;
 	ptr = buf;
-	left = count;
+	left = sizeof(buf);
 
 	if (*ppos > 0)
 		return 0;
-- 
2.53.0



