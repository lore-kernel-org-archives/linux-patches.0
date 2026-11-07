Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064471;
	b=BVO3d5UdwHCiJ7X9TF5GrzER5DIszTkqoG2RuDclX7PkX4Kzti7M+imxKcKojOnMi/FG
	 YA7ho+/YKycWQ5MnHwyYNdsAgMGFjimA/r57kMG2iHMg0O9kX5pbiO1mPAeSXOhsqudPx
	 0YaeMUjN1Nop+CR1Ogh4inea7scbAVTeZJyooaRWbaT/iOZmJXCl41I6yEDaRq+B9ZiiM
	 BFlo82k38RUUteKOdovP9/z6vPbhC7++QGIL196TJHSWZSkMPJ634aeBV3tjgtGQPB1dm
	 BejsV7vo1b8aeqZb/liJzVYX36NwNgchvwENqA760XWibkp/Fgnwf8xd+XX9esA4Hmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22aTDe2RHeY3G/IWytZEGQOlo9REHrd9IPCKlRilcf8=;
	b=RnwcmHgMI06ErwCb9IaPbD+aCZHKF7aj9xEkBT1kWE8DJDPdjeBiYgAjePvNJiTlYiHK
	 TAUDl84x2Q0QC6z2besukuHwNzNI1I92OIujFmw/rOj/Uvizg4LJ+ZpkPAclWFj5wzNa1
	 Lt2BXQjtzT8vY4TLKRxZXTNmoqs3BZU670J63uh9NLsRtIU32Na94RbFjsxgWd8dcce/e
	 vY/OwgvcEjwZvJFTJEWbdQ7sRZ0vbA5OIoTD/uV7+kphGmazrWtJTzjpR+FnrWtbt21nl
	 8Fv3w1kMc26EChNE8M6tlAbYKBR9No3gj9AD6HRm6K1dNlJPc/iH9A/g3eNIEvfa5MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGe5dVr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB9B606A9D4;
	Sat,  7 Nov 2026 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGe5dVr4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF3E1F008A2;
	Sat,  7 Nov 2026 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064471;
	bh=22aTDe2RHeY3G/IWytZEGQOlo9REHrd9IPCKlRilcf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGe5dVr4P/s9epoahODSbASCcKVA9U4CCC3a8pVIXCqBW7qEGhkRPEDOa6yE72Jx2
	 S8UxFmFmjN5EHNMZnrufe9Sp0rB4BlGmL0bzvw/osUChTxZaoRCV2hZzDDaoriqyah
	 mkLwIo/AabcQxXmJeh4iC7PqdYIaTMmkuKWG2qDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0511/1257] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Sat,  7 Nov 2026 08:46:47 -0500
Message-ID: <20261107134953.548583508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit d9e43f46fb324e0a311146f937f0d214f023dc63 ]

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it results
in a divide by zero problem.  Avoid it by changing the denominator to one
if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-9-sj@kernel.org
Link: https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org [1]
Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f4b586188c68a..acbf32232c3f3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3028,7 +3028,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.53.0



