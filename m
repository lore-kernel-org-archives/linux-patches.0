Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034668;
	b=EXUy5qI6IO2TvZx2ERiLOYAEnWk6LsJQidRkOQXeju5jR9NQ/TymobGWBf/sSwFYhzgY
	 b0jhbb2XhUdN/RFhD5g8EMRUgWKHL3GBmXTpZrKJS2ggzqJrDtABzG6LEofLrHS6FrAxv
	 T5EpdwiqoA8nEVqGZ8YOgfBWaxGxcl052wj4PYpbnfFFRiN0xcE7l133iQU4h2vsnULUR
	 VtdV5K/BKR/G8iUhAIU4H+qcNi3aRcapLkZLmbhyDG0vrpFwk26ceJRMz/Oy0Ftu48SWq
	 9P/1v2AaRo+R4fVbe1JVfmxVmVe6PhnMQmE84huZdyXGNYxxm6RY+TNQ/Pz98rw/0Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MQuo6vZtd2qFWpPE6OAua1Z4Iz7N0UiqAyY4UI2urcg=;
	b=hhwVT1yHwuO5rJCgB+6y06VUnD7j98k++DKujxrMh61dM/JuqEo3rbQxprtV4Qss9JuB
	 YO5lNuc2l5AmwobvfZkv36KDXYFwJ0JHJL9sqV9JeqUygzOec8QRUuwFZZ8kq02YBMg+4
	 5/PQip/LHfBoI7y5D6rm/bE5fx3wM0f/F9Yz3SksBbksnrDBxMBRV9TAP7OmTkijJbo3x
	 Aa+WiJNBGx+cEmVQJc2Thzrh74QRKXmpqR2KDksiz+ZtWLNVlJJbbyn3jkJe00VTQ9DNq
	 0G9mQk4UTcQVHBEzgmgHmhREACBeXi6MS329dwFAsN5XurUbiQQaZeQEjFZOxFhD+mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8wWGbla;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E90F606A31C;
	Wed, 18 Nov 2026 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8wWGbla
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F581F000C4;
	Wed, 18 Nov 2026 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034668;
	bh=MQuo6vZtd2qFWpPE6OAua1Z4Iz7N0UiqAyY4UI2urcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8wWGblaV/fZPiXITjPRTkzZdiNDewLonOC4Gwxd1biT/bSqBPbEDqG8UBmPajvEf
	 q//EEf7jCaOuwJRsal2Nv+/vKj1V/+I5nm0OgiFieXTt+eV+8ro5DltlZbZAk+EsAC
	 inv31ovAtfmLnMvwDVy8Gviu3sKbvo9SiWCj2fn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0451/3318] xfs: fix backwards mergeability logic in refcount scrubber
Date: Wed, 18 Nov 2026 15:17:53 +0100
Message-ID: <20261118150330.299579102@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit e8b01aaafffe6b852325debdf1ef4b13ccea1cd7 ]

When we start the refcount or rtrefcount btree scanners, prev_rec is
initialized to all zeroes.  This is done so that the record mergeability
checks skip the first record because you must have two records to
compare.  Unfortunately, I got the logic backwards, so scrub has never
complained about mergeable refcountbt records.  Fix this bug that LOLLM
noticed.

Cc: stable@vger.kernel.org # v6.4
Fixes: db0502b39c21d1 ("xfs: flag refcount btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Dropped the rtrefcount.c hunk because that file doesn't exist here; the refcount.c one-line fix applied unchanged apart from line offsets. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/refcount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 304ea1e1bfb08..dd2c52807e40b 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -399,7 +399,7 @@ xchk_refcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_domain != r2->rc_domain)
-- 
2.53.0



