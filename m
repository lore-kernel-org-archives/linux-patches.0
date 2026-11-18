Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016524;
	b=ipe3l7smIKUF7LR0lWHRfFJIQUNa8MJHBS+rqAJcCfzog0ocFfay2V4IAh31JFKN0zdF
	 ASAvyZVIcqI88bfU1uYfTOmLYKjj2kbm10Z2mcLaJ8ivKRmuEgUNE5WSAMCiN2S/+PwRk
	 A59i01ip/EdZSmastuLRHCBzhtbmyn2LziEf4buMUKf8e8/h1jX+NPHWKY8QSZN+gkMh1
	 Hw4tCZMLYK+PDHHj5Zj4qtW2GMtVyI3S2aDvIjs4CzUQHV/GAuuXagQffuJ9YfMABDIyE
	 GYxkGbaiNiFLaIieNa16iRotgCYDQL9V8PD7SVSO/jt1SzCvEPEYEY+qs6sT+Q/mT1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pF7tDTbiY8gq/wgTFyfxsd9xs/kI/NWyXTPiLB43ewM=;
	b=g1ChyZEHiYXDo+NhhB2DR8s4XM17FXlJVG6DmHYFib19n8z63Ie34IXwpqx0bYS4imr0
	 YeqF3kAUV+LHYs0f7AzH1ePXRZiwMpuh9CzuRvHgvWIl3NzEzuLNRvf65J1t/URUMkFQ2
	 bGubR+DK4Fv2/yQhYtfhryWQZMrjgiwh1gU9nAlaGNG/K5gezlOcHXZQ2RsURMUkRc8eQ
	 tDRRDw+eP73USQ87tsF+fo4EA8NTTO52Ti7fWZKqKuODnnFzxqryRqLEpj7FBzljwi/tI
	 mFH3RxahAg97DC3Q+cXlwlDvXUrfQqkZ511AiRHDqjKngiSqUXqrzJe/XiIL24fNc0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTdHqIcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C6606A31C;
	Wed, 18 Nov 2026 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JTdHqIcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE511F000C4;
	Wed, 18 Nov 2026 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016524;
	bh=pF7tDTbiY8gq/wgTFyfxsd9xs/kI/NWyXTPiLB43ewM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTdHqIcn5GgHalzWNcM63ucVouobDWfocj1h1qGEhMQar8ISAS6QaArhbJBUaUk3n
	 u+yd79enHjmUM33RqpIoTvMBpTIj40sQB9LJBvTmhpf34WKs+FGcJCqNMTF76roH8T
	 tWRixLysEtI42f1MdA5eQHlPePJ/tRcTdM+a9txQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0557/2651] rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
Date: Wed, 18 Nov 2026 15:29:57 +0100
Message-ID: <20261118150307.796226356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 19bb42672baf8..b6cfee4e50399 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1332,9 +1332,8 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
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



