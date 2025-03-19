Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3041208970;
	Wed, 19 Mar 2025 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395226; cv=none; b=ZegAC1VQssb0QE0kJfYEcpON+XR5EUY/AfiH1myaa1aGsc6GHnN0S5d50CPm3bnyJffEt5gOy3JdvASjmTik/Lj/35GW7iDZdC8dNFRw3si580HvxwCQxSTfsnYxeOpopYrnSh1PiG1nipou+Rtb6ucbB6fPvfHwOHrtqsoEnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395226; c=relaxed/simple;
	bh=/HJTuYoiLNvfsFn/vDVEDhtlMpZT5hB3DsxgyANNYDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP+1lAz885KpVzqAt49HA90sO/ybNs9XehQo6R3BLwEbESyUV+sB+PRxOsVF/toheH2ohrdHwZXhg9MSrAY4OYPcflnLmIfJB4tz1BGKgUWq9ZAfZuZltNOKHM6D4lWX6TwEkY2lqnWPT6icGL4aGGD/QHVgFZSaXFj67pSOSRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrARiqL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrARiqL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C8BC4CEE4;
	Wed, 19 Mar 2025 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395225;
	bh=/HJTuYoiLNvfsFn/vDVEDhtlMpZT5hB3DsxgyANNYDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrARiqL9Wcpa2UkpVeaCRj/iUwPEEQ4gh7jsZLsU25NnD0kyjAdCJURxgwEYsq/aA
	 sJMv4ivFzfyR94eLk1uYGbVJbZBejwRulQ7krYt7CN0hqmVOnOF9A69fT4dZ/zotmG
	 aArUVK0d5VpzvVaJyJ3n9+4mfQkFEV8Vae2tp5ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 094/166] mm: add nommu variant of vm_insert_pages()
Date: Wed, 19 Mar 2025 07:31:05 -0700
Message-ID: <20250319143022.568619627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


