Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA136C0B5;
	Wed,  3 Dec 2025 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779520; cv=none; b=Ddrs1P79Bs6Lghz3qYrt2a86vNwySkMhp/pdulvimFkMV3XAKdQ2rpvRW4YFHYrerw3dQG764+SxRxJe2yHmHUKJVzJXVAwDl4sxC0t2mlIcXnmhvuJFOWmZLr5TX8IzWgTE8NVpp97gGfn50eTRHailO1HhAkSxIPSjy+IqCQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779520; c=relaxed/simple;
	bh=irpL39SRXca/GnfRK3ozUYLQq3oEcGwZ3bmgkOLRFoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1XSW2QTo4kRbTjs18Xh+atWzLbSnx6ZFdh+XuhtS+91M4utTyT2tYYQ0RG808WBdDN1wyyr/0nLFRLRMLLRtA5xU3NqM+rQgmFJSq+U6Nifa9qORk57+ptZLtfdiTDRxgp6zmy1j7+o16dgIbNZaSbki221nUY53DqhV/NuoSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs+OjjMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs+OjjMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD1FC4AF0B;
	Wed,  3 Dec 2025 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779520;
	bh=irpL39SRXca/GnfRK3ozUYLQq3oEcGwZ3bmgkOLRFoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs+OjjMMs0/Jhlid2JSUP8K2DAWuyZeykKoa9OsIR2S47+SEgB1Dp41DJqVfwf/Lx
	 IZYuXiT4Pwehf4F2N2nHWgjv3bK8GRp6K7F1Dw3D4rCEgcFlqLtSUTnHgnl4Q6ozWn
	 8rgeWmwsSjF19AFZC0mRjrhf9o14CzxLRbYpXxZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/568] sparc64: fix prototypes of reads[bwl]()
Date: Wed,  3 Dec 2025 16:24:11 +0100
Message-ID: <20251203152449.840678337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7205ef77dfe167df1b83aea28cf00fc02d662990 ]

Conventions for readsl() are the same as for readl() - any __iomem
pointer is acceptable, both const and volatile ones being OK.  Same
for readsb() and readsw().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com> # Making sparc64 subject prefix
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/io_64.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9303270b22f3c..f9d370324729e 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -250,19 +250,19 @@ void insl(unsigned long, void *, unsigned long);
 #define insw insw
 #define insl insl
 
-static inline void readsb(void __iomem *port, void *buf, unsigned long count)
+static inline void readsb(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insb((unsigned long __force)port, buf, count);
 }
 #define readsb readsb
 
-static inline void readsw(void __iomem *port, void *buf, unsigned long count)
+static inline void readsw(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insw((unsigned long __force)port, buf, count);
 }
 #define readsw readsw
 
-static inline void readsl(void __iomem *port, void *buf, unsigned long count)
+static inline void readsl(const volatile void __iomem *port, void *buf, unsigned long count)
 {
 	insl((unsigned long __force)port, buf, count);
 }
-- 
2.51.0



