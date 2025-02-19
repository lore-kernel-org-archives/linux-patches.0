Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC11DED5C;
	Wed, 19 Feb 2025 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955908; cv=none; b=ZpFfnIy84kcQrcKsk7GuaeEghUSikzBsmSSaSOfQjoGQtP9qzMxUFEA53kiUqAb5L78LUW5p+Um6J9qBrAORqcRS+whHXMW5XLRmh+chz6gWQMEEGRWGgDWGR0UNhxaG0iCWqHhWuhf8xYe0+DPPUFT95pIK7kH0mgS0NEx4kdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955908; c=relaxed/simple;
	bh=NPLljSztM/Xrsc8jaM2p+VnhX2uWeU6/ik+wxKQZmzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hr9jpjAy9MIbt+0LltqfzOeK9nkD3QfT0BP0wummPeggXLmUoBmin6WblsjsRenehTbYufH2RTnK8lpgRIYZa+QXfCq460ei1GCy3Acv4k39WaLZ2Sqs8A0zr/UA7OTa9DE8+USmap8IYaSAOaAyQ7Ys8SeebAkbxK+Xm0pRrrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SB5wgwIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB5wgwIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF79C4CED1;
	Wed, 19 Feb 2025 09:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955907;
	bh=NPLljSztM/Xrsc8jaM2p+VnhX2uWeU6/ik+wxKQZmzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SB5wgwIuERgvuSn7HUfyYE3JYjBUMEdQ8dwEdvqDN4p3iM8V+gwBT2RmpADoRgt6o
	 NSIjzVc20qqFRbpRlXwo1djGtw9RycimylrN3T0c96rITn3JyAIGiZxhppK0XetqO9
	 wq/Gr4v4WQzQHaKm+QJb1LobCkaMcxsI+Jaz792o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20N=C3=BCrnberger?= <stefan.nuernberger@cyberus-technology.de>
Subject: [PATCH 6.6 152/152] Revert "vfio/platform: check the bounds of read/write syscalls"
Date: Wed, 19 Feb 2025 09:29:25 +0100
Message-ID: <20250219082556.058707261@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 03844b1908114680ca35fa0a0aba3d906a6d78af.

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
 


