Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034662;
	b=Et7/6Hk9oNU1E4kUAMX7guWJUIf05R3twR5NasBDTCqtDOcNSz50UsW2pdxufN5LFaN4
	 jh0KMsmAtM40wsgIwOrGPCBg4kGzAb4qwIvTfl1RfxgNClA+sF9KBJcwiZjvmq2i6BGU5
	 QG7CtDAwM/JcMcsborVbi6DLroiVjy/NGoL8wkW/Nby6OFsWrSPoMCc6BcP61RTl+7uLG
	 xnlyvHjoUThOluz1fdMoMB84spDSo1IcpsBPCpFu9/03e66t4voRrO9gub5hedFJjlU8n
	 wKQKFB+qD5PlKgtKLLY1wuWECQEYUj+NmJ2KFt7Z8hQ0y3wqp1TqKwDJdKWDEC4DSFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZvqAgjVgQ8ohe23WdgK5iQZ0mYJ9B0MQrYMe54moIY0=;
	b=Ixf0NZtFRkFR1YqOhiPrd9M1zm3jKM8AJ1FvRzyzHOWI52exIKt5z821gsPx54b9xigt
	 Lkl29Te8QfLVlzogqyZRnL77TTBnIAC/hZRL9INJ6r+01SBctNKUYai3U8DZ9IW0soh+A
	 r3RfJHp0CRxiElZx/RzRIJ6dTGdA0nF5pvms0Qams53yYe7GO3t5FWJVGDQuL4T2PUlV3
	 Hw70rTnGsftNlRlNxwIFNVO+0OlqR8YRGP9cBTBFwLbDkcaiLgVmT9EziUfE8hV7n/sMU
	 0NieI/qNr/Vu/0Pe5/N6A1z/temJcRohVPaISwBS0dKNfpHAkAE2MeUtAzJeynLNL5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8Ugq7oU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88FB606A334;
	Wed, 18 Nov 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8Ugq7oU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214CD1F000C4;
	Wed, 18 Nov 2026 20:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034662;
	bh=ZvqAgjVgQ8ohe23WdgK5iQZ0mYJ9B0MQrYMe54moIY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8Ugq7oUQltaFYn1gli3MbT2EGkjnBGM5TxZvZra50PJb/9ZrCP69MdnAr/xNJyDm
	 lEMKETeCKyZ4Y80zYWsnZ56Ik1Bt8+vEfyl5ZWUJYEcH2O7G5izLAP919elUsilBt7
	 qQp4EXKBrwiP5cHmbzxZu6Oo8yl7ch+wkT0BFOq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Barry Song <baohua@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0432/3318] mm, swap: ratelimit bad swap entry reports
Date: Wed, 18 Nov 2026 15:17:34 +0100
Message-ID: <20261118150329.595869530@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f9dc428249ed962a70acf301f01eae8578449161 ]

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged.  One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Link: https://lore.kernel.org/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org
Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Applied the two get_swap_device() pr_err-to-pr_err_ratelimited changes by hand at different offsets, and dropped the third hunk because swap_dup_entry_direct() doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53637144c18e5..d4a4b2fb172aa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1284,11 +1284,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
-- 
2.53.0



