Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D3E19AD91;
	Tue, 16 Jul 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721136592; cv=none; b=rNVvnGYZPeDSq1lbv3IlqYikSmgAtCpQDKQzeuwV4/qtQlucMfcPi4gC4RIzfIqXvEgZYmyBSYSKwS/E4/09rTlKkvPHJ/xiQI7PUzSnUAtZ4cN0wWrSGJzsTWqhnyWkQ9NLH0tOMrzTZbfogu8ZcbtAZ7/KPLluOh84DhHnFvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721136592; c=relaxed/simple;
	bh=syEoVGqRv/IPR/xAhh5W41iFKJBgO7QaOxMuxUpV0i4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Be/fTgiioM90cl8IOSWTKgMm6bbXT0G+ziV852CMdPcc4trL8+6ZHPCkHplGsp0V5nO8oWdFKNKlf6iz/76IOGQmr2dnAfypTn1RwEx8rDtfnkn3OcupQsIQ6gDTIBGfa7fUxZV6eISGtAMc2uhY/4bujNZobNtvQxSU7jIfaMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRdFZrPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRdFZrPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0340DC4AF0C;
	Tue, 16 Jul 2024 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721136592;
	bh=syEoVGqRv/IPR/xAhh5W41iFKJBgO7QaOxMuxUpV0i4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=JRdFZrPppfQ/0kmRKOCE1QM5m5vndcjgh8DOS1zymien9PVn9Q43ezEzgu2WsyP2b
	 kbQL+g5Mu/2yjParqOnhNPdxfveWxYVurFsZ/VROfU0169tBpdKQqj0WsduZy7h1Xh
	 WLpr22yC9U1JLu2SAo7HEXXXhZMhFL20bChrD2Uk=
Subject: Patch "ext4: avoid ptr null pointer dereference" has been added to the 5.4-stable tree
To: gregkh@linuxfoundation.org,jack@suse.cz,libaokun1@huawei.com,libaokun@huaweicloud.com,patches@lists.linux.dev,sashal@kernel.org,tytso@mit.edu,yangerkun@huawei.com,yi.zhang@huawei.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 16 Jul 2024 15:29:49 +0200
In-Reply-To: <20240716092929.864207-1-libaokun@huaweicloud.com>
Message-ID: <2024071648-mumbo-trapper-8a49@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ext4: avoid ptr null pointer dereference

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ext4-avoid-ptr-null-pointer-dereference.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From libaokun@huaweicloud.com  Tue Jul 16 15:13:28 2024
From: libaokun@huaweicloud.com
Date: Tue, 16 Jul 2024 17:29:29 +0800
Subject: ext4: avoid ptr null pointer dereference
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: sashal@kernel.org, tytso@mit.edu, jack@suse.cz, patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com, libaokun@huaweicloud.com, Baokun Li <libaokun1@huawei.com>
Message-ID: <20240716092929.864207-1-libaokun@huaweicloud.com>

From: Baokun Li <libaokun1@huawei.com>

When commit 13df4d44a3aa ("ext4: fix slab-out-of-bounds in
ext4_mb_find_good_group_avg_frag_lists()") was backported to stable, the
commit f536808adcc3 ("ext4: refactor out ext4_generic_attr_store()") that
uniformly determines if the ptr is null is not merged in, so it needs to
be judged whether ptr is null or not in each case of the switch, otherwise
null pointer dereferencing may occur.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 63cbda3700ea..d65dccb44ed5 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -473,6 +473,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
 			*((unsigned int *) ptr) = t;
 		return len;
 	case attr_clusters_in_group:
+		if (!ptr)
+			return 0;
 		ret = kstrtouint(skip_spaces(buf), 0, &t);
 		if (ret)
 			return ret;
-- 
2.39.2



Patches currently in stable-queue which might be from libaokun@huaweicloud.com are

queue-5.4/ext4-avoid-ptr-null-pointer-dereference.patch
