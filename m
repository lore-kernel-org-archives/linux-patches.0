Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043890;
	b=h0A6W6uRNTTDGOWj8gsOKPH/y3IvKkSJua1ikfLohqrNX+RvQbm0f6dU6S4getvaSKGU
	 uWhoI9dh7/USVk/1eny7Sfj0l6SVAZ8S8nAE/zlRyThxb8k9QAMec76uqK5ze3OCRhQ/t
	 NnRy9SLmL1Bo5TbY9wDOq2BBCJnKKOmoumV17tBX954e4N2Moya3DR49K8LjbLeXn3Lan
	 OKlqbVr81hGf1YVRJOwOvaVQbYTZwys0OG/wRG+Gy0frMqSSyVnbfyGkua33orw+jNzlJ
	 a1Ato4sZNAi60/RSBaHXPFj8KJd0lrIsWuc83h060RzFpUJQDVvr+Xq48TsiukNxNYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RBkgeCjfhhkfmT0KO3gIXqRfxIvlpPihbh7/iCR3Iw8=;
	b=POUVoX/7bPgXHBHSqIauzY5Hzb8AxKShCGWboz3tBdfDlLC25zOyYg+aBlLfDygmi+ys
	 /U63rn2oAlH9k5Oh/1FCcLpsaa4kstBV+cJ27Gh1/a1C7DHtK4pugzAwPqkd1EhrSoqgB
	 nRnP27/IO2wVBWBZML+8y224no/tRvyYXCn8d0wMO0ZCERedCGGwhWDex0dRDZMZAg5Ea
	 R2J9UNVzjsIgEbVhRDrlQP0WOu05dcKk7La7MiITOefLUVLRrDyada6C2kr/P7of73F/0
	 hKiQ18qdxXDa6yUUWltu9pusHYaQafmzQl1KxtAXsbjKL2I0rZljGqGc6KiMk1E/n7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlb7GbxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDD606A325;
	Wed, 18 Nov 2026 23:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlb7GbxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448481F000C5;
	Wed, 18 Nov 2026 23:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043889;
	bh=RBkgeCjfhhkfmT0KO3gIXqRfxIvlpPihbh7/iCR3Iw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlb7GbxB75UJOi3YJ6QviCnXEjStnt7dxFVHBc4iHn/Yt5d29Qj6RQkbUWe5B+7Hf
	 vzI1l0EnvTWSYTnSvQ0rE91Qp9qIyCd/wBFhryxYn0VT8giVWHJmU92Jip7U3RHJ2H
	 4jG4PgOeox2X6bYbuRRKqsteRhql5A930MGna19A=
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
Subject: [PATCH 6.1 0373/2857] mm, swap: ratelimit bad swap entry reports
Date: Wed, 18 Nov 2026 15:23:27 +0100
Message-ID: <20261118150214.844128645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Only two of the three pr_err() to pr_err_ratelimited() conversions were applied, in get_swap_device(), because swap_dup_entry_direct() doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9710e9793b16f..03adf2ddb126b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1287,11 +1287,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
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



