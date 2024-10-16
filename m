Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C38C5478E;
	Wed, 16 Oct 2024 21:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113166; cv=none; b=EnsDOR9ilktTKGeKsbz2kBy2CVcAa/+ibAI+xoJn6v5GPSQ1zemo5K/uoYYbJlzfkUuYic323z4XD1gTaBR+r/3msXq6JWeGNnWVarm+mtKzHYHheGd0HPEpSMJY2mKmAI+BID1S54oh63yI2hutJlukySIkpKFtYN/g74wIbZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113166; c=relaxed/simple;
	bh=gvPBuO8nQ4vzn798wSf1AJborcfkCDs17JO72U1ptd8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DCnW17yroQQ2qLoB7o/WWFvrWao5ta5Ke8SBtsBFwTcTZ5wWqr2MrwVcyi2sJfi9vZro2Wp0cSFtRz8Z30BcI+N1N7SBbSGslkwh0wxf9HJ92LpP0iqc7JaLPI4tdWY1yBj2o0beli+T8S+4yKwkwOvjMPErFr8yQW2p/Nx9euQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FebUSwRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FebUSwRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574A9C4CEC5;
	Wed, 16 Oct 2024 21:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729113166;
	bh=gvPBuO8nQ4vzn798wSf1AJborcfkCDs17JO72U1ptd8=;
	h=From:Subject:Date:To:Cc:From;
	b=FebUSwRQvl0PbE0ZXrj2/PrRxH8Ez7cUli8GdVZ5DIYMqU7jkpTYmHeodo3RsPYK7
	 EfIseQ3Bkt1vQiawerXjuZmwrixuKeGOohUIKDZstNh7cxb+zstqyx1lYqWy760NuS
	 nJY5hyWc7IHGBUyLzsY94gRHgUuoFk6kv48OhwI8paK9uj9eVUCieeXQkJuPvPoKxk
	 SsEOZUTsnP4Y0p95pIcdEsdqoCmDUQc4Jdq4unoa7dHYq7gXhB3DrF4SjZ4qdri0W4
	 cTj2DQQeow7NGmQw+HVqZwCR2wrAsa4UNJVhWVl/7/RfWIP9HEICk3zaryibmkgPRJ
	 rAZDzx1FmtZcA==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] um: Fix a couple of issues with stub_exe when building
 with clang
Date: Wed, 16 Oct 2024 14:12:36 -0700
Message-Id: <20241016-uml-fix-stub_exe-clang-v1-0-3d6381dc5a78@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEQsEGcC/x2M7QpAQBAAX0X729bduZBXkXTOYstXd0jJu9v8n
 JqZByIFpghV8kCgiyNvq4BOE/CTW0dC7oXBKGO10jmey4wD3xiPs2vpJvSzaOi7UtnC2KLPHEi
 8BxLrH9fN+37kp116aAAAAA==
X-Change-ID: 20241016-uml-fix-stub_exe-clang-cb8047247d3a
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Benjamin Berg <benjamin.berg@intel.com>, linux-um@lists.infradead.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=660; i=nathan@kernel.org;
 h=from:subject:message-id; bh=gvPBuO8nQ4vzn798wSf1AJborcfkCDs17JO72U1ptd8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkCOj6mByZtudzw1bjhwXq5N+taffY8vMQ0JdVsWtESN
 4sVBen3OkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE1OIY/kpnxObtuLc5RmNF
 xrLV/1Nm2uefZHXqN1qYc0h57veoX9EMf8W4fiXPq0qdbiU80UrY73a4MK/dR/vJZjwsU/xXPPe
 5yQUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

This series fixes a couple of issues I see when building ARCH=um
defconfig with LLVM=1 after commit 32e8eaf263d9 ("um: use execveat to
create userspace MMs") in -next.

This passes my basic build and boot testing with both GCC and clang.

---
Nathan Chancellor (2):
      um: Fix passing '-n' to linker for stub_exe
      um: Disable auto variable initialization for stub_exe.c

 arch/um/kernel/skas/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
---
base-commit: 41ab5fe7471ff38d2909d1c93b88197a89c6a00f
change-id: 20241016-uml-fix-stub_exe-clang-cb8047247d3a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

