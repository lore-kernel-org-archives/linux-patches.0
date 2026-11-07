Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064662;
	b=uCtr+L7uezJG42aAoi3X/MLc2QbtSw9Z3c9ux3kxTgok7FqAorpTxp4kFu4yN0OopyKD
	 W+NvQu4Kg24MGZ9Uf3aN/vd4I8qjzeXry7AzVH5QZsvbZ8egi+YbwCJmX62TdjLqv0iM2
	 qQd8DrpU6mPvnrDPET9GYjAPPY3yIvKWLTSQoDN3aldBzJT/8WhKLmpj9KuXa/kjRPhV4
	 RzYS3gS2rsfo46WLNR0VliyzPnX8rueKGtiBAfXmQwa6jiQuH/BgYYg1g8Vw1CiGN6d9P
	 uACCr80x1H7zrMnmFw66d6ZL/tdPxQaP7TNKpWQkAcyC/rci0ip/G9ddSM/a4/kcM9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hyuwtZfAiLdY7pxUrOjQ8Kr4ogQCX9YPrgIHnpu9i64=;
	b=wBp6KkSwRoCBM8bKHG7Ra/KWr/eFcl5IcO+HBzp8KOu9x1wSRIwv8AV+26U800PLeGZS
	 EuFNjyKgHS1DtNLSO3ZWg6GGj7/gYM6w4I125Ras0Bq+mUP9+AXLh3xskHp1J++c+FDCU
	 dHjmwdLPgN6XKNdKS3Dc7Ws34UC/JZR48DplXc380UNLCgZLieKPtcMefkIxcx3bvFe6U
	 pm+VRJwrLib7YiQC4giLA+A8Nq3yyIInw2dzUqPe9Tsfq4WZSptOUiD5FrQ4M1EAdpwO+
	 p0sfFzIC1NNda3SN9niqFEqtNpCNnpNC4SDEZNMh2Ixn4dEq0AJxZBtjjVw7R5Hc4tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqPnz2T0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806B8606CE5B;
	Sat,  7 Nov 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqPnz2T0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362CA1F008A1;
	Sat,  7 Nov 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064662;
	bh=hyuwtZfAiLdY7pxUrOjQ8Kr4ogQCX9YPrgIHnpu9i64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqPnz2T0NfDJjVKmw0jqtQ+PdD1P4TEedl+23ZgEHu0vBWY+sFx5nOtYYN9c67XDy
	 8nf6gSr9q1J3lCRWGLo5XX9CKlsvHaVGuydV81yj75nIwNeEyxSUIcxCKJTuMbrFaD
	 mfKWYayFpx5tWG1JHWiFAPkyypLdeVXzZgZhyZRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0661/1257] mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Sat,  7 Nov 2026 08:49:17 -0500
Message-ID: <20261107134957.513536858@linuxfoundation.org>
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

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 23fac055c21176f66ed453394b533bdfc00f7fba ]

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 7cf7c18119b43..3fb41311e4c7d 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -241,6 +241,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
-- 
2.53.0



