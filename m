Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036210;
	b=Lon1QEwJ1PScuUjs8HmqASXM9zNDDo8GN2Mfx3GM2podRhiJ2FWZEg5PS8fPFrJ6yx+N
	 7npftxKY5e7qwMLynfVKbvDqxlXAS9oWVGqVRZkmahqaO7Qs+AyEVz9P+MKRr/b7amwUZ
	 vtvHfMn7l0n1HczzXJQosPEbUt0OuIIUr34kMft7Fc+DShsFmFdrk93qxzlDajGC/Itl/
	 4sqx/lMBNMMSg3FtLUC9XlmGIpEaU4XmMl3SvNFNZw2nyBykfUO9PRDTXQ5sLNf4NQZAl
	 1rz9+r9CBhY4XeC+TxDB4dxdOntf8/LEmoUs49ZWiO3PyPwBgMu5gn064i9Dw0NP/mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSOCyDXNTn8XiJ5oSP0ZWCFBg+69YbAzDK0aJrs1Ee0=;
	b=anSvw0MwRbDT3e0Sjw3G0R7LPmo1j0o/n0f3Yk8XTln4HImnD65ixc2QYVqoLHHfQ0PS
	 n2wl4GCJRoeAg2R1ke5Ov69gXIXcfK/90KTCHzALV6lmMt7Bf99R2lEwoMjg1yb5U+6MT
	 jr7RR5luhdfaGyHxO9mGTiUDrAgz9jtU0cfKFkwRL6oD6WxDegFWBlMbhzO1dZPAGYpp2
	 Baj1veMXQht2ClivYCMhmNB0JXX1yYNugVx0f1796cOSGZKIQaTYLJX1/UYkSnx7CnjGp
	 MUEujtlbhB+lcUYnw9OMmaVcXr8f8qE9t1ShW2d1hEr4Df5DkadTMpGBl+V6XBr8Gaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIHriCgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1976606A334;
	Wed, 18 Nov 2026 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIHriCgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E171F000C4;
	Wed, 18 Nov 2026 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036209;
	bh=NSOCyDXNTn8XiJ5oSP0ZWCFBg+69YbAzDK0aJrs1Ee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIHriCgwxC2OXUgvmTENg8F/3nYHJMumGX4HZVklmvb4Moh22o3bzHCLPbjH64yhw
	 3mOVX1L4XLzS6LOITG41EW5dklOgMpMVFboV4yEg29TuAaypfOYGKPZlW9SUNiNVL/
	 M3ienukxvqB4ojwodEUHsaJOZfYxJ1IhgAudFiP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0979/3318] dm-writecache: report I/O error if flush failed
Date: Wed, 18 Nov 2026 15:26:41 +0100
Message-ID: <20261118150349.108927493@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 6a4279bfb1e77..2c462fbd83d4f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1492,10 +1492,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }
-- 
2.53.0



