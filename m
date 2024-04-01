Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF23F8F4;
	Mon,  1 Apr 2024 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989272; cv=none; b=sFX5M8n0/Ay++wwUuHaWa2WR8BvaGIVn0AtpDcfl9B0f1NglE7KN1m81ARnrvYtd05PYRp6BjsldbUwwrKkrjlO33smktR/mCa9GiiIlel1vlw3GqBcW3UClON771Frw4qZaNJuTapLyftZaVHfNYoA721L0i0u5pzDhx5TBWJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989272; c=relaxed/simple;
	bh=QCQn0iNz3hdC2KZgpcX4Bc6E67aCAzio2M25lKNz+ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeGcVB0mg3RiAUBdT6DBFbeElSa0EZleVtDrICwK8E9JUw8x0qG+9poxsRLTdV7tHQi3ddoVKvgBfS68UFLlKEy/K6E9VQDxCKNzY03RpmjZ6CFhULbJ83SY2nn+wexDkygpkNtXh9pgHBRpNQPAVuUTGT7j1pcPe+E0wHjgFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM6uIFE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM6uIFE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E053C433C7;
	Mon,  1 Apr 2024 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989272;
	bh=QCQn0iNz3hdC2KZgpcX4Bc6E67aCAzio2M25lKNz+ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM6uIFE94a/l1ppidAf5GIZrT9NCdIbX+oK60/Ex8qdKpwGR4qfL10WaFYrV2dbdU
	 Y3DVjBKD1wQavA1owvpNfpJSguFef4ZSUT5hDwyGKAefWx8y8wJU4EKrP5ZFXN6/Be
	 b9VWE+7YA8c4vBgrQA9yj91hURvkeQ9CwIJKyDXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natanael Copa <ncopa@alpinelinux.org>,
	Greg Thelen <gthelen@google.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.7 432/432] tools/resolve_btfids: fix build with musl libc
Date: Mon,  1 Apr 2024 17:46:59 +0200
Message-ID: <20240401152606.331070644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


