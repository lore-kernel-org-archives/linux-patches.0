Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D38F5C;
	Mon,  1 Apr 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987810; cv=none; b=gjoWXFE734//GcKftdU+5pah4BJtb/P2TJOOeilY4ccmJcC8Z2TPH4cDSOraq39wLJ2VsZtATizENXLPk1OwvhbNbXf/FI5qHiq0Qe1kYzN/mxr8tb+foZzlnBV4kdLWL6Q33VtEMXUAcfp47VU2f72q71IzTwnSgO6g5Hcl9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987810; c=relaxed/simple;
	bh=vo6k2yRjfxD3kh0U0wourcvciHcBnEaDzQtAbFisA9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZFc90cuz69NPirMcK5CBa2uRqIK9tDUnlSlFeR41sb175xIz5i3yl5to/SagGrx+BUX1qHb5Wa/JznyEKQShByygf81pwlX8j8bVirP18LP0EzefjoS+Ir3VW3bm+5A0+nlbzZIMiOMHiLpVabJKj/GviROYNledlRp0DmGKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnIR9BK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnIR9BK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E54C433F1;
	Mon,  1 Apr 2024 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987810;
	bh=vo6k2yRjfxD3kh0U0wourcvciHcBnEaDzQtAbFisA9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnIR9BK5h1d0wyxSvvPVNZIrMjnHw254FbgALRtu/F5rlwRhHLHJc+ehage288PAd
	 iP4RoxkZOcfR0w8kh8v3qcv6hpuQt68Xzj5ExK0JG3/VFtgSdPh6an1wPMg3FEc8Mo
	 uuBWIAgPLyz2YHjVOc4NSeUVXwl9fPg0WKJ3ykO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natanael Copa <ncopa@alpinelinux.org>,
	Greg Thelen <gthelen@google.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.8 399/399] tools/resolve_btfids: fix build with musl libc
Date: Mon,  1 Apr 2024 17:46:05 +0200
Message-ID: <20240401152601.090674615@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


