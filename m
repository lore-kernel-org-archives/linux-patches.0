Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE52266B63;
	Tue, 25 Mar 2025 12:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905678; cv=none; b=h65CZAKsAQhnjhbifUmfWjherAbucWZfoa8mbHJb59FfIryQSbC1CWuPBoYb+eQCee5uWk0WF9jx/NlR4sHxkhcpi/JYQHXc2XFzUkoiRpcom7FbJE/ENRS2QMFMl6HEyyQ9eHwg0mMVE/+rb80QKYWbOJdjN5i/HGKRdMsLNl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905678; c=relaxed/simple;
	bh=o6VQgI8AtMN9VO+cFjOnxl3wO2Mzp/UQx8IFOjcyFMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDIXhW6hxuDcc3qt6pcZ/UmaS8YE8yANy9NZ6NzEtKmetB2mn9XxOkeGC6VmNmKrP5B7IV0KO2nxfrxuRB3wfL8R0zI5gPyYMN3PfvOjxMH/jJytMsqQcyNZ3ag/LOpas5yF2w+ooRENOV32v7VUfKetOQCgpYTiEzZGnodafzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9FHGemO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9FHGemO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809F8C4CEE4;
	Tue, 25 Mar 2025 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905678;
	bh=o6VQgI8AtMN9VO+cFjOnxl3wO2Mzp/UQx8IFOjcyFMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9FHGemOZrE+g5TwC3xHEAn2jO7dwpbhrSssICPNi41KxcZddM07mkVHcgWs2PzsR
	 DMxQeml784Xf3gMO7Y+z70yAW5JWYDJkXou2ljqQ5LFg2zIx3uO5tZL6MshZa8Yr9x
	 RHfyGxnEkHMKMStPrmbjLIDiiR95M42FS4fMyrKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 074/198] mm: add nommu variant of vm_insert_pages()
Date: Tue, 25 Mar 2025 08:20:36 -0400
Message-ID: <20250325122158.580528034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5 upstream.

An identical one exists for vm_insert_page(), add one for
vm_insert_pages() to avoid needing to check for CONFIG_MMU in code using
it.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -357,6 +357,13 @@ int vm_insert_page(struct vm_area_struct
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL(vm_insert_pages);
+
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 			unsigned long num)
 {


