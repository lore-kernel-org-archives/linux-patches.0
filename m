Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056705;
	b=H44qPiY6MHHV6VWshX7FoouLBvBtWj/GAXpart4zHWkI7cUc/1BMedKHOnSauirn7vI8
	 Si+aRvR+s83vIJA5xdqL9gh9M/JboRaLuIaIjFqiwcCApoN4IX0nqkQMbyXbHtDNlaw/7
	 4HESIvh4wAJxjOlnRQgYteF7TWJl6WdL67lJFejggfsCGqaWcoaTtHJvpFdRMqjh1qs6m
	 ET56jPIAoJHNnWKy8Mighq630BNHsbgUXIc0NEnrlcsjzICm/AmOgkHc4r8K6hudZhRV/
	 kFRojML83lYv1czFwhcVhSDnimXBiwWb9hKLu8zacNdKImCB11KmhAzTYG7jrlO/JsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=016JgtHhg+ChAEdpebGZaNngzkWw7yLJPmgf6PdY9is=;
	b=Ss+494sCXE7WkPnBidZZ8FNMXr2W8ysKQkr2Bo++pwTTlOO0vaBP75uI6UrXexKvomVi
	 npbiuZSVPQg/194UJCSPpOuH82I5YplT66xEZEwAPX6hMMQ1Rt52FUSXFBQH9PHGZioWy
	 BDdK1HybCYjPHn86BqHbqOYw/uRlHQhum7/QnMR3jFL9s5rWzf2+Wa7vIRauAEgH52/Ey
	 sl3bZpGPK/VqXRbpTBR0lsjNxZwv7yTPcRfeOinsVadJE3CcFNV4MaUk+xhDmlupC40RD
	 EnpO4yhse1izq5ilv1Z5941+Z/FTIYSj4sDtYPxv/WPaFnViWP+qrzvZ3BtiDE3CT0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iky5FU5A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45CB606A31C;
	Thu, 19 Nov 2026 02:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iky5FU5A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034981F000C4;
	Thu, 19 Nov 2026 02:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056705;
	bh=016JgtHhg+ChAEdpebGZaNngzkWw7yLJPmgf6PdY9is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iky5FU5AJ0du9atWx/c6wdI8KhijlS2yDIeoQ2J1xjQjy82WMhSingnx/zc+ZdsnT
	 7ffkZPl8Ow+v0mHLQunk0DvebNip1+bvXUEUNa/HG8abiNFClo0cXrEfqRhscv8U51
	 IpfrDSf52XZl/1s2pmRBXKBy1Ge6ZR2bBmVKVk8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2042/2214] RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()
Date: Wed, 18 Nov 2026 16:01:58 +0100
Message-ID: <20261118150132.407661451@linuxfoundation.org>
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



