Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC90289811;
	Fri, 17 Oct 2025 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714413; cv=none; b=uVuZu/CL6kVCEgDs4cAZHf7o6tVL708Qusreo0O3vO+2/zHUpnIIqub0DHDW9501gvJtjk+LkovewS+k021oTRoqkfjeJRRKyVgb7jC26kkfuHlfWbd3bhLrfBm6a4U7zx6CwRoGSryOJntdl78TtUFWAStEGolg0QT2Da5GeTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714413; c=relaxed/simple;
	bh=2SZ7uF8tmn4AoNitW1Va88hcl9D33RKuxgKkFscxFlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5Fts02lNK1uIljo4z9JF+aEwWPS3ZPqgcW7Z+JSyXSa7CNiyo+acTfm+/UKufr8wbt+IsWnClbBM7zx8ubyjcr08Rhwp5/3QXB0LygkjLR7IZZSyq5stLR0Vm+bnAD3knc+rzg65IAsSteQr3bCIzSjbZDPk4lRORW1mIo1nyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lroPbDl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lroPbDl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABEAC4CEE7;
	Fri, 17 Oct 2025 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714412;
	bh=2SZ7uF8tmn4AoNitW1Va88hcl9D33RKuxgKkFscxFlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lroPbDl+LJwwkmg6KCKCiQ3mgXea2eLPNO/uxOkjvZZz77WIdHVXpign9ZKSxnFCN
	 i3jnzraWzJcsthOAit36ggcoXPoAuJeJdbGAWyhlsNA0saIBglR6cx156vwc81EjGa
	 kL+oc4fqc5DkJQOmvMZnj1wJCubpAYNOLvqugOrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 103/277] media: cec: extron-da-hd-4k-plus: drop external-module make commands
Date: Fri, 17 Oct 2025 16:51:50 +0200
Message-ID: <20251017145150.892331494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile b/drivers/media/cec/usb/extron-da-hd-4k-plus/Makefile
index 2e8f7f60263f..08d58524419f 100644
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
-- 
2.51.0



