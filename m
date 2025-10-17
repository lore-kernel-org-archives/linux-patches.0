Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4C232C931;
	Fri, 17 Oct 2025 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715396; cv=none; b=bKWJ0lBSoHmF5vzx+275QEpqACrVdULPDElpOJh5c1u0r8umigxxLmZ3ZfZbSOcQPTYqqWppml2sQgfiUAbAwIitrCwiXJrULtxUYuBFHsskhi+aCrHjz/gF6sho+XZJkoI8TKNIc1iqbh0OqFNIhfVlaxrnqu82X8SRJFB4+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715396; c=relaxed/simple;
	bh=1RBgBjGESXyPbFHih0+6Wm7ubliVLyFhA/lie/xG3nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1qe+Bd2ULuClHUdc4yfbpOdtU5QdOSmFZxfAQZyAP7icknLstcemgzS5Ijc4vp/mwacWN+6JWb+vOveNO5UkIUPNXd2Gb4jLhg0FRMJZygQ+7NS9KAgF8TRZwE3tIRVIJWDP3PVpZnf/ufHzOpr1+U6fhWCvZWpNnNhanjPVY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/60ykfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/60ykfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B585C4CEE7;
	Fri, 17 Oct 2025 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715395;
	bh=1RBgBjGESXyPbFHih0+6Wm7ubliVLyFhA/lie/xG3nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/60ykfY3rtjvLSfwK0kbNQsCkw5EpR5wb6Nj2iKBRi5TJLanqgsCS1DTmkEuZqEV
	 +O6wDH2AFLLRx0kkai2G2v4tQYx2ecWL8wj2lVu18E0V/YSREcod1zR0nXdEKyWeJd
	 bKxJ9pN/5HFP0IpxXDR9702g1Tua6AhYwxhnkKkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 168/371] media: cec: extron-da-hd-4k-plus: drop external-module make commands
Date: Fri, 17 Oct 2025 16:52:23 +0200
Message-ID: <20251017145208.011029132@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit d5d12cc03e501c38925e544abe44d5bfe23dc930 upstream.

Delete the external-module style Makefile commands. They are not needed
for in-tree modules.

This is the only Makefile in the kernel tree (aside from tools/ and
samples/) that uses this Makefile style.

The same files are built with or without this patch.

Fixes: 056f2821b631 ("media: cec: extron-da-hd-4k-plus: add the Extron DA HD 4K Plus CEC driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile
+++ b/drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile
@@ -1,8 +1,2 @@
 extron-da-hd-4k-plus-cec-objs := extron-da-hd-4k-plus.o cec-splitter.o
 obj-$(CONFIG_USB_EXTRON_DA_HD_4K_PLUS_CEC) := extron-da-hd-4k-plus-cec.o
-
-all:
-	$(MAKE) -C $(KDIR) M=$(shell pwd) modules
-
-install:
-	$(MAKE) -C $(KDIR) M=$(shell pwd) modules_install


