Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039924;
	b=hThY7Grb5mOMoY03lFQC0WgeomFGA22yUdG4ZXgulIY3CSboOH0bInafCGoEhFhTfhcm
	 4NB/Swy7uWumgCA+DAQu5Pf1P04QNgDmX5ezburXF4ZQCRPaV6Gt1Qw97blF6c8JlvMtd
	 7Y/YcAtaOIjXeaAjNFzv4ZEg2ze1RDPOiwDn+ywmcpvQLCDG2cR95F7l2PAsOf7Wv5l3B
	 CKwz71Zu0r7ZzAbRUzHAMiKN9z/1NoPghfT3gKLnpZjAz8uGwyxBgLNkJZKHUhz/zBuD7
	 OXEu/gtL4g1VepqYIbeP4xkw8xCBCDDVmPWGr7GZstYHnJN0tkxOcSZswVLdu/xFfrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LP25FyOvf+cWzNsBWXkiTYJ1E0SzLHea0zcSL5pZkU=;
	b=5lTQWqIV3r0AnJEOwhDWnlsu5LPHGcWEvxuYJZ9PAgSEe/2+h2fi/bqWm11+1H91Pvqv
	 iQxuqHgGkgpp5R4qWv/zosEjxPWBAjGmcQQVfMpVgoFm6EtOCmSmhZwzJUXClhoLyRht3
	 jkGLwzbhlh5fu9275rQWOw7mG1Z2BEup20l+DlgaLwhuO/kpGTXG9MMe0db40lCDpn3St
	 6qwiyT6ihcd6Y9M6y6NVNwRDsF8aAPEd/ihhGWSlnD3IZqYSPhrZyJ2qJJ7Odj6x0DNKx
	 urY8Isuq8SLuKoYO4o6lsqT6ZoQTVBkYhYSZnqujZ+hFzxhxTGJqpEupcR/0p+DT5fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjNL+09Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F498606A31C;
	Wed, 18 Nov 2026 22:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjNL+09Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F41F000C4;
	Wed, 18 Nov 2026 22:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039923;
	bh=9LP25FyOvf+cWzNsBWXkiTYJ1E0SzLHea0zcSL5pZkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjNL+09ZXQ93o0gXdXsRpnSJG0kfbWQ0slS3iK/t6RLovdhL1kN9k6iRwmf5y1Dsi
	 C+CJmPhwW82jRwC6rsHn5+XwlK09UWZsrvp6imjjC7daQy7DyTIjV1lPR+zycu8eyF
	 o3g1AahgqSeL95Pje9y0/+65wYcojhUaT9hKXgkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2232/3318] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:47:34 +0100
Message-ID: <20261118150428.831569852@linuxfoundation.org>
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

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 65a79b9b693d8c7bd7e5e4865c02cce922a7cc50 ]

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260901083452.115365-3-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 6de8064090ea1..6014bbf2aadeb 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -180,7 +180,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



