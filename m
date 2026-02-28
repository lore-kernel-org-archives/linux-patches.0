Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644EC36C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302291; cv=none; b=NTbNDUbV5fFRYwqpbgOBWRsh8RiReestxfU72NulnGzmMCvErVOWLdy/EDlNgGwo7JNKwn1wnkLdp4VUfgHudlEgayWqNae9Qwy5kRQAY+cDs5tE1mGTdPz8/RDBJJulP6TCUTaJSvQTAxU6DsS5s+qOfd28cvzJDTOwX8h2wNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302291; c=relaxed/simple;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEO+URqXEfJkaHT4ytdxm6s29lQSZi0qrPoAefhW9O953aPEjw8Y8K+cuAs2DWx8QrQI+pchFhlMElSn/25QQ6+d+gHN19AUu479S7qIs+MndFDPpocTUGOSgOJ5n4hTPpEss2XiYp4tDwMmJJCs5wFb5WpO+x9E3B3KN42e2KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xs0bT9ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xs0bT9ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1A9C116D0;
	Sat, 28 Feb 2026 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302291;
	bh=vc2MXFmhwzG9O6jwkKk3BJmryInIB0popl+gqWgn6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs0bT9objA/NTzRfhfVSzky2ilQ7LHYrZ3XjkUs96T15EKkleRe7ubByhUj6e/i/4
	 zdknbPL8mS+otJhjgxZOcEkpDZXJbi9aZIP4JCtPJffV2HZxoUVhZ4V738vbAvZm9P
	 kqf3tw29Ce/0zW6AelIXlXuXzFK6SiqQMewyyDRWecY2BkSvEJolAiuC1zlAs+eB4E
	 iWWP9s//TJL1jEFGTZNIHoChVlRqdRGQrBNJyp1Xmf9t9NCMJtoex38WfQg2eDd2oP
	 /3QYSJKSpobPRgeRwcz22ajm/zVPud/Ie+zg/FBcJ1Op7f5S1ECTFEuK3ooc1tlexf
	 Wgpv7fozAhvAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/232] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Sat, 28 Feb 2026 13:07:36 -0500
Message-ID: <20260228181127.1592657-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit b5c23a4d291d2ac1dfdd574a68a3a68c8da3069e ]

It seems like, after the request_mem_region(), the corresponding
release_mem_region() must take the same size. This was done
in (now removed due to previous refactoring) charlcd_remove()
but not in the error path in charlcd_probe().

Fixes: ce8962455e90 ("ARM: 6214/2: driver for the character LCD found in ARM refdesigns")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/arm-charlcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/auxdisplay/arm-charlcd.c b/drivers/auxdisplay/arm-charlcd.c
index 0b1c99cca7334..f418b133ee752 100644
--- a/drivers/auxdisplay/arm-charlcd.c
+++ b/drivers/auxdisplay/arm-charlcd.c
@@ -323,7 +323,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 out_no_irq:
 	iounmap(lcd->virtbase);
 out_no_memregion:
-	release_mem_region(lcd->phybase, SZ_4K);
+	release_mem_region(lcd->phybase, lcd->physize);
 out_no_resource:
 	kfree(lcd);
 	return ret;
-- 
2.51.0

