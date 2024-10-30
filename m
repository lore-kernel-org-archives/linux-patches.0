Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE30E1E573B;
	Wed, 30 Oct 2024 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304901; cv=none; b=hf5oAa+AA3DrGFir1+H8jTe2y8JTTUVwQER3ZjvUjrT2k52y53aQfouzyKV7p+zcFfBYmAQQutGKYZxguFERD4ochIG5mfo69FCoDDk0xipBD51rznTmtxOKeYuYxlBPxcsbPc3iGhMbo/7LuLzFKurfsNISrt3oM+s0j4nDeWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304901; c=relaxed/simple;
	bh=N9werbf4NPq4LiWt3uHpAOCcksOcVaD4UmVzrTm7pkQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=byZBlXfppWDkEHrSSEudO0u6Qjhz3otOU+J/Ch1gELjlzxwkLV8toXcW5cqcyv2MmoBEmQTepRPDfNFPA3bn8S+BDJQDf1TSGH0W+y8YDGcDFAOdR0mdVVLTgH2DhjenmDfy5M4EDRSl6NYs2vawyca24k1QIV9XrK3PCb/+XVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgjWmxk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgjWmxk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6DCC4CECE;
	Wed, 30 Oct 2024 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730304901;
	bh=N9werbf4NPq4LiWt3uHpAOCcksOcVaD4UmVzrTm7pkQ=;
	h=From:Subject:Date:To:Cc:From;
	b=RgjWmxk+Ta/ZUEDhcnH9C0C5ZRjgiyQzdT+5BmFk7ppgAL8Us4vjU9vKAeZ/FeTXQ
	 yMbrwccUMzIck74xpvaiyL2kauWNWEdOVT2ZOJk89fh3s5eDnNtTP7KPuVB42IRYff
	 MjzkCg8hqwlhnb1dGmgEjMc4ooUTPS9OeTcz2IQP4ndjgVYPbtHcsoEeRnPoSPAeL8
	 zErMvqG5Mx55yaHiQXzw281/tDBJ8Ad5NquUG0EG4SMf7QqX1ZC6/4kVHd3hXwCPdM
	 mdINHTwUqJuKg5JnJKQz7vDUuv6Yr/NAzv/u+dWjeci3GdfqkevEGHsLm7y8rR9tfk
	 nbo87a8Tzoicg==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] kprobes: Adjustments for __counted_by addition
Date: Wed, 30 Oct 2024 09:14:47 -0700
Message-Id: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHdbImcC/x2N0QqDMAxFf0XyvIBGhblfGXtobdQwSKXthiL+u
 8HHA/fcc0DmJJzhVR2Q+C9Zoho0jwrGxenMKMEYqKauqWnA75qi54yTbDjGnxYO6Hd0qrG4Yja
 GwH7oiZ6+JbCfNbGN78b7c54XfUuhw3MAAAA=
X-Change-ID: 20241029-kprobes-fix-counted-by-annotation-ddeb95228b32
To: Masami Hiramatsu <mhiramat@kernel.org>, 
 Naveen N Rao <naveen@kernel.org>, 
 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=nathan@kernel.org;
 h=from:subject:message-id; bh=N9werbf4NPq4LiWt3uHpAOCcksOcVaD4UmVzrTm7pkQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlK0c1zP6c6qvn8SU5i3coa33LcfIrFhcmXy+e/Vb7i9
 dY0ZDdbRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjILndGho9Fpz/e0/l7TZK1
 efu2K27/aw7M+Hg0m+f70uuNHzfv+MTO8D/6nNjpRy2lnJe+OTyR+CN4aDHn5S18WnMu3F21gFn
 slTIjAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series addresses the issues that I brought up at [1]. The first
change is the actual functional fix and the second change is something I
noticed while auditing this code, which is related but tangential to the
actual fix, since the current code has a correct calculation.

This resolves the issue for me when testing both clang 19 and GCC 15
(tip of tree, which is the only version that has __counted_by support).

[1]: https://lore.kernel.org/20241022205557.GA3004519@thelio-3990X/

---
Nathan Chancellor (2):
      kprobes: Fix __get_insn_slot() after __counted_by annotation
      kprobes: Use struct_size() in __get_insn_slot()

 kernel/kprobes.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)
---
base-commit: b5f348cbce367d5dcd34bf2b6c02c39a5be3fb97
change-id: 20241029-kprobes-fix-counted-by-annotation-ddeb95228b32

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

