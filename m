Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2298634389E
	for <patches@lists.linux.dev>; Thu, 28 May 2026 18:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779992013; cv=none; b=Gm4lJHpeyc9pioqKAmmcAeZLyVou5Ag/RpcwwLs9WaWsKgJcJtPnJeCqd376eTSniB1f291nCEtvWWkKblhgQF1iJ3lmecLtZQpwfhaFW8taAW+O4Lf7NCuH9wJX+lbubO+qqeFMep9WhZC7gNbJX6xmkLstGwU58p/krgMl+k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779992013; c=relaxed/simple;
	bh=olgS644GXBJ8sN4D9PdM4exux7HJbLCjd7+u5JgazSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsRqRFXrcSAV/lnvmT2BRTHHNB5HGPY0G8v7FZUfB48oQbE3BbjcTIhLkdkez3Kr61J5MuVfbuHcI6wQ5Sk6W0Qpmrkk/5fec4rZn6HrptSj7YPhtIzQWpbW8bfNQeD+erSRfx99cWIshlLNl3Vj5q59OLuuALKQV42wcQzpxwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hm4YJbN8; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hm4YJbN8"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bd9c3b550aso90257515ad.2
        for <patches@lists.linux.dev>; Thu, 28 May 2026 11:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779992011; x=1780596811; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dpxsk/T+HI611YA3BXnCwNdpS4kyHfnhJj1enlM0vqI=;
        b=hm4YJbN88YDA1J8hTKwXir5N8twgSO48/+wsXazQakDB8Z74665ORuaphKElcF2LKy
         60/64wPp5uLgWSGIm35TYAQPY9aA6l2grZYFK3mykCH3YSxbi4YvNpdxsL5Sy091pigf
         wO5s3y6xiNoTa/KZa8D4ZHJyEMngLVJDT09i32RqoQYh0/9dPSSNC2Jlrgilb3tCJvAO
         cod/jr/oExJ4Bxd4zBrjiOLp8FMgphfsgd0zrnNC2CEDsVAiVKOWlNPL1YuTl1RoxjKM
         9P6KzYnhfynfB40MTjH1HvHJb7G/7lrhqnVHf6YKiafFHcpMHwn7nkaSLi6VbMB8JQr1
         pUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779992011; x=1780596811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dpxsk/T+HI611YA3BXnCwNdpS4kyHfnhJj1enlM0vqI=;
        b=ZoWZqBSPTRxbNXMbsrCc2mrk5WthYJKhKCH6GrZ70CUVAtIsS1wujSeFI+VRaZ9Yjx
         OJQNKXpjVPQt7lLMNfzKYAhdTJWhrQ1DLxqE2DTWTxo0nR4rS4Y9DA1idVzE09ZsyHQp
         5o9FSXK653YCqxtDHKJhopL1jjUibY0VIWH9fFjBudxe/N+rRMXRFQd6mY2OU2WLk5Pj
         m4yzzzrPqToFKwKF3ge9s1B1plNEh5oZwxF3DP5lz1IGqNQ9r3atapmWkIx3T3kzW8Z7
         4pA7sFGLZC7QI91n31X3eMp4Zp0DlIcUhKI38Htnd5B5PPq04ii0fgwx7Q63MUZFtrJc
         9i5w==
X-Forwarded-Encrypted: i=1; AFNElJ8z9pAPxTMcvvMe7zEK2Udi+p8FREHYwJJ82BOyKuVG9MsUNyNKBECal4bupsBavD+Q8BJhyDFG@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6lajkvemtSeqZchrnJ3283rcV5Hwh4T+hAbYnL8pE4kbMwZRV
	tEyhw2tWNCJ3NsKB91GHq6G46FsANXos9jsbbrBAfbhtdV98my0zxKYWH6wK0dWnZw==
X-Gm-Gg: Acq92OG5GRKQyG2E/KYhw3XyWw58mQp/4+dqzq5uYmYy+d8zb7TJ5a8axCdCYAixo7L
	UWKyfpE19figiFumKeTX4dFUVJ6S1Myc7GAHGs9VDpKFdL9RPXiEcDK3cDrObZaJV/laREIDyus
	RNIKkuD2NLNeDJ4lQVfVgZsLk9w11nElkofX8frWwmGJou4KdvkXaBDfg9RIdg0Sq3U4Op96UsW
	gFTtcmsfS4VuLjxxItxroXriRAMLYijCLUJki7W6EuNTkX4eamUhbIasQewbbNzLUkUYUS/MqCR
	Nn+Yr17JWicT5Rfa3EnfflBIho/b7wgXDv2umhf3/dy/zz3oGFYybQDlDMDDDJTkfK3HyAEoKr+
	vLfGIW6FBHIRQxFSeDLwfUqEM0+9mzumy5ezkaWiky2CKA2PopNqDFwxvAnZ/SizEPtk6h7yJBv
	Gwx9wD0dlgRwykEkkdpjMN/n9q9vL5fjOGp9b0fGnMyxGJNfIIRnSG9iZLeuMTsBui42KHyD92
