Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705344;
	b=NTWYlJPw0IQ80vzfBkURM6W6cc04Uw+YaLNFyVZVYuPfHztqkk3oOmXRsTFwXGaL9QTJ
	 4OqzUvYBK1dzcUjYVM07/NFTDh+BT9VJZp5aeHeGEQYPjC2n3vYebSc7ZRBNl8bcdUkXO
	 z/qPzSSSXZABI9pld0EHo9x07ScFYvz6Mrd7adED08jE9wXhv7dhW11AGENKwCvHSCVS1
	 nZNj/XYD+NwLSSCvtzOh1W1YIzA6idiZ6IDT+2bokqHPZfmcYqi+CLC1GA/TQEG8xhFct
	 yFbnJ6v7nJKwWx4IjJN3B22faBQq1xJiz1k7PMe12AtYmBGLgUsgFYuoWtKF1BflIyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=irf1a3EhG7g7LWZbsBb2XbQPBC/r+odusN4aR53eoc0=;
	b=KzUfyn8rSWYoaEo+U1cKF1gW4PyqD8nt8LFt9C0zTjdKT/YUAyXXCHVEaFoFEGwoEJBX
	 oESGrDZpqL06LUfj3BqlD4tq0/FDYYq6p1gB0OQRT1vVN+5cKrMwszwC83g1a0uT+jkSD
	 Jmqv2n08UAukP8L2WFYkQdWOQWN6Crwd9VCCI9W7V3DBkUJ2+fm1Ngdmq7BaNV9N9TizS
	 U3WfG4uING3vNUz8xbhjcT2WMM9T7gM3moKCuazAPyC/XtJplHRnUIpIt89tQ7JjbYi3h
	 Kfgkj4c7jx8/YW82ThITiia5UHjzm4+0Yr26Ccj25bZZ/fyq8p9szamn5uJSA77lXmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVli0py6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07586606A686;
	Thu, 26 Nov 2026 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVli0py6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA71F000EF;
	Thu, 26 Nov 2026 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705343;
	bh=irf1a3EhG7g7LWZbsBb2XbQPBC/r+odusN4aR53eoc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVli0py6Wxwqk9FghaRoSmeIrBSrlgMBgknYzd6Pdp0bFHhzfZjGT3DqwXFASeVUa
	 jdfGs4Q5U4sSsFtXerNNRrN0vwQzb5B9Iciguc/bMfHC/Q7eSrk4leksaXq4vGMNGH
	 X12wVEh9wcSOfPF2jExcKdiZ8TgLTRr38MLdRePI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/319] docs, kprobes: Fix bracket
Date: Thu, 26 Nov 2026 15:38:52 +0100
Message-ID: <20261126144010.448593393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Ebner <manuelebnerli@mailbox.org>

[ Upstream commit b91a5c16996d089cd07ceaf33b5a621cb94c2c2f ]

Remove needless ')'

Link: https://lore.kernel.org/all/20261112085511.690900-2-manuelebnerli@mailbox.org/

Fixes: a1dac767622c ("kprobes.txt: standardize document format")
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/kprobes.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace/kprobes.rst b/Documentation/trace/kprobes.rst
index 998149ce2fd95..1aebcd752d0fe 100644
--- a/Documentation/trace/kprobes.rst
+++ b/Documentation/trace/kprobes.rst
@@ -31,7 +31,7 @@ can trap at almost any kernel code address [1]_, specifying a handler
 routine to be invoked when the breakpoint is hit.
 
 .. [1] some parts of the kernel code can not be trapped, see
-       :ref:`kprobes_blacklist`)
+       :ref:`kprobes_blacklist`
 
 There are currently two types of probes: kprobes, and kretprobes
 (also called return probes).  A kprobe can be inserted on virtually
-- 
2.53.0



