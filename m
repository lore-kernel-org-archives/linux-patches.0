Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054746;
	b=4pKlBXpOnTZY3m157yDuznG0pz2wWFSykcDjLryOxpiBS3bo5QjxudM0Meks0llRLXOr
	 xgqzvZ+RYPwqich4WkeZ+zlARvNzbqq9RZM4LUJVy5+p+VW/RuhQBsEL2foKC4lTTeKq4
	 c9ALxbiUgKuMZVBZzwTBKcxkiiaV2Mzlm2Z9KKgxRKVouJdfuVMuGTbXckJ/ZGbehRdeX
	 /hWJQOuDO/6r5hOaTT7kzYU2onTPMmLipNtPcWi0r/0zHlqGpkC/BS+lzgRHsSIhnrDGz
	 1oSBWX1JcshT4XtwZ+uAh5WWjpP4QBD0VZD1uvZ4dC6Zjd5/d4gK3M8YZE5wnyqtSng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zoXvq9FjcS30GGjy085QURV8V+B2qcjgP9alnJRWn2k=;
	b=Uv3y7NQ3skouYnzTjOdH/aMpBPvJO50nNOTC77hAG7SOXc5QqZIYX2MmFrLSHrNt5MRc
	 AggSzrQpKTPq/BnV6Vq/vMYK3TzalLSBU6j3wlSsHVACjjxi5oaXn+6mjpgiPUZyH+1Uk
	 lyn7MVa5LmYcSzP5RUDRXuACHNm6TXcdPG43hkKdayOF+TzHyTMg/0g8b8ueRAOuWkThi
	 OiOewLjnGpAajN0N2siuFUQGmPDKeVNXzdX2AXrr+da/9tyU73cgQWyQf3enDmb9k164N
	 g2w0KDwo6Pkopoowwv0p5DKo2rU931OwpTB9bdPQ95DxDwtbWgjUYNy+bL7zKzIGahA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQo8xJnW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D379606A31C;
	Thu, 19 Nov 2026 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQo8xJnW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362031F000C4;
	Thu, 19 Nov 2026 02:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054745;
	bh=zoXvq9FjcS30GGjy085QURV8V+B2qcjgP9alnJRWn2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQo8xJnWJvIx69Hi8gZ/Qvete8knNnOiillzsZvodPe5IBUJPDwlkSOL2E58yepCz
	 wJHtRSsNs/aqbd+sEye/HGgh1535xxWc82iGgDpCKsFpmY7guFceBZCHtQOeNxZvCL
	 wYTmYGsxV7+xMr7lHz3d9bPH5toJv3pgrCVjnOaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1385/2214] wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150106.762817126@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a821e1e24750..b4b554ff8ee55 100644
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



