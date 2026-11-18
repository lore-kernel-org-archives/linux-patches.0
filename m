Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060338;
	b=aCkTidtsVoc4937o3PQC/9cTW8lDtwoRxsZu9sXk/Y4czbln8gtpCtlUgM0zO3phBbsg
	 VbTat4JLzI3Y2iiRdXqNuVGnQFO/RVnlH+Ribnob8WHWztWnK0Kpa4DcwjNj7Zb4kyGWk
	 iS2CiUeWaAti5oSWbt+rDiZwoyQnOJsxxbk+PHP8xBF2l93ADtVyXBVGdNKKUMAuMSTOg
	 25hCU7mBGThyOWcy+vv8Gw5kBPi91iT2Z645G0Ct7shS08nUW6ubXAAyRoZUzTp3w4A9u
	 SNWe64xZMva41EsEd08UceV3Ox2udY9zSQaFIvr1PnpQ1uA2TE5kNKw8O2/mCRSQVeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2gV+gaNIF/qUmBZt1DcQ+f0r5rxTHHkQPBWMmayXMgw=;
	b=yzXq2xcHnqmy6hGnCQZd9dsSeXD7jTs4FPKQNbymjEva5Vb7vYXur8kx1B7ePEUXMSXq
	 exfFSDInNeT6LAax4AGb8xtlmC0Z/zYpnr202VfrUoflgxlETNESgDPgqW6/PUo/EGbSd
	 JWCblrXHH3aMFQFXmYZzUJO8ZV2B8er7G/ECUYp0hj7fIR3O3emIZv8B/9nl4R3nTZqH7
	 TqfgwbAzHdMcQwJKPfKYVI5g8gvIgyu6JhGuPLIa7mLVHbKnT8NcrYxZf9R2GRr6b2dTW
	 mCVxvewPiQQ2IVyEH5cpoyHorp25NO4xNcNGafuwrra/Vdq1yOXNuoB1whSAbkAbYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCXN21v4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B8606A320;
	Thu, 19 Nov 2026 03:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCXN21v4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2131F000C5;
	Thu, 19 Nov 2026 03:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060337;
	bh=2gV+gaNIF/qUmBZt1DcQ+f0r5rxTHHkQPBWMmayXMgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCXN21v4lE4J0eL/gIXstJ4b8vRmnVwjgHGcplzROkHN54Q0bdSrF8qaI7njdDIh6
	 aXm89dH2k3nds0BoK7ddj/TLOEOq1/gMIs46PhHSZoPIWv4XggI+Eqs5VYRkhWMpNl
	 tiL62BS5Pmn2LKEkqcUXogBaRULGHH76kNOeMZxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1164/1848] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150008.402829285@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 25f3f2ff88ae604a3b473b501fc55d58fcb0f5eb ]

The two scnprintf arguments for fq_overlimit and fq_overmemory are in the
wrong order, which results in the aqm debugfs file showing the overmemory
count under the fq_overlimit label and vice versa.

Fixes: 2a4e675d887b ("mac80211: Export fq memory limit information in debugfs")
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Link: https://patch.msgid.link/20260904090626.92727-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index de5cd3818690c..be0754459f90a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -98,8 +98,8 @@ static ssize_t aqm_read(struct file *file,
 			"RW fq_quantum %u\n",
 			fq->flows_cnt,
 			fq->backlog,
-			fq->overmemory,
 			fq->overlimit,
+			fq->overmemory,
 			fq->collisions,
 			fq->memory_usage,
 			fq->memory_limit,
-- 
2.53.0



