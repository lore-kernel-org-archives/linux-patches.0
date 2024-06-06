Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6576D19AD42;
	Thu,  6 Jun 2024 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683037; cv=none; b=FXiiEtH02khLuEDd6cx1TBk0agyCN6ZA2voRkFKCYLBcvB2OcEbjMe0DQOJcTwfED8X6dKaTGAAPluDJnHcp3BS3C8q5dSNKgV2LUqHwPQP37OpyEZ+4aQCKQrbfM3Uumfk/onfIjQ686NFAoZirEqCOo9hqTszZjImwPP/2sQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683037; c=relaxed/simple;
	bh=c6738XYR76zAoKb8JQp5nF4GH3YBVba9Avr7v02bFVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAwdeNHuJ7WGQEebvjT1k2CuFf7rfHsdBfDNuEfBXmVZBij1K/Z5fGpJi6KConbxMfzsB28oN7NyUAJwA6ky+zZ0PNxLJFKrJWcclZA1cezoCufFW/ZRb6r9BlVKpw3azJkxVYbRny4gExw7gklgtAMH9SQZTy9XMqi9qHUn8hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy7YN8Zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy7YN8Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A8C4AF62;
	Thu,  6 Jun 2024 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683037;
	bh=c6738XYR76zAoKb8JQp5nF4GH3YBVba9Avr7v02bFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zy7YN8ZfV6nEjBZX/Z2REaR8BPvxewvubJebGhLb5YEfG6Au+w1QfXaGZNM9QlltD
	 ibk9KfrOCjeFsUH2OdM9ssZzsxYLQ9mej7V3bS8ZvHO7M5qPfgsm8WpocxEmsxPe9e
	 Vqc5qAlndm/D1Ot2US59PXZXeU1VSpaVojfmTuO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 265/374] riscv: selftests: Add hwprobe binaries to .gitignore
Date: Thu,  6 Jun 2024 16:04:04 +0200
Message-ID: <20240606131700.776777584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit f8ea6ab92748e69216b44b07ea7213cb02070dba ]

The cbo and which-cpu hwprobe selftests leave their artifacts in the
kernel tree and end up being tracked by git. Add the binaries to the
hwprobe selftest .gitignore so this no longer happens.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: a29e2a48afe3 ("RISC-V: selftests: Add CBO tests")
Fixes: ef7d6abb2cf5 ("RISC-V: selftests: Add which-cpus hwprobe test")
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20240425-gitignore_hwprobe_artifacts-v1-1-dfc5a20da469@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/riscv/hwprobe/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/riscv/hwprobe/.gitignore b/tools/testing/selftests/riscv/hwprobe/.gitignore
index 8113dc3bdd03a..6e384e80ea1a8 100644
--- a/tools/testing/selftests/riscv/hwprobe/.gitignore
+++ b/tools/testing/selftests/riscv/hwprobe/.gitignore
@@ -1 +1,3 @@
 hwprobe
+cbo
+which-cpus
-- 
2.43.0



