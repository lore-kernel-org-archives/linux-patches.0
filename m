Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89AF47124F;
	Sat, 12 Sep 2026 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220139; cv=none; b=jIKOnwTfjT5Noc+G+MOT3OpzmKvqJTsv7vqu2mDGWkyzundbd7Ut0z4q+UrGkfox+vRZIwmYk0sO+8I4+3Ob5flOqBBFNTL6QPK7E1NkMr2Hs/rAWH/6Z+ypnMn6Y1xnrCSwyKHu1uYNpV58j9D9Y2g+ceVb3bnow6JzlRsLlAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220139; c=relaxed/simple;
	bh=lGuAu3v19EpI9NpnarIiquyDkAm/4x4Ye1pWc+XI/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSYlciAlQGeIGSoXcT33hhO4I5ANK3zPaQXH+vaDPpI4bbfKlHLeIUEg9ls6azJPvHIrgf+tNvMOAEyuzF1tI00VE1IVBPHSRmx/p2CGCl8gQlNRELy425jLP8jaCxkp1y/ted+SpuiSqY5NiSKnyCgEswxn9bY96XmJRKAqxjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGDnqHpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGDnqHpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A2B1F000FF;
	Sat, 12 Sep 2026 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220138;
	bh=EcYxXVawrOVhCEQYhxSubG1/LoFeQaggu4Vw2hQNpaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGDnqHpgOWveEzQiOySE1PF26i0esj7mylO8QDyED75kg3Khu1eukb3nuoPURXvri
	 WVcYe/i1Fgu4Nw4qB1I7PiEmU/OY9F6hb16L+P82TcRdJhHuAi5fjsfub5ngF+4DTD
	 q2ykfALeH0QwK3ORNiQzjTUxU7eT3C+enetLfhJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.6 0114/1424] ARM: 9477/1: Disable broken eBPF JIT on the Risc PC
Date: Sat, 12 Sep 2026 08:42:26 +0200
Message-ID: <20260912065609.857094962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -87,7 +87,7 @@ config ARM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE
 	select HAVE_ARM_SMCCC if CPU_V7
-	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32
+	select HAVE_EBPF_JIT if !CPU_ENDIAN_BE32 && !CPU_32v3
 	select HAVE_CONTEXT_TRACKING_USER
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_BUILDTIME_MCOUNT_SORT


