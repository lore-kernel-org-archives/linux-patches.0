Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1FB6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2599BC340E8;
	Wed, 23 Mar 2022 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076806;
	bh=dpebCXcCMZy/nYUwYJF4NBvqp/LWx/U1nCzsUv3INSY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=sLIICAmV2pihPABm58WOUns3Sz/tuniO+drGnHj+HxoC28PGucjSvZGq/4IXWTnxw
	 +U0O1XUeBgTAOrwtSY/2Ep+9dYj+rkrHrKpMUMFMXjXZPFqJcj7faAT5KMPC4C8k6r
	 /RaasaXAujoZUCvYTixjH/B3X/PLoZwjrctHko4A=
Date: Wed, 23 Mar 2022 16:06:45 -0700
To: ryabinin.a.a@gmail.com,lixuefeng@loongson.cn,elver@google.com,corbet@lwn.net,bhe@redhat.com,yangtiezhu@loongson.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 29/41] docs: kdump: update description about sysfs file system support
Message-Id: <20220323230646.2599BC340E8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: kdump: update description about sysfs file system support

Patch series "Update doc and fix some issues about kdump", v2.


This patch (of 5):

After commit 6a108a14fa35 ("kconfig: rename CONFIG_EMBEDDED to
CONFIG_EXPERT"), "Configure standard kernel features (for small systems)"
is not exist, we should use "Configure standard kernel features (expert
users)" now.

Link: https://lkml.kernel.org/r/1644324666-15947-1-git-send-email-yangtiezhu@loongson.cn
Link: https://lkml.kernel.org/r/1644324666-15947-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~docs-kdump-update-description-about-sysfs-file-system-support
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -146,9 +146,9 @@ System kernel config options
 	CONFIG_SYSFS=y
 
    Note that "sysfs file system support" might not appear in the "Pseudo
-   filesystems" menu if "Configure standard kernel features (for small
-   systems)" is not enabled in "General Setup." In this case, check the
-   .config file itself to ensure that sysfs is turned on, as follows::
+   filesystems" menu if "Configure standard kernel features (expert users)"
+   is not enabled in "General Setup." In this case, check the .config file
+   itself to ensure that sysfs is turned on, as follows::
 
 	grep 'CONFIG_SYSFS' .config
 
_
