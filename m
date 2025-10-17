Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137F1330B28;
	Fri, 17 Oct 2025 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715730; cv=none; b=bgGi8wbvHMWySwBis15Zdl/o2rMKAMmCtzGMjyDA0VGXxtr34ECffEzOz6bf52kylU4GxkVkX7+FiBEed5KdGwfAJA+PhsUk/ETNha+77ty2G9LYzN9QxNrnn9HPpyVenpKWPUKrEbT3IfoIHy0O9PW130RGGu/DhWDY8B/5cpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715730; c=relaxed/simple;
	bh=u8ZxwuIieXxkklE+9+K6yS+kKLCk53F0qMDwbj9C4WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIxRSJqKjiY0hlftVketTF6JnOxKlBU75Yz+P5EOfTvAGvt3gVvuRf0n/U7RC0mk823CJVZ5nONaWqMD/EFhwJW8TJ5fQ0TbWaKNEHYNrqgoSUR19KQYIDX5SzEqgaiEpXKDBPE35hhd4BmO5wKJjy+dRoQ3xLxgARBJE7R3QGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+jCv7Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+jCv7Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A9EC4CEE7;
	Fri, 17 Oct 2025 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715730;
	bh=u8ZxwuIieXxkklE+9+K6yS+kKLCk53F0qMDwbj9C4WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+jCv7DkFIpIXmFz8T6OB+1jS6Sw//Rfi+PbqKmLHMYKAJGIu3jH4+gWlgSMGZSSO
	 9pdGQxInj93nSGIihiJ7l4aXa/dgJUeEGkOH0XaNI7RY+g4qWSqHeWirHmQw7gHTbf
	 zTdwHJHLeo2/u25nOr5RNkUuqAY41lb2wrhvRODE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 318/371] mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Fri, 17 Oct 2025 16:54:53 +0200
Message-ID: <20251017145213.582423241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit b322e88b3d553e85b4e15779491c70022783faa4 upstream.

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, avoiding unnecessary CPU cycles and the below log
message when hugepages aren't configured in the kernel command line.
[    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

Link: https://lkml.kernel.org/r/20250814102333.4428-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_
 		return;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;


