Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84999356746;
	Tue, 21 Jul 2026 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663804; cv=none; b=kZE7jx5jr6afZEiY3AIGR5/gRLIJzSipbpnWXkq9Vt7Ab8EIR/hkkGuNLqIVFRIQTfE7aK+Q6FrtMm8L3J0ILdQbVXdLKnUSp3qweGLjTqRrVxzyOMkP7hqlMXlpwCL8XwMUI6xXZbu/pFoHx5NOiJdlHkt7W+KcKHf4mjIfswE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663804; c=relaxed/simple;
	bh=jP2T4aL8OKumVsX8+1oK0to4lkPCZhP4c0gv/C50+P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4Rz2kJqCgdBAw58nZbb6GBUjqzuIjOKD2QvLECIR2air+rbUZ2A2QbmCsVkPI5HmQPxzp1LrxpH4GLQAzSHSPhvk4pCymU9VK9RvsY4M9xoKOwdiIPQxGXDVbq5sb+S6GqZhtza+vpew1ONU5gxSCnwR9KQn3bMiajFqatoPCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wc4w+zBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wc4w+zBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C3B1F000E9;
	Tue, 21 Jul 2026 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663803;
	bh=S0oFxWeGLsvLqoQNBhCo/hvmh243bL4T4mSihpUVf9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wc4w+zBLviC2ix0xLFNd4uBaJfqMfvNmlmEc4nRqVFTdoXNOT9F8g5Z10Oved0IH/
	 Pk87oMk8XJuSutbzw0aWee3NopWvodOCjHkDL9QorSq66fNiqOKLfcDXJN5rPuq1H/
	 cE/zyluUppzdChs36N3mBPDam/mBf+1yJtn/cc+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 0960/1276] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152507.509708060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

commit 357e3b8e3a8769ba36eb8ec5e053e4825f1a9329 upstream.

The mtd_info contains a struct device, which must be linked to its
parent. Without this, the initialization of the MTD fails with a NULL
pointer dereference.

Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -547,6 +547,7 @@ static void vmu_queryblocks(struct maple
 	mpart->partition = card->partition;
 	mtd_cur->priv = mpart;
 	mtd_cur->owner = THIS_MODULE;
+	mtd_cur->dev.parent = &mdev->dev;
 
 	pcache = kzalloc(sizeof(struct vmu_cache), GFP_KERNEL);
 	if (!pcache)


