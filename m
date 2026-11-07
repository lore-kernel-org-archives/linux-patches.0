Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060742;
	b=eOTg6AuhIB8gdW3E8zaKrZIxTEel3Ix65tAvLES0M4FbTHKAb4cEZyaZKFpb2qhVRglW
	 nF+SyxSwGYovMALu4BJSqdp+dzdEp1gF0q7VxJLRQWUqVQ7nBUK7fn2jywr6oEk1TtfqC
	 NUgHw3G3utlkbNkDSJ4w90No1WdisbgyaqF+CHQq1Deto3ecAuSu3YAMt30LqtBzoBU+W
	 DOe/jqjeYZzcyL5HkPz3UPyqdzI26rllGK/sPS9x2DQX3oL/7mEcJ2zrGbmhes1g8XVxY
	 NDvoUOYJEjFAX0B/tJU+eN/ePmgen7tpYNRYhRVWInCEwVE+cgnT3Hy5rLqqdG2cLqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5jmJKsoPiP2O8F+g0cs/4M7zjVThPOx0GPe6wPKDu34=;
	b=utt7EHFNh4a3eJqFJfGf22OUsdK9/ddg1tMPnyu8XSERoLehgh57vOlGjRIMcgG24KUV
	 h8bDHa3TJXvEYYpmATxwk9Nav53vAtFlIlkHvZsof19tGPCIJ74d0M6m91RsvOGjlk3w2
	 4onmjNFJpnaCVjSTT/wrcAOqNMhSPai9d47YhL/U3Y/d9D7uNEx8s4HiY3tSAprpUp59A
	 g3vxT5zsodOh4iqWefy+L1uxSUbmMQbSr5ZZ2ATnfc3VxGlkNw2f3xbheR1pNPyGrpW2s
	 eBc6xKzazZ25/2H0hg73g+KM6zOrp6qWLCYdQG1VVGBhlouDE7H/rNcR8SyCT4hph5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIaKt0gC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87BB606A326;
	Sat,  7 Nov 2026 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIaKt0gC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A251F0089F;
	Sat,  7 Nov 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060741;
	bh=5jmJKsoPiP2O8F+g0cs/4M7zjVThPOx0GPe6wPKDu34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIaKt0gCHZiEgzFrdLXsipXwcGyc7Wab3ZzqmY5MYKf5PHxx/KwbOlW0BN6RK0OQ6
	 V0CEXMp1SIsdEuTsLCXq9jE5hjgohDnb+hMfBCyoG2/U2674L7MP6IPThBj0P9BPzS
	 OC1KrMPYcYGL5ZWaWI9q4rL/P3e58VpJEudLa2a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0157/1536] misc: hpilo: validate device queue entries before use
Date: Sat,  7 Nov 2026 08:36:13 -0500
Message-ID: <20261107135002.087135466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 04bd34c8c5069..9368edf8c4a32 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -160,11 +160,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0



