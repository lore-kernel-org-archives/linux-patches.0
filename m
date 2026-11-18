Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022791;
	b=kdm9FKRq8V0SY+n6GuxA4y/E5zfZE2JC0ja5WXtlxeueGYEzL0TkDpL5g6+kcgdsfuuk
	 Os7rAiX6sWL60hzwVRmbeGJ/uQ1ZHojxcH1jvJio51Y5LeyTZMM0NtHgauqO+VzcxNVNi
	 lNzWlCySD2MqQnI8I4XFrRCmcdlvGZ+9dfLNAbD6DXfi6moMc7+6LtiH2e4xuI1xz0DNI
	 Wec8lqag5Ky7SFMT7fvbO+NDvLulHTSLkr6C9NBnTTRkrmzSHvsotVE2Q06xROSsKRs0Y
	 T1ALZcptaNSHRugqr9EKWT25J4/lGGwK0Nglf88WS6ny9a82Tn2B7nUgxeMbUMIakaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QPCBjcOOqyWg1jnMOSigEDTQ7N3FQKCf/s083AG5XzY=;
	b=YfFQ5T2mR4c0TwPBbnZmgXx0x+VMk/pv8ITEoLtOCtm+2kQezziURPODAY4rZrcBmO4g
	 1DtUN6j90UjxOfTq/CYUxJv6IzHulv0dws5JiKKNFnRWrz4vZdA80yHq4Qy4FLDeq8wcu
	 sSw+HYWYpY0kF75wPmU4tmZMkhu5nNzUvi33iJJjfMXDzzFeb9Z3vR+cXe+xvIDBtvt6b
	 nqVuS1KA/ivpHxq2eKgCZL8QKEEBb9c+G84qt9J9LhfGdgpMqB7uPeeGU1CZW12t+/xbL
	 +MiTEJNzm4ZTGVYApiqMHJb/rTiXt1a9LGcFVPPNQ0JBhes9rYl6KPqDUaZq99ys1GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lv1YPpPs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A33606B5C9;
	Wed, 18 Nov 2026 17:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lv1YPpPs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93ED1F000C4;
	Wed, 18 Nov 2026 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022791;
	bh=QPCBjcOOqyWg1jnMOSigEDTQ7N3FQKCf/s083AG5XzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv1YPpPs+rhd04MCjPdHYSQ4XAz/HVenIWwEqPRlrBd9gp0FAxE21NxAPYjxqlmBP
	 k5lm7jCjG9qpUamtDM3a6qEMkyRNOWUJ6hQOVl6Gy+N5MGok4W/8htHPwyPbLsUp1y
	 h+tnOyAsdLWw9UVZpvH5sIs++pHhZ85TNgilWKfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0098/2151] mm/shmem: preserve allocation errors when swapping in large entries
Date: Wed, 18 Nov 2026 15:30:33 +0100
Message-ID: <20261118150125.373590534@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f4ce23b1feef16d435aa1188b6c2a637a5373ed5 ]

shmem_swapin_folio() adjusts swap to the requested slot within a large
swap entry before allocating a folio. If allocation or charging fails,
the error path compares this adjusted value with the original entry
still stored in the XArray in shmem_confirm_swap().

Unless the index is at the start of the entry, this turns -ENOMEM into
-EEXIST even though nothing changed.

The caller retries -EEXIST, so persistent allocation failures can leave
the task spinning instead of returning the error.

Restore swap to index_entry on allocation failure so the existing error
path checks the original entry. This preserves the allocation error if
the entry is unchanged and still retries if it changed concurrently.

Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-12-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Duplicated the swap = index_entry assignment across separate direct and cached swap-in failure paths instead of one shared error block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6828611bcdfe0..e7c4d134b8255 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2376,6 +2376,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
 				folio = NULL;
+				/* Make sure to validate the original value. */
+				swap = index_entry;
 				goto failed;
 			}
 			skip_swapcache = true;
@@ -2384,6 +2386,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
 			if (!folio) {
 				error = -ENOMEM;
+				/* Make sure to validate the original value. */
+				swap = index_entry;
 				goto failed;
 			}
 		}
-- 
2.53.0



