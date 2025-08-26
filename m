Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC142248A5;
	Tue, 26 Aug 2025 11:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207349; cv=none; b=kzQiOAc0fMPAjkwu7dI5N5pKo7D9LH6EJM8WVEpb4fba+YlFp+4xwYmxNzjv8pUaJdv/Tu6XLAtif3w7rh7ThJbklLq5ZpHL7AXkth48q13qBIW3D1P07vfqiVN1DkEl4sfnyCUp1RTGQWdBIYhuUMSNFPxyB9H5wph9TdIIb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207349; c=relaxed/simple;
	bh=6aiHJrTmLlZLiWmv1r+hfwnJ/YfuuJyCgXja/b7Qr+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I60PuwH6QCFbO0GpDUQc8ql8y73iFqtK1QQeXwSMzwwG4wK1WGz3RvU8L0QoOvoOZja+yszNNBdJYqK0NwSmUYYkZYUkXFUy42CmtX5yAji+ItcGKTFfMrbmurUG0harmpeTQR2y+sJ3Ry6QSF3DZ3amJQzTUgIejS9AKWjHuPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K82rCMME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K82rCMME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC0C4CEF1;
	Tue, 26 Aug 2025 11:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207348;
	bh=6aiHJrTmLlZLiWmv1r+hfwnJ/YfuuJyCgXja/b7Qr+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K82rCMMEFr9KD3MvTAUubqKZevljpLRQ21C1/8TC8N8jSJvQlSWQ6cF8w7fCeh3kO
	 eO+AUDjTbGi3oQArr//B3c+Etn2JLSjNKggCreuq6k9KT8XDuFPQGhpl6JaQCXMaf/
	 qIba2e0zIsxOuYd3uXGJsD+3kx4bSMP99MJwiTBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Richter <Simon.Richter@hogyros.de>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.16 117/457] Mark xe driver as BROKEN if kernel page size is not 4kB
Date: Tue, 26 Aug 2025 13:06:41 +0200
Message-ID: <20250826110940.264514206@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Richter <Simon.Richter@hogyros.de>

commit 022906afdf90327bce33d52fb4fb41b6c7d618fb upstream.

This driver, for the time being, assumes that the kernel page size is 4kB,
so it fails on loong64 and aarch64 with 16kB pages, and ppc64el with 64kB
pages.

Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20250802024152.3021-1-Simon.Richter@hogyros.de
(cherry picked from commit 0521a868222ffe636bf202b6e9d29292c1e19c62)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -5,6 +5,7 @@ config DRM_XE
 	depends on KUNIT || !KUNIT
 	depends on INTEL_VSEC || !INTEL_VSEC
 	depends on X86_PLATFORM_DEVICES || !(X86 && ACPI)
+	depends on PAGE_SIZE_4KB || COMPILE_TEST || BROKEN
 	select INTERVAL_TREE
 	# we need shmfs for the swappable backing store, and in particular
 	# the shmem_readpage() which depends upon tmpfs


