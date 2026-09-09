Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7FC3D967A;
	Wed,  9 Sep 2026 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962594; cv=none; b=c15MzGRo5TwtkSMIbytSZLI42B4GPJSCyF3kVw0DvaBqBmCif4U783brzVlmDFtukYPZ4PVTuZ+7voi1soDtpvkMelI17693FYqPuO9Q9V5yJLxH9BmZoevr4omd3B0Khax9y1brP9AHUu/nV/ZV3Zqq+H1Gj+RDXbn+nZ3kd1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962594; c=relaxed/simple;
	bh=3iuCfRbkTovye5suX9azvYBotDAfEe7TCh3o+AjnDaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcp2+L8aMRpnC2YS8cEVB9sKsDYCg5B7P7DIWMVs4ZsXZRI+jUO3duE4hBimhNbph0jbRCmCbhakXbsNk1Vsr/Lv0LGgl1MVhuZPj/iAv/jPFh+zKgH5FtUFnsosSqpCH5bsal67RDMuxBD7zr3JcQxamuvOyCucCh8U1ZgLGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ7saXAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ7saXAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0324B1F00A3D;
	Wed,  9 Sep 2026 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962593;
	bh=8/pvwdVEeO0McVDOznyV1Rbzky3Uy7bzXOHTptIkB7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ7saXAwOvwI716tTsbNaBxB0yOJuzjWbGC8wcLdQNtkONuhH1zkpyc+YSgRR8iFh
	 4ZDCyWAfHUVXKwSH89e+U7/jTt5RIH3eXgKAS1sBqNDBYHL5NJ/8w1lFfelIyadFr4
	 dVhocZ0cGUoVCgHHiPCvr2uHjByTXTAPT1n5ReVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 342/556] LoongArch: Do not select HAVE_RUST when KASAN is enabled
Date: Wed,  9 Sep 2026 15:40:22 +0200
Message-ID: <20260909134242.686694965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 63b6a48c951d63bf39d44603ada48a987ccf66eb upstream.

After commit 2625480a1bf7 ("hardening: Default randstruct off with rust
for better allmodconfig support"), which allows Rust to be enabled for
allmodconfig, ARCH=loongarch allmodconfig starts failing with:

  error: kernel-address sanitizer is not supported for this target

  error: aborting due to 1 previous error

  make[4]: *** [rust/Makefile:741: rust/core.o] Error 1

For the same reason as the commit 84a0f7caafc679f7 ("ARM: Do not select
HAVE_RUST when KASAN is enabled"), do not select HAVE_RUST when KASAN
is enabled until the loongarch64-unknown-none-softfloat target in rustc
supports KASAN.

Cc: stable@vger.kernel.org
Fixes: 90868ff9cade ("LoongArch: Enable initial Rust support")
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -175,7 +175,7 @@ config LOONGARCH
 	select HAVE_RELIABLE_STACKTRACE if UNWINDER_ORC
 	select HAVE_RETHOOK
 	select HAVE_RSEQ
-	select HAVE_RUST
+	select HAVE_RUST if !KASAN
 	select HAVE_SAMPLE_FTRACE_DIRECT
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_SETUP_PER_CPU_AREA if NUMA


