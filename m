Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC0178384;
	Tue,  8 Oct 2024 12:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390772; cv=none; b=UmBrXP0iBZXLQdt/hUmVEV9faZOPYPZCq9oCQoL9zeYuUIzzVLMxE54/OfQkHvTlMkR0EIqH7LmVKNzdMKhOItAt1uqyEJvuskDHdtv9G+rGKs7rA3zglRb8wWk+oD8gb0Sz9g9Hp4EgFfkkooEj8quKkWsML5TO2KMMola1eks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390772; c=relaxed/simple;
	bh=LID3IWvpf/ORg9+x9bgOJSVtGccnPizKjiMMWM4qnaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz186w25Fowa+vcZqB1m51tmaOF2wXSueqlrRnnQiPy2ZwFU2px+Jv8tJ/uKo9CbN3Rdh1GZyOq2HhAgKYVN2UrGQ7Y4bHVRk42h063tl1RnKTK7MeGaB0ELjEzqqRHIBBH9kVCnkaWERruaKElAJTljkVBSJ735YyX3Q9u+Ckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+c7EruF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+c7EruF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01280C4CEC7;
	Tue,  8 Oct 2024 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390772;
	bh=LID3IWvpf/ORg9+x9bgOJSVtGccnPizKjiMMWM4qnaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+c7EruFiFDED4bdM3LZ/raFgshXal891MWzStsa6w1M0cATze/8l5hKmSlL/dCMj
	 E39Xf3KISmQienmvhK7AAtqAaWkcbp1OFn46RZ1ZMrdj0OWaUk7i26boUP8LfKlv7z
	 1xal9yaRjtO2LtebCiSzhjdaqVlciwh47PDHd6gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 361/482] scripts/gdb: fix lx-mounts command error
Date: Tue,  8 Oct 2024 14:07:04 +0200
Message-ID: <20241008115702.629204778@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

commit 4b183f613924ad536be2f8bd12b307e9c5a96bf6 upstream.

(gdb) lx-mounts
      mount          super_block     devname pathname fstype options
Python Exception <class 'gdb.error'>: There is no member named list.
Error occurred in Python: There is no member named list.

We encounter the above issue after commit 2eea9ce4310d ("mounts: keep
list of mounts in an rbtree"). The commit move a mount from list into
rbtree.

So we can instead use rbtree to iterate all mounts information.

Link: https://lkml.kernel.org/r/20240723064902.124154-4-kuan-ying.lee@canonical.com
Fixes: 2eea9ce4310d ("mounts: keep list of mounts in an rbtree")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/proc.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/proc.py
+++ b/scripts/gdb/linux/proc.py
@@ -18,6 +18,7 @@ from linux import utils
 from linux import tasks
 from linux import lists
 from linux import vfs
+from linux import rbtree
 from struct import *
 
 
@@ -172,8 +173,7 @@ values of that process namespace"""
         gdb.write("{:^18} {:^15} {:>9} {} {} options\n".format(
                   "mount", "super_block", "devname", "pathname", "fstype"))
 
-        for mnt in lists.list_for_each_entry(namespace['list'],
-                                             mount_ptr_type, "mnt_list"):
+        for mnt in rbtree.rb_inorder_for_each_entry(namespace['mounts'], mount_ptr_type, "mnt_node"):
             devname = mnt['mnt_devname'].string()
             devname = devname if devname else "none"
 


