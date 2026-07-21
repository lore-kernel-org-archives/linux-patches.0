Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E446D54F;
	Tue, 21 Jul 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648593; cv=none; b=DbxE9QtcTTd++w43y9iDvlVnAvsPo2zPVm33ji4HDu2ZtVzGHuYUXfSaexW2iqZIX9RpFEj81QTvqxB/sjh/FpDSdRA8xpPEs+ZIizhpVfVw5l6yl3Vz6TyMYd6Gi1AnHHbjDChamSb2tDJcF0Mo/gxvh0sE/v3/WzQgv4oOYwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648593; c=relaxed/simple;
	bh=fhQIzByAomX6e3sRzlLn0CtPy1JNhr3XiPOx/vciM6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJta38Ak1let2GQdIYQyxlh2GiFCFl0pRlM5UuAQaposNhTleUBA7lY/1r+FcG0qr9SHBqJaFqYy6O6ybbVGi86QmsYCwIUwoCKm/CVTWQ2YPwLYFuJYB8186VmX6/f+amnTbSmlkOLRE8SdxyvFHFq0EPov6CEL4k+It41QZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j02Yxdn7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j02Yxdn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899661F00A3A;
	Tue, 21 Jul 2026 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648590;
	bh=pDuf82nyG9sE9Aely1/vGGLpa0zl5FyRIZ+tnoBy7bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j02Yxdn7xlQ9scoZXcfqS0ZooOWXYCzgwiHUWvbiTF90vzTHLQYbWrRUeuwDKrNCZ
	 TS5Pn89AC6z9kBIiLm8F1dV4+Yeige5c0KhJy3U9kwsqqvv6YAtNj97hwLuSSIUvsO
	 fMF6lsV58zgLvmA1vj6oKiMTPV1Q62dw3l6UEsSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0256/2077] vfio: selftests: Allow builds when ARCH=x86
Date: Tue, 21 Jul 2026 16:58:49 +0200
Message-ID: <20260721152558.718008013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit 75182529687e204b2bd046a3f7b1c2acb5031032 ]

Allow builds when ARCH=x86 since the top-level Makefile can set ARCH=x86
even for 64-bit x86 builds.

Note that ARCH=x86 could also indicate a native build on a 32-bit x86
host. However, it doesn't seem like anyone is building selftests
natively on 32-bit x86 hosts these days since KVM selftests allow
ARCH=x86 and fail to compile on 32-bit x86.

If someone reports an issue on 32-bit native builds we can harden the
KVM and VFIO selftests to explicitly check 64-bit (see the discussion in
the Closes link below).

Fixes: a55d4bbbe644 ("vfio: selftests: only build tests on arm64 and x86_64")
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Closes: https://lore.kernel.org/kvm/20260427231217.GA1670652@nvidia.com/
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20260428232707.2139059-1-dmatlack@google.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vfio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index a19b75742342ad..0a4cfd1a6c7ed6 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -1,6 +1,6 @@
 ARCH ?= $(shell uname -m)
 
-ifeq (,$(filter $(ARCH),aarch64 arm64 x86_64))
+ifeq (,$(filter $(ARCH),aarch64 arm64 x86 x86_64))
 # Do nothing on unsupported architectures
 include ../lib.mk
 else
-- 
2.53.0



