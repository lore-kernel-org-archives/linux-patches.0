Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51028153814;
	Mon,  6 Jan 2025 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177897; cv=none; b=Ix0BWbQbH5DZzDQHL9LQ0mxLZ6I4W9qqqeun2SVXvOurJYm+GE138t6bkAwYyp+1rxLhCxwS807Na8sBiFjvMgKbZ5TruzSkvoHOqmIWdhe9Y5JsKN/ChGSTqgNls/FvcgD+rHzj9kH5wHhoEyaz2evci/zcNXfu+JwNbdq6hlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177897; c=relaxed/simple;
	bh=qdO9936j/aymQ+lq/Er6DrfqEM5twxyTlhKNwur+5r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiLFv9PZHCGRkyDBIeD+xq6vos2659zetNztpM3QChRBJ3J5Txs5XgxUKxK0hAFTS0AMycW5xXRp9I0UkNpP/CoyVqrYojc+B3SfS6LvTcw9mi1ypRHhwAXeJjXJ0GOQZ3iJOuiXi4FONGb2m4TgZBhLGMzp7Nb7nPCe+dO+xPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n24JPYwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n24JPYwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADABC4CED2;
	Mon,  6 Jan 2025 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177897;
	bh=qdO9936j/aymQ+lq/Er6DrfqEM5twxyTlhKNwur+5r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n24JPYwMNkLSIkE+wgaLxCgnoChJBs1Jil4vNXee0na/4PLQSjkJ3RhKb8uJvf7/O
	 P+VUWhElzvv6BCokAMdEAa6Mh2PN4ZiynN+IcxZYm6f7nz2hmNdDJAScB+RDUYPuJd
	 uHN2aAzkGaVLylCuw6ydo+6/2X8mXKRHXOWH9udo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-snps-arc@lists.infradead.org,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/156] ARC: build: Use __force to suppress per-CPU cmpxchg warnings
Date: Mon,  6 Jan 2025 16:16:20 +0100
Message-ID: <20250106151145.265124920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 1e8af9f04346ecc0bccf0c53b728fc8eb3490a28 ]

Currently, the cast of the first argument to cmpxchg_emu_u8() drops the
__percpu address-space designator, which results in sparse complaints
when applying cmpxchg() to per-CPU variables in ARC.  Therefore, use
__force to suppress these complaints, given that this does not pertain
to cmpxchg() semantics, which are plently well-defined on variables in
general, whether per-CPU or otherwise.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409251336.ToC0TvWB-lkp@intel.com/
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: <linux-snps-arc@lists.infradead.org>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/include/asm/cmpxchg.h b/arch/arc/include/asm/cmpxchg.h
index 58045c898340..76f43db0890f 100644
--- a/arch/arc/include/asm/cmpxchg.h
+++ b/arch/arc/include/asm/cmpxchg.h
@@ -48,7 +48,7 @@
 									\
 	switch(sizeof((_p_))) {						\
 	case 1:								\
-		_prev_ = (__typeof__(*(ptr)))cmpxchg_emu_u8((volatile u8 *)_p_, (uintptr_t)_o_, (uintptr_t)_n_);	\
+		_prev_ = (__typeof__(*(ptr)))cmpxchg_emu_u8((volatile u8 *__force)_p_, (uintptr_t)_o_, (uintptr_t)_n_);	\
 		break;							\
 	case 4:								\
 		_prev_ = __cmpxchg(_p_, _o_, _n_);			\
-- 
2.39.5



