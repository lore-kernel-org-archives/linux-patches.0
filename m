Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9EC3ECBCF;
	Fri,  4 Sep 2026 06:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502295; cv=none; b=luoNl0FP1vmddOUv9r53R+0aZ1GyhuBuSgOmrfkiGmy2tfjDSVGHLzsKdFxVUa4Fk+FYbpQQ5u+CIbJoRRTPAFHQ210VQgL6LSTLSMf8+/M2/U9NA813E6OmidbmU7KOJFE0w5nT6lXq03H5Xek7NO38xhNUnHiaxMRVmMtV+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502295; c=relaxed/simple;
	bh=RIaBYXdo75B8uqMuGDw8i7OgNVgC8ykZRoNBe6CJ7/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9KDC7ILIQ1RQca+WCTlhIpFfxya4DQ0mqCqQdnMXJFvrzmiVOhSNRWwsGk6d+qVEAw4KERSMCLiMW6K90UiOQMKwjgqUCdBfzg6hNl8jIl//cdaK8KSaQVQzNkNqFhPJ6Kingn5x+UENKhoM1bMHrs8cj2A+lmEeqbGgEG2j7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJxgh6gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJxgh6gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669E41F00A3D;
	Fri,  4 Sep 2026 06:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502293;
	bh=4Dg9XYLc7gAgdqzdF+d1f/3ytE9wg1xfOUdPoM6b8aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJxgh6gzpb5VGQVd4DptMyGXKYPtjxvRshYHtpwT5+TZ9OFbAp2bK+GiMWxOgSHyo
	 E+Q3PEG+SxCutNTEhjUI0EsMLTUW5/Zj29s6rQj4kP48TGUcIrfWG0DibzXcvKe+4E
	 2Q6bLY/RXzOGLfHFZIaig+wQqdBr2pV2nDZlI8ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 157/403] ARM: 9477/1: Disable broken eBPF JIT on the Risc PC
Date: Fri,  4 Sep 2026 06:59:20 +0200
Message-ID: <20260904045738.422592872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 7e8ee82e69fde9d589272ec5e6f702358903be1f upstream.

The eBPF JIT unconditionally generates ldrh/strh instructions, which do
not function correctly on the Risc PC because its bus is unable to
signal half-word accesses. Work around this issue by disabling the eBPF
JIT when building for ARMv3 (the Risc PC is the only currently
supported machine whose kernel is built for ARMv3).

Comments from Ethan Nelson-Moore:

 From LKML: https://lore.kernel.org/all/CAD++jL=0qYGoygUwGEXQL7C_ROnC7kfpRv8RA+H5tNWwYu+pQA@mail.gmail.com/

 The commit message has been updated slightly relative to the version on LKML to clarify that the Risc PC is not actually ARMv3.

Fixes: 39c13c204bb1 ("arm: eBPF JIT compiler")
Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -93,7 +93,7 @@ config ARM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
-	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
+	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32 && !CPU_32v3
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_BUILDTIME_MCOUNT_SORT


