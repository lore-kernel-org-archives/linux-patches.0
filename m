Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023824;
	b=pEktdY2RAHuVk78k1a1mTqFF07Lo/tYkh53UBEbear5ds+9sV9KSBkIt57qN28TLTvc/
	 DwHOFfIVb4Oj+8KcUEnzvazLM05YQ3e4jMJeNMQmUhhKo9wFheCOIOhn5IjnYwVl+r1WQ
	 yQxrx3bNfKeYhWc4LKkWnVF2p219nFbg/DaUi5FmU3pF1Nv2XSklR2hY2QfAvFC6iwLrh
	 EoYj7WfAtvJpofs6WD1D3LdylMnA80oXgt9cRw5/Qd9mEsnBlIx4rwuAQkOkxpD0hbAa5
	 BrwyWzXv/Y6iFx3Uxy/dJnDM7UxZoL7T9ZfEGumyogWmxBiknmMykhGCZUlnMf++2rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ywwwBgjaeExOtx0B/u6dfHD3LMRvDcf/JmJtjt+o2c=;
	b=DkHtM0u21c7S26coPltXM/sNG13Ez8N2LdqfVHVndBsWutV2IwXmlmI/jQatvYrRNLcW
	 6x/BHyJrfyPBlpbq+LXMjkrDCa8J+C9QfUVD7XDG4w+a29TcjGOG6GpegGYidx28IKU/R
	 U3gFl4xJfIcrDpLL6xtbDyY/jQhJ7ddo1K/xMApG5qKgKRJSK/CbTsdLlwK99FcX/djfM
	 VsEzH+4qNmTzEZwTq0K28Kce93BRMUM4mOs/Y59+oc5NipMIvoomE8ny2vObM0uTUAlSE
	 rAwcalzPRGeGNXGZeeYePlg7gssZBMsM5OyBhpo3BV/8mZzP4NyJqmj/HHXB7mMGLSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aXjkVeWd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C12B606A331;
	Wed, 18 Nov 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aXjkVeWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AF01F000C4;
	Wed, 18 Nov 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023824;
	bh=+ywwwBgjaeExOtx0B/u6dfHD3LMRvDcf/JmJtjt+o2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXjkVeWdIdpreSsRDRMs8OIaplzL2d043nZ1DIepghX0fCKhE3resxk+R+bBgEL64
	 SBrzB4zfW3l6F3hrKZFzwQyTZKlku8l6y0SJdSEA3H/1Y4uop3F0IzkhtuUo7sjwgf
	 GAu0AcJTvOhc3yeHQzlljnHUa3uaUVX+3G79Z3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0506/2151] rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150140.482173637@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 4c714f015d9ecc37d7a330b31822ccbcaff5ddc9 ]

The lazy RCU shrinker decremented sc->nr_to_scan (unsigned long)
and then tested the result with <= 0.  When a single CPU's lazy
callback count exceeds the remaining budget, the subtraction wraps
to a large positive value and the <= 0 comparison, which is
equivalent to == 0 for an unsigned type, never fires again.  The
scan loop then iterates through every nocb CPU instead of honouring
the reclaim budget.

Accumulate into count and stop once count >= nr_to_scan.

Fixes: c945b4da7a448 ("rcu: Shrinker for lazy rcu")
Assisted-by: Zcode:GLM-5.2
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index f525e4f7985b7..140092b686467 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1256,9 +1256,8 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		rcu_nocb_try_flush_bypass(rdp, jiffies);
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		wake_nocb_gp(rdp);
-		sc->nr_to_scan -= _count;
 		count += _count;
-		if (sc->nr_to_scan <= 0)
+		if (count >= sc->nr_to_scan)
 			break;
 	}
 
-- 
2.53.0



