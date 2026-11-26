Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705576;
	b=Cq7NUGXYQGXm1GwhEVhe0FwChusqRvYrxs0ehf8vwci3ayPU2LLmGd2BL4bNYUfBjGAh
	 8NoI8s63Ti7kZGlUkWqBGDNK2yFJvm1gAppIOQhLqQf3QBk51WVY9NV6QmDPnahVPjrmj
	 4NxfOqVwJK5zUX5R1tWr+ESUZt2a84A5O6aOjZMaoHyfxEZARnqq/7S10xumJbQwVB9EI
	 jyo852QIpPSWZJEOzsUAGU2Ybg5+R4+40+YaXwHjTd4AS9V88igP2nI3u60yHOharkyoC
	 kEkS8g/BRzY8eZknxGW46Ppy+sXUr+da9VTqadwi1zGCpLQMoPtc0DdabMFXMDtzErQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wPG+6yrPb3yAQI/CLaII7PGkR6DSnSaZTgphGHjGpkk=;
	b=jQKgtzcuUH2Ku95/jLCAsiQqvih61zY6v6Q3HVrEfkv80GVMQXA8OM8Op171wpVJL3MR
	 yaxsyyJX32k+09d2hD2LOPGvSILVxSA4p1dJWuvdkWQUFW3YjKs2sK+lk39Sgz3WSk6JK
	 B+oCmXsNhmrpkrediAtvcLb4ZZWVLMVgiVffmWNl2rFmsbEeer1/1KC8HFnix6+vRM6SN
	 NM9QNs81WaA9uHvkcZ12jafaVcVrlrO7a8oSwDwlLV4TyPsffEY6VFjKoh/6EY66pyCDj
	 1n/CZCYa8gpYhAIFzMgKe+5BTHouJGVTkjmt4JoBUTjfPlK73bChHwehLggDfK08+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2kSyNxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179EE606A33C;
	Thu, 26 Nov 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v2kSyNxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA4D1F000C6;
	Thu, 26 Nov 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705575;
	bh=wPG+6yrPb3yAQI/CLaII7PGkR6DSnSaZTgphGHjGpkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2kSyNxzn6nNWtpat11shpeOy4hc5lqIQBYJ2ggznvyfn1megz4X9vG3HEFhcxCRX
	 mSlAV3Jhdo+nPEg0/eGFmLTL2rjIy8UZOf1OKDnBSu2R/+Ab8Q8fotou1T0fjZoKZ9
	 6rAiMPIBk/uEd0lx7G4a4CAPHAeGujGcGtC78j0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 244/319] dm mpath: cap queue_if_no_path_timeout_secs
Date: Thu, 26 Nov 2026 15:40:12 +0100
Message-ID: <20261126144012.251958885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

commit ae5b40accbc06f93e6a513e0e9a07fd32b197e49 upstream.

enable_nopath_timeout() arms the no-path timer with
jiffies + queue_if_no_path_timeout_secs * HZ. The module parameter is an
unbounded unsigned long, so the delay can exceed what mod_timer()
handles: a delay above LONG_MAX is treated as already expired, and
values above ULONG_MAX / HZ also wrap in the multiplication. The timer
then clears queue_if_no_path right away, and I/O queued after the last
path fails gets -EIO instead of waiting for the configured time.

On x86-64 with HZ=1000, 9223372036854776 seconds failed a write after
124 ms while one second less remained queued throughout a 4.2-second
observation window. A value of 18446744073709552 seconds wrapped to 384
jiffies and failed the write after 455 ms. On 32-bit kernels with
HZ=1000 the delay passes LONG_MAX above 2147483 seconds, a little under
25 days.

Cap the seconds value at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET before multiplying by HZ. This prevents signed-delta
overflow and multiplication wrap. The timer wheel's existing handling
of very long delays is unchanged.

Fixes: be240ff5e402 ("dm mpath: Add timeout mechanism for queue_if_no_path")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -792,7 +792,8 @@ static void queue_if_no_path_timeout_wor
 static void enable_nopath_timeout(struct multipath *m)
 {
 	unsigned long queue_if_no_path_timeout =
-		READ_ONCE(queue_if_no_path_timeout_secs) * HZ;
+		min_t(unsigned long, READ_ONCE(queue_if_no_path_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	lockdep_assert_held(&m->lock);
 


