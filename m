Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976041A3178;
	Thu, 17 Apr 2025 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913611; cv=none; b=aYy29ZW9SfySP/rmczrGoaWRqIeU1mZqIr5EUdWugFkTnS3cTTmpfzQdbNjQ/0wb6DGTjH0Fq3oERwH3mFj8kXKfDqorQUj6RDItrQQa4dAudTl0nQShD6zogfRf0M+eMo4FfzBWi/J9DQCGJjYSyJEO7OwuGPSOpwUbi8hEsVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913611; c=relaxed/simple;
	bh=XCTvKF/IWNScgeCf5OTYvL5TJ8kJiAPtN0S9F8xi8Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDyVqiyJEwhOu1xTEK25Uah3EyGpWU4FNFYbkS6sFXtn7vwV7L0Fjf5GxJ58BhSkUAS4JgSZLTO92VuaFtXym/6VxEAMjmlhw5Pf/z3jwghGP+Gi857sGTQsj+mME9WYqz2vevyJ5bQu4MOSkeATA2TBXzltWHaf3QydonhaDdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miewBMut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miewBMut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E3DC4CEE4;
	Thu, 17 Apr 2025 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913611;
	bh=XCTvKF/IWNScgeCf5OTYvL5TJ8kJiAPtN0S9F8xi8Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miewBMutht3zCLqvyaOkOf+ukdIlK1DsqW80Y34HFhlrUbZnWL02AsFlzXIUnzkaI
	 8toDPJkPp4J78t1QfUlzzm3aE774oVev5Z07V47uFWRdyY+p+Z510F+/FiYzPcJ+J0
	 KVGnfFC1qTKWRohxpbvjEc3JABfM0YyWoCS9S4Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 365/449] mm/hugetlb: move hugetlb_sysctl_init() to the __init section
Date: Thu, 17 Apr 2025 19:50:53 +0200
Message-ID: <20250417175132.929676157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Herbert <Marc.Herbert@linux.intel.com>

commit 1ca77ff1837249701053a7fcbdedabc41f4ae67c upstream.

hugetlb_sysctl_init() is only invoked once by an __init function and is
merely a wrapper around another __init function so there is not reason to
keep it.

Fixes the following warning when toning down some GCC inline options:

 WARNING: modpost: vmlinux: section mismatch in reference:
   hugetlb_sysctl_init+0x1b (section: .text) ->
     __register_sysctl_init (section: .init.text)

Link: https://lkml.kernel.org/r/20250319060041.2737320-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4912,7 +4912,7 @@ static const struct ctl_table hugetlb_ta
 	},
 };
 
-static void hugetlb_sysctl_init(void)
+static void __init hugetlb_sysctl_init(void)
 {
 	register_sysctl_init("vm", hugetlb_table);
 }


