Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CBD38DE5;
	Mon,  1 Apr 2024 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991488; cv=none; b=K3MwqLosIwIFyhi88KRQG11NH5gwBYWN9JyWrhZqMo3Uu6E/9d5MVKzDGFEecQRCClr01ciZ6SqpBt2sKRDOoyuX8zbgYBXnUgzknmQwH9cp4o/5Xc8e/9DTI/Pg8JyR2H4++Id0SmGFg1mALqP09Fr2ZtwiEvTFtk9pt7bZkmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991488; c=relaxed/simple;
	bh=vj6UnxU3bHS6m3eQvIwA+0kykmJR0tlxc1jNA78p8cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJH9EDibMWdSjKaRqIhZuXVpO5+0l6U8RgZklH1N54IsUCbx6WzODfMd8nem6XFtfsKzDotw9zs3X4UE6WYkiAFm8hcsQI9Sot8Oxfky5LJ2IsQ2u6hdsie59Al1VnA9yU/lVJuGHWhmmuSCBsMrKhQgQjdZgDmDsN+5gL/pSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaKwPsVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaKwPsVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A446C433F1;
	Mon,  1 Apr 2024 17:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991488;
	bh=vj6UnxU3bHS6m3eQvIwA+0kykmJR0tlxc1jNA78p8cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaKwPsVcf1xwXoYcarO+PBON4SfDH2EfIMSJ1dRwFnbvfnpZox29CXtH8PkEZFSUL
	 s8yLrBm/mG4nuxZD7L4VrFaJ/svwYPfp0snxa0S7j9cnfNgbZYDGeszYrS0j8RP59U
	 dZXZIr8Xmmew5WrU7WFFTyk5dcHeXuqu5QfeASI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natanael Copa <ncopa@alpinelinux.org>,
	Greg Thelen <gthelen@google.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 272/272] tools/resolve_btfids: fix build with musl libc
Date: Mon,  1 Apr 2024 17:47:42 +0200
Message-ID: <20240401152539.571111850@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natanael Copa <ncopa@alpinelinux.org>

commit 62248b22d01e96a4d669cde0d7005bd51ebf9e76 upstream.

Include the header that defines u32.
This fixes build of 6.6.23 and 6.1.83 kernels for Alpine Linux, which
uses musl libc. I assume that GNU libc indirecly pulls in linux/types.h.

Fixes: 9707ac4fe2f5 ("tools/resolve_btfids: Refactor set sorting with types from btf_ids.h")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218647
Cc: stable@vger.kernel.org
Signed-off-by: Natanael Copa <ncopa@alpinelinux.org>
Tested-by: Greg Thelen <gthelen@google.com>
Link: https://lore.kernel.org/r/20240328110103.28734-1-ncopa@alpinelinux.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/btf_ids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -3,6 +3,8 @@
 #ifndef _LINUX_BTF_IDS_H
 #define _LINUX_BTF_IDS_H
 
+#include <linux/types.h> /* for u32 */
+
 struct btf_id_set {
 	u32 cnt;
 	u32 ids[];


