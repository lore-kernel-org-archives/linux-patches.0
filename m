Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D146EF9A;
	Tue, 21 Jul 2026 19:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661264; cv=none; b=M75AqosqZIHWYlRpjWn70mtM1y0DaXFRhKCaabpXcU7cOrOiwQKZdDnOITNwkR6q1sM1LQQRjHzNZOLWvHg/XJC/GE6RWQgEEjyESys32D6C60HNwnTRp+tK553juDuG0hr6jP6cx59ub3yKD+wlxkgi+UyE5d/+uajSA40JaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661264; c=relaxed/simple;
	bh=P/whtWMLAIxkAuLJ3pZqHe44KvgCcrTc7zKu2Nm0Frk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWdGcS2lnY7TriODhnx/5XAPOEBOiKpkP2tzG9aqFmen/c6vULyNk1BYUWrlDp0S/zaL9NsjgIZc75no4xk14EOyeMx3nkATTvAcdN3M+nJrZoqiTaXKOXioiCl+NhjoEeWTgytEHYDTKUQth7ekDmjVvXkW9vc9y5fNh72+sT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXBnctNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXBnctNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E4A1F000E9;
	Tue, 21 Jul 2026 19:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661261;
	bh=eHMrOCJM3aZrjIh6h0yqnAwru/U18I63K21IsKWKahI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXBnctNewfCAACEQzim8X9OvWi+sgCXETWbuDm7x9qoLG3MnCTaVxlTbmcmQL2YL+
	 l9+xSvltvDA78ufPtU8oVjyJwcN5hpEG1fjGv8qPtUE/OUiCPcNPx37JkJxpDDGjBy
	 wNhxNkgvgEMrDxDw20DcxoCNVZk+kjDgJWN+dUts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doehyun Baek <doehyunbaek@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1249/2077] Docs/driver-api/uio-howto: document mmap_prepare callback
Date: Tue, 21 Jul 2026 17:15:22 +0200
Message-ID: <20260721152622.272749935@linuxfoundation.org>
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

From: Doehyun Baek <doehyunbaek@gmail.com>

[ Upstream commit de5c46373eb8148aa92c024cf30d26a6d495e278 ]

The UIO howto still documents an mmap callback in struct uio_info.
That field was replaced by mmap_prepare, which takes a struct
vm_area_desc.

A UIO driver following the current howto no longer builds because
struct uio_info has no mmap member. Update the documented callback
signature and matching text to match the current API.

Fixes: 933f05f58ac6 ("uio: replace deprecated mmap hook with mmap_prepare in uio_info")
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260622181821.1195257-1-doehyunbaek@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/uio-howto.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/uio-howto.rst b/Documentation/driver-api/uio-howto.rst
index 907ffa3b38f5b7..c08472dfbcfeb3 100644
--- a/Documentation/driver-api/uio-howto.rst
+++ b/Documentation/driver-api/uio-howto.rst
@@ -246,10 +246,10 @@ the members are required, others are optional.
    hardware interrupt number. The flags given here will be used in the
    call to :c:func:`request_irq()`.
 
--  ``int (*mmap)(struct uio_info *info, struct vm_area_struct *vma)``:
+-  ``int (*mmap_prepare)(struct uio_info *info, struct vm_area_desc *desc)``:
    Optional. If you need a special :c:func:`mmap()`
    function, you can set it here. If this pointer is not NULL, your
-   :c:func:`mmap()` will be called instead of the built-in one.
+   ``mmap_prepare`` will be called instead of the built-in one.
 
 -  ``int (*open)(struct uio_info *info, struct inode *inode)``:
    Optional. You might want to have your own :c:func:`open()`,
-- 
2.53.0



