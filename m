Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AFA188907;
	Mon,  2 Jun 2025 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875941; cv=none; b=WfLTKep4O6pocICj28KPbLe6t2CHN3d6gI/Yp5VkPCR+5kg7QbMt0iJlsXH0oJqKBG4vTZ1AQv5j4QdXD+FPKt4Qo8dos7gN1Uf9ZW8kj2ETVX75c5x7kgQEoXJgwssXrFZuAsPWl+AR5aQ89U+Ixn3Nz3LStyOJlKm9u3SUlzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875941; c=relaxed/simple;
	bh=IP2MFkzMjQ0Vd4sh/gBPkWKTPEfKtAcd7jbYeOQUKlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+PJxSlyj99s2cCIB52MTsaz2wx9TMm43JP+tDTGEGPtc7bZp2lHdgwtFkHKG8oc0yn+myJ1630OkaU9HZNu0SeCYmFcRwV4nmbf4+F1KUIekDl1C4T2jFU5eHj3Y2WLPIl4nteIJRR2lS/vyoV5gITwxFvRq3SDwcPrWFdhSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGrYfHya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGrYfHya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC19C4CEEB;
	Mon,  2 Jun 2025 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875941;
	bh=IP2MFkzMjQ0Vd4sh/gBPkWKTPEfKtAcd7jbYeOQUKlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGrYfHyamXTgaEfNDV1OrZr1oT/KAcxHOeb8LANkyqkwdJsdtslNnscVdmPV6hbjK
	 9axkBxUuG1dR1rYcUMWAX67YtK8Uycr9fKT/WVsjAf+Hckuub5IiHj8Ou4GGrJwj44
	 4GHEyW4Hj3X/FICggZo5YJi6cRUVaufKjWbRmPEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Jiang <jianghaoran@kylinos.cn>,
	zhangxi <zhangxi@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/207] samples/bpf: Fix compilation failure for samples/bpf on LoongArch Fedora
Date: Mon,  2 Jun 2025 15:46:19 +0200
Message-ID: <20250602134259.056974670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoran Jiang <jianghaoran@kylinos.cn>

[ Upstream commit 548762f05d19c5542db7590bcdfb9be1fb928376 ]

When building the latest samples/bpf on LoongArch Fedora

     make M=samples/bpf

There are compilation errors as follows:

In file included from ./linux/samples/bpf/sockex2_kern.c:2:
In file included from ./include/uapi/linux/in.h:25:
In file included from ./include/linux/socket.h:8:
In file included from ./include/linux/uio.h:9:
In file included from ./include/linux/thread_info.h:60:
In file included from ./arch/loongarch/include/asm/thread_info.h:15:
In file included from ./arch/loongarch/include/asm/processor.h:13:
In file included from ./arch/loongarch/include/asm/cpu-info.h:11:
./arch/loongarch/include/asm/loongarch.h:13:10: fatal error: 'larchintrin.h' file not found
         ^~~~~~~~~~~~~~~
1 error generated.

larchintrin.h is included in /usr/lib64/clang/14.0.6/include,
and the header file location is specified at compile time.

Test on LoongArch Fedora:
https://github.com/fedora-remix-loongarch/releases-info

Signed-off-by: Haoran Jiang <jianghaoran@kylinos.cn>
Signed-off-by: zhangxi <zhangxi@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250425095042.838824-1-jianghaoran@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index e2c9ea65df9fb..9edf83eb2a99d 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -438,7 +438,7 @@ $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
 		-I$(obj) -I$(srctree)/tools/testing/selftests/bpf/ \
-		-I$(LIBBPF_INCLUDE) \
+		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
 		-D__TARGET_ARCH_$(SRCARCH) -Wno-compare-distinct-pointer-types \
 		-Wno-gnu-variable-sized-type-not-at-end \
-- 
2.39.5



