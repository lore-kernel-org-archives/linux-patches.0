Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373311E377E;
	Wed, 19 Feb 2025 08:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954688; cv=none; b=F4YukpJiowD9mTWslEmU7Avz17bfINfyWwpZ9ZcB0eFyuotb1KCQqUu18cdpyUk8ZrZzwlyXKSbN0MvKrVjEio7pic5I1Wqi9fEDZMnkds7iKQD9pQ7VejZW1ILSaY+licZh/7KnV2dbHG7DM42dGc8LK3M9UICfbv7s19v41Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954688; c=relaxed/simple;
	bh=aH7U1r/lRRb77se5XmzS4WvvCwnTzDh7LMB/FowWVo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuMmmvKWkNpjEkqd4MqXOMmQYlnb78hskVjIm4lgyc75U1PJ3bjx5MlZKkSvl5KCXqn6xfOqLNmYbUTNIgREAkO+o0F2PU6w8Z6B6r06eIFldpnBaQOKTYqo8YZCefooKM1h+SajkKZIl+uS2KbETz+X2qA4TTXn7E5Q0h4ULQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwHRr+yX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwHRr+yX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8743C4CED1;
	Wed, 19 Feb 2025 08:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954688;
	bh=aH7U1r/lRRb77se5XmzS4WvvCwnTzDh7LMB/FowWVo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwHRr+yX5Wuh2FPoAJPVlaL86wZTmIHXlycV2RoszWDFMMuvJBUvf9lwmQ1Z/vc9E
	 75MOagSrozxRbkEg54aQuP1Eo7tsWaBJ7lZi248vCpcZ0N2f7o+1ItWSN6mWAk9Sx0
	 5OtkLqTy10ZmNeZslAL8Pl5x9wdUy/PgFq0mZSwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20N=C3=BCrnberger?= <stefan.nuernberger@cyberus-technology.de>
Subject: [PATCH 6.13 274/274] Revert "vfio/platform: check the bounds of read/write syscalls"
Date: Wed, 19 Feb 2025 09:28:48 +0100
Message-ID: <20250219082620.309114787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 198090eb6f5f094cf3a268c3c30ef1e9c84a6dbe.

It had been committed multiple times to the tree, and isn't needed
again.

Link: https://lore.kernel.org/r/a082db2605514513a0a8568382d5bd2b6f1877a0.camel@cyberus-technology.de
Reported-by: Stefan Nürnberger <stefan.nuernberger@cyberus-technology.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/platform/vfio_platform_common.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -393,11 +393,6 @@ static ssize_t vfio_platform_read_mmio(s
 
 	count = min_t(size_t, count, reg->size - off);
 
-	if (off >= reg->size)
-		return -EINVAL;
-
-	count = min_t(size_t, count, reg->size - off);
-
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
@@ -479,11 +474,6 @@ static ssize_t vfio_platform_write_mmio(
 
 	if (off >= reg->size)
 		return -EINVAL;
-
-	count = min_t(size_t, count, reg->size - off);
-
-	if (off >= reg->size)
-		return -EINVAL;
 
 	count = min_t(size_t, count, reg->size - off);
 


