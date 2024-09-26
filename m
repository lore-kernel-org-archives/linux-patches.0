Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E822C1A7AD8
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 09:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727343544; cv=none; b=GHSXEAhkpe50EBV9UYcCtLRHB85B/VpmB4KizIQpL4T5WMeVxOTv6CuIS/0aeWQXZzwt61Be1N/ODNjqwDC0hwOEyVN7m4Ur56MZMTLnT7Yx7W6HJWfWx6qaXxs+SWKJD38RZql9mI8AQUZHDc6o0QTbDhvUXmL0Om6VO2g/bSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727343544; c=relaxed/simple;
	bh=44hQx7AWS11P7gR6JRYZM6ZBLNvn/Mupzf7ndbZKPl0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sCdBpkrG4bMvo1g2ZBzMJCMB/EpqijlwAB6wp23mDGBkBK9T/ndU7V4ctSdI9fsG0/gQ/uNk4wTSi88cxo3aSJSxpQtSmPEgEsmY/tyNR9Ywsocmyv+GBDLrUtEi4SmFqwoevNG0xq/TAuaJIDK2CwSwRKpWeghacrX3oW51eS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y8g2IQ/T; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y8g2IQ/T"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ddbcc96984so12483277b3.2
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 02:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727343542; x=1727948342; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ycHQDAR/krWFA5kAhgmXvoNx6Yn5beF8hwbiGL9F7lk=;
        b=Y8g2IQ/TWiIRAfeMzCGnKhGdCCiyaj8HmoSn7wqg+v2ta++QfnXDbFt08Usvsm3IGb
         gFo3QnQWM/AmTqItwzD+OaNSa+YUbg9oNcqIAwfSXNRg+WUANPb6hVnxQJ58aPTmugOk
         BH4jGLLw77HnDV5hLQ8sg2BmYoH6L7mfABaSiZKRhPGjnj5FFYoGTR6rZo4dkUYmSCfm
         w/U/yFR/gk0z2uAweSPUyybKwtsHQVNzqMzheIzobtR4SszFv1Prz7UAZrJ9cpRldSS+
         emPcEBF2Jx3a+4pIFLEOKE5JAc1ntkYF1bfGevwitcNiBKXeuyazq3xxx4QB3iQUjuGG
         jN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727343542; x=1727948342;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ycHQDAR/krWFA5kAhgmXvoNx6Yn5beF8hwbiGL9F7lk=;
        b=rxT3EG0Z7wDKLoaUeHByrxjSb3XsTTrX6vKUx3NpO2oL33UFMErRIwqB7Fb5ehLBGR
         48i4tZk0Waq2GgnN4DD6dbo6rFlZ6TIYoPZDO4J6CzMsVIENQf/g0YVTw11UX3eoFKDb
         f2xbOqNKgj9578V1RCPHjT1cv29xca5oBODPw4WiXardpGpkHiShLkn99qgYtfW4bXlX
         4u8jXm6gvR1dHId5phBZVYtgKj/PyIqoIkbZRD8rO7AzQtn/Qpvh7P8jrY9V2QgFPk1I
         TeypWPoXhazi2owa9U3vhs4BvWtXJvm+ywBgnZXn1HveRVLJPJn2EO1gfY6LszCxLgS7
         2Fzg==
X-Forwarded-Encrypted: i=1; AJvYcCVCyODl3NpnopjXDNXI3ig/pR5chzpeaLYdJKoj0U97VTq/3zqnXF3hrk6Wy/ci4A5zYekZ+mpR@lists.linux.dev
X-Gm-Message-State: AOJu0YxYgAjoFTIjo4rY+gAfUOWIVnudVWS8W7FW0pWVFRWRRJDwHrEr
	2TcOaLCq5bFs9PIOto06b00K9j9DloVffcZJbrfSAhMfEgu/oTLolOkC1r8fFfPE/19RI8JcR49
	5/Puvsa0QCgJQ4w==
X-Google-Smtp-Source: AGHT+IGI4hqzrkhhJCbBX+0u1jgbq7QHbvPabBeCXkjShlZKlKGw2LZ89Vl5DG9ttbS7pImuenmlt1hsPJbX6tk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:35bd])
 (user=aliceryhl job=sendgmr) by 2002:a05:690c:64c3:b0:6dd:d138:d823 with SMTP
 id 00721157ae682-6e21da1b6c6mr159737b3.8.1727343541682; Thu, 26 Sep 2024
 02:39:01 -0700 (PDT)