X-Received: by 2002:a17:902:c94a:b0:2bd:9728:5e42 with SMTP id d9443c01a7336-2beb074b967mr322151685ad.31.1779992011034;
        Thu, 28 May 2026 11:13:31 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf1e38a934sm174895ad.0.2026.05.28.11.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 11:13:30 -0700 (PDT)
Date: Thu, 28 May 2026 18:13:26 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 06/11] selftests: Fix arm64 IO barriers to match kernel
Message-ID: <ahiFxtmspbETiqWw@google.com>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
 <6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>

On 2026-05-15 02:30 PM, Jason Gunthorpe wrote:
> The tools/include readl/writel MMIO accessors on arm64 use
> inner-shareable barriers (dmb ish) while the kernel uses
> outer-shareable (dmb osh).  Fix them to match.
> 
> Add __io_bw() and __io_ar() definitions matching the kernel's
> arch/arm64/include/asm/io.h, including the dummy control dependency
> in __io_ar() that orders MMIO reads against all subsequent
> instructions.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  tools/arch/arm64/include/asm/barrier.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/arch/arm64/include/asm/barrier.h b/tools/arch/arm64/include/asm/barrier.h
> index abdc64fc3c70f0..3f7fcb2a27541e 100644
> --- a/tools/arch/arm64/include/asm/barrier.h
> +++ b/tools/arch/arm64/include/asm/barrier.h
> @@ -28,6 +28,20 @@
>  #define dma_rmb()	asm volatile("dmb oshld" ::: "memory")
>  #define dma_wmb()	asm volatile("dmb oshst" ::: "memory")
>  
> +/* Match arch/arm64/include/asm/io.h: use osh barriers for device MMIO */
> +#define __io_bw()	dma_wmb()
> +#define __io_ar(v)							\
> +({									\
> +	unsigned long tmp;						\
> +									\
> +	dma_rmb();							\
> +									\
> +	asm volatile("eor	%0, %1, %1\n"				\
> +		     "cbnz	%0, ."					\
> +		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
> +		     : "memory");					\
> +})
> +

Let's put these in tools/arch/arm64/include/asm/io.h so that the tools
headers are more aligned with the kernel headers, and so that the arm64
io.h overrides are done in the same way as the x86 overrides in
tools/arch/x86/include/asm/io.h.

Something like this (untested):

diff --git a/tools/arch/arm64/include/asm/io.h b/tools/arch/arm64/include/asm/io.h
new file mode 100644
index 000000000000..8a5de4fe2afd
--- /dev/null
+++ b/tools/arch/arm64/include/asm/io.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_ARM64_IO_H
+#define _TOOLS_ASM_ARM64_IO_H
+
+#include <asm/barrier.h>
+
+#define __io_bw()      dma_wmb()
+#define __io_ar(v)                                                     \
+({                                                                     \
+       unsigned long tmp;                                              \
+                                                                       \
+       dma_rmb();                                                      \
+                                                                       \
+       asm volatile("eor       %0, %1, %1\n"                           \
+                    "cbnz      %0, ."                                  \
+                    : "=r" (tmp) : "r" ((unsigned long)(v))            \
+                    : "memory");                                       \
+})
+
+#include <asm-generic/io.h>
+
+#endif /* _TOOLS_ASM_ARM64_IO_H */
diff --git a/tools/include/asm/io.h b/tools/include/asm/io.h
index eed5066f25c4..1090a2c387f4 100644
--- a/tools/include/asm/io.h
+++ b/tools/include/asm/io.h
@@ -4,6 +4,8 @@

 #if defined(__i386__) || defined(__x86_64__)
 #include "../../arch/x86/include/asm/io.h"
+#elif defined(__aarch64__)
+#include "../../arch/arm64/include/asm/io.h"
 #else
 #include <asm-generic/io.h>
 #endif


>  #define smp_store_release(p, v)						\
>  do {									\
>  	union { typeof(*p) __val; char __c[1]; } __u =			\
> -- 
> 2.43.0
> 
