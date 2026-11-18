Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027956;
	b=Ma4N+S6Zw8PAWIBqTtLz1QnOlYRiGjJt8ulac/pma59/ZoNL6z1m5Yqbv0ObznHLuw5c
	 Ujln/1DgFVVTPOUCDIbV5mN5SA+fwLlfYloz9t6aR3JW6Wclm7NW1I8L2aegxY1XmGwbD
	 TZKUOda9psJTCHdbY+ddIdRBUnTZFXU3PmkLILfXuw0s8pGC+k795JmEj8eJlUglYw/SU
	 /EYITVkCDvcJmjfap9xx63nnXJ/gCbuK4ejYNxKfUmBAKUhA99eAkEiD77WPy6TEjdxQv
	 UEj2yab5UcDmwA2zMoYgr6H/KQsQmR881fLkqMfV/EaUWmw3Z8k5MKZi1pl2+72rcfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FEkXMsY8aKdCOtqEXQgWHi4DW6acgXpcpU5Tqlc1sTM=;
	b=y8aq8vUCpSvaBHfQFh8nbHCg1YMhHaJGw8bH/nktcnD7BHmbJbVFG2WtfGK0SIwARuh1
	 renK0SW1fGcrPYNU1d/9bSt8Up+bb4B+My3B8fSv5GZsYyxoisF7YxCvM3EJKvyREg6tK
	 6LEjqvqfe/doJfoZM1qZDwSbpK6BpCkQ8B/PdQp1OXY+qXjQhafaiOFhrBtVLGNiHCgjV
	 3Fjcjlq89SpNXCNfYaDctT4gFZpN+CSxzRpHWZ9hDvjh0o8RnKE2jIYVmLsiLMEUG/3nY
	 Gimz42+xq8EDkeLttrJlrJIt2gDWLIRpUKAgXb5exGU9f5R02YHq6eGHEmgBivN2Tww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0VZoTzEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F67606A31C;
	Wed, 18 Nov 2026 18:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0VZoTzEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8798C1F000C4;
	Wed, 18 Nov 2026 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027956;
	bh=FEkXMsY8aKdCOtqEXQgWHi4DW6acgXpcpU5Tqlc1sTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VZoTzEGN7NjgcRgN08SUP/Pcz1raGCtsSF+22KskDcSD9tR4NVzJAN4QXteOnBJY
	 3bbA3Yysw2DSq40LdSxyra7W0irQiYMlW0XVeghAENt+PV1eVwu9o0dmiwV9UxwBMM
	 9wyl0uqkd52m4RPn7s40nvlj8DbjXDL3hK8CpTEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1956/2151] ceph: dont clear write_congested when collecting folios
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150233.015208529@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 77ff2ba4630b9e9e9f73bbaaeb675638b2c20dd0 ]

ceph_process_folio_batch() assigns the result of
is_write_congestion_happened() to fsc->write_congested for every folio
it collects. The code it replaced only ever set write_congested to true
here, leaving the decrement paths to clear it once writeback_count
drops below CONGESTION_OFF_THRESH. The unconditional assignment means
that a sync writeback that runs while the count sits between the off and
on thresholds clears the flag on its first folio, and background
writeback resumes early.

Only set the flag here, as before.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Assisted-by: Claude:fable-5.1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 9e123f8e72720..ae34998bf16fc 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1421,7 +1421,8 @@ int ceph_process_folio_batch(struct address_space *mapping,
 			break;
 		}
 
-		fsc->write_congested = is_write_congestion_happened(fsc);
+		if (is_write_congestion_happened(fsc))
+			fsc->write_congested = true;
 
 		ceph_wbc->fbatch.folios[i] = NULL;
 		ceph_wbc->len += folio_size(folio);
-- 
2.53.0