Date: Thu, 26 Sep 2024 09:38:49 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1650; i=aliceryhl@google.com;
 h=from:subject; bh=44hQx7AWS11P7gR6JRYZM6ZBLNvn/Mupzf7ndbZKPl0=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBm9StxLN2fyMJC8RkoiaRnVJ3U0C1IVmyAN7TNW
 HhO0NvF9rGJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCZvUrcQAKCRAEWL7uWMY5
 RhpeD/9glYj/FpR0nzvYFBXYuU8aJNGdb7wa6fsW2XhjYMVw9JdRch0Ucrshe8mTuWl5JJ7QmvU
 kaf/bPzLi2tkyHOvmSGX7qbqdlMAFwe+93OU9HZ0Fi9S0yfmS3utVQbRBOiQfgNjmVXbhSuR9qE
 fa2v7n23faAumTsZG0KlwdvqHxNOm2Q/PUkCU8lEbD3RqAFhaoTDbKeqVfnvQahg/2mXNkT1ECu
 vOdKuIkeNgP270KhzqSSr4KtQ8U7Mn9ISW7BLcfQutbvmaUQsg3BpJiV1+HiQqasKpwgT15Bnx3
 dx0QePxcwA5jyn/9chocy7livqXv36Dt/iH3WK4wxV6rDrvJGBdBN7ZO3ymDXj8Ry8YRzjWh3Ro
 s//K/tsXgYnME+NLId5qNta9o+0U3jqhRTT9DMC1UJxWLsYrfgjKQVHqcU8pBdrlatsrWDv2jj9
 W9ak11xGM86HfxH/Arfb/s5CK+x0tthRhHSM8d+pGFtx4T4w/sPfRXiiokUlD3nYWeiGKjgOybI
 dsLsmHd+rijr1dnkMCytT2EcmLw9z5RRUgcyOXku9IIbL6kOubLjb8yLbyTYHTnPXvotk6p+DAf
 ipYapLHDDxI9mqQm6Ha3X9wjm9lR6bwpHLQ2nnvLF3Wr3TZiHI/uxz3dpkd7RDz5h2VFummtUv6 E8TD6vt692NwG3g==
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926093849.1192264-1-aliceryhl@google.com>
Subject: [PATCH] rust: KASAN+RETHUNK requires rustc 1.83.0
From: Alice Ryhl <aliceryhl@google.com>
To: ojeda@kernel.org
Cc: a.hindborg@samsung.com, alex.gaynor@gmail.com, aliceryhl@google.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, gary@garyguo.net, hpa@zytor.com, 
	jpoimboe@kernel.org, linux-kernel@vger.kernel.org, masahiroy@kernel.org, 
	mingo@redhat.com, nathan@kernel.org, nicolas@fjasle.eu, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

When enabling both KASAN and RETHUNK, objtool emits the following
warnings:

    rust/core.o: warning: objtool: asan.module_ctor+0x13: 'naked' return found in MITIGATION_RETHUNK build
    rust/core.o: warning: objtool: asan.module_dtor+0x13: 'naked' return found in MITIGATION_RETHUNK build

This is caused by the -Zfunction-return=thunk-extern flag in rustc not
properly informing LLVM about the mitigation, which means that the KASAN
functions asan.module_ctor and asan.module_dtor are generated without
the rethunk mitigation.

The other mitigations that we enabled for Rust (SLS, RETPOLINE) do not
have the same bug, as they're being applied through the target-feature
functionality instead.

This is being fixed for rustc 1.83.0, so update Kconfig to reject this
configuration on older compilers.

Link: https://github.com/rust-lang/rust/pull/130824
Fixes: d7868550d573 ("x86/rust: support MITIGATION_RETHUNK")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/all/CANiq72myZL4_poCMuNFevtpYYc0V0embjSuKb7y=C+m3vVA_8g@mail.gmail.com/
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index fa734a144589..9a2bcba426c5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1950,6 +1950,7 @@ config RUST
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
 	depends on !CALL_PADDING || RUSTC_VERSION >= 108100
 	depends on !KASAN_SW_TAGS
+	depends on !(MITIGATION_RETHUNK && KASAN) || RUSTC_VERSION >= 108300
 	help
 	  Enables Rust support in the kernel.
 
-- 
2.46.0.792.g87dc391469-goog

