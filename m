Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952365380A;
	Tue, 23 Jan 2024 00:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969864; cv=none; b=ppfOhNoG25lCzvHKfVWpEyAPkhBrtheFbK1qoPqpDMYAgQCSGVoQPn+ymkMye+DCNkAs1adUJIZMf5SdXJ1wRKvY5/btAnoNm0PzUaZswCo7cQVaDcWPg2fCTPfLCObfqnrL/YyBkNTHXwqAW8WolY+11vY3mNJvduLNwPAJVew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969864; c=relaxed/simple;
	bh=UGspx9P/friGUN2Sh0gUXvQ4/oJrOvJ+qklG16qHagc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcXIXGM3X7sXtLRO49LdOPOLZURFpMhAgkfMLCxecl93DwRwYhrkQ9NfHtYWlca3uJIGfe4qvklcyHkbnkZGJP0L5xSWdmZZlranX9OLzqtx96seDb5fR5IJY45A/wJP4aM0vyn4Yy1PGmZnvexlw0KjXhtHGgDKvClK5Gb8MxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vO3ZjwPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vO3ZjwPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A15C43394;
	Tue, 23 Jan 2024 00:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969864;
	bh=UGspx9P/friGUN2Sh0gUXvQ4/oJrOvJ+qklG16qHagc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vO3ZjwPmcJKALhyfqznQb7A1kJcFVsAMuI2PWPNPoTRkmqsaXcnTJpJad7+DYHu96
	 jDMdoVHSfiU6ZdbddJhMSyquaeCmkA7U5EkNs28xpFdHdk1nILeD0aCsvuUH3zkRU8
	 nSlhDZ4ETRZN8SCMXBl5fMfdz2AjA1BwpkGgo0F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 493/641] um: virt-pci: fix platform map offset
Date: Mon, 22 Jan 2024 15:56:37 -0800
Message-ID: <20240122235833.502628712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 32253f00ac8a8073bf6db4bfe9d6511cc93c4aef ]

The offset is currently always zero so the backend can't distinguish
between accesses to different ioremapped areas.

Fixes: 522c532c4fe7 ("virt-pci: add platform bus support")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index ffe2ee8a0246..97a37c062997 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -971,7 +971,7 @@ static long um_pci_map_platform(unsigned long offset, size_t size,
 	*ops = &um_pci_device_bar_ops;
 	*priv = &um_pci_platform_device->resptr[0];
 
-	return 0;
+	return offset;
 }
 
 static const struct logic_iomem_region_ops um_pci_platform_ops = {
-- 
2.43.0



