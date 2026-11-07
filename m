Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063617;
	b=3eOzttRnYteLulnJbkVrKRpzL5sAuUeuKlTQE3QjSV4LjLYOt96lHaQ1kQmI53iE74i3
	 v+/p+70skHo6Jv8j8uVqr6va3AqYiLa5ywbUnh3LiH9O9TyRslebLTn9kbHL19ShoL34v
	 Vnn1UzV5H7LPQXSOcSLkjlrM82W5O14KVbya6I1ASIyFaOnTWPLHRNecemOixIWnUSQdR
	 hUdq+8NrlOXeZUyHKex487fgOtKVsonk7xfiiVPmIOlPlgsnd5/U0fEKu+QmSXCiSABL/
	 0sJ/tnzFkVljl/lAYV65HherxWGrg/cwf7Ws11PdYn6/x/sS9ok0TpRDyXAQ4PN5tdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3bA7WQB+x75mUTlFT5piEpoBjqjPSXGtj1bt4anJEw=;
	b=nfMS8+c/zXw3NJqLI+SRPLtgz/OZJSNg3XTYx1I74H1EfufZ7voTRZbU/jeZS6SMQhcP
	 zLxT3uion5oWaC5Xi59ycPNei64sqkw6O+RM5CIsageOrlWAA8BU6RtxJhf4kJmAD75Bf
	 o9XdKyX7PACCfwDK1fpNy7yq8of/TtHps81qmo4Xap9iWUp+O7LFtT6aIBqF0/Ozuamwk
	 uoFzy8EzW1g/J4Up9AmbY/fLqVJqqvYAm6lIKCv09/u08+S04JwxCCpU4S5PkTH+VUxoX
	 /xUDGXU5kbjeBGUGd8tLHmwj6QQu0tD3c7KiEVcfbgrA/IieCeg4/rApSWFShQCO5fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BtueD//2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604A8606EE9F;
	Sat,  7 Nov 2026 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtueD//2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F891F0089F;
	Sat,  7 Nov 2026 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063617;
	bh=Q3bA7WQB+x75mUTlFT5piEpoBjqjPSXGtj1bt4anJEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtueD//2jJZaxwjzykxVw9x75nAQeBBvvbSNnfT125cbs1PNu0OQbEY+KFZDbZDS6
	 uvSsFyudW0Y1HAyM5n1ba9jyA6p2MlxQ7ZyTYYzZgTNe9DFx/iUey1HJwn/Mk/yDVc
	 4yi40ZZkjGjl1eS5o9uQ9pHH6nIMGrL3cv3osQBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 738/869] stackdepot: stop preallocating after the final pool
Date: Sat,  7 Nov 2026 08:57:00 -0500
Message-ID: <20261107134917.849318631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Caleb Kan <ckan@cloudflare.com>

[ Upstream commit 8f56ea8e0706d92774603260779c7032f03ef3ac ]

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Link: https://lore.kernel.org/20261022083330.3159793-1-matt@readmodwrite.com
Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Caleb Kan <calebkan1106@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b9..b20f4db5c83f6 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -322,7 +322,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
-- 
2.53.0



