Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30B7199935;
	Tue, 26 Aug 2025 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208387; cv=none; b=Vuokx1Ai8AeBhAFrkMuCK+VjR5gus5S6msc3a0IVbCqmKZ3Ol5NQGpjNuzwZsBmuSS2DjOYLYWJVnTP2s94O8zB5SOaEUTHcNfSJs2gfPY0xRaZVT3byKkU1SZZ6NiPApU7HSkYd7rJI6NeYd27JNCvyvBKf3mHgptT8Ub3xOHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208387; c=relaxed/simple;
	bh=iXXPCgznM7fYb37kJe+fpJMP63Hdc0Nc/fjA1G1/mvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyEEZEcEPN5Ij/9GInt7HK2J9Kr8h17zeJbHCk2MMbR0b88/rktP72Z1PNxpe3Tzw1cGJS2XQt7yOo4oJBomL6NlKZ6msXWr1f559F1fC9XTzqn1IF/irHW7BGB7MPmf6aBcKgE/NtnvrQi5u1PWr7tp/S9hUd3Bv3jzmNBxt4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1Vp7Q4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1Vp7Q4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD419C4CEF1;
	Tue, 26 Aug 2025 11:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208387;
	bh=iXXPCgznM7fYb37kJe+fpJMP63Hdc0Nc/fjA1G1/mvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1Vp7Q4jU9PZzNKW49rTYoFpCAP0LAuSbrZHV2dE5ToCg4VZ1HSNTckHIyRqtn9eK
	 u8W1meX1XXRYUMjyCVw+s6ZQyW2CjGGbHzYECAXR/SpHulR+5tZS625HzZ2mO2SgbT
	 B5apG6UkHf4cUFy3oVfvvHa3vN7F9Nvy2QBS5csM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 091/322] parisc: Drop WARN_ON_ONCE() from flush_cache_vmap
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826110917.916414798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 4eab1c27ce1f0e89ab67b01bf1e4e4c75215708a upstream.

I have observed warning to occassionally trigger.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -841,7 +841,7 @@ void flush_cache_vmap(unsigned long star
 	}
 
 	vm = find_vm_area((void *)start);
-	if (WARN_ON_ONCE(!vm)) {
+	if (!vm) {
 		flush_cache_all();
 		return;
 	}


