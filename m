Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD91D7C08C;
	Mon,  8 Apr 2024 14:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584836; cv=none; b=Y2mPQEnQ7Ok3FCHYkRpz58Pt2mvqmmP5MnW6wnVxxeTW9R7UGjxtE4Y6j6iBqV/m8JJrDsPV8ExM5/RaJYiRjRhPl4AAJXXd2dDGiOcII/OL19SlsPRoh9occWfUxORtQlnjexK8CdEmzNEyMlJAxoVPCraMA7Jjs3qZs3QM+5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584836; c=relaxed/simple;
	bh=QOk7UcphlCMllmAq0a6Lbliv7Hp6ZZeRr4WCXo/jG8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGSh8MphrjysPCxhPCT1MhRrY0HWtamE6/9QX+vVnCz/Rv63fcTkvKzINYVEnMVoZMuWk0+wJkjuB+ndI4Uz97s5BoPc8EBQU205sMvW2haB6I1PKFAKcVZfIX1iCHwC4+cdtG0R35KOhsohzJ8FbS3koezRX1FbY0XWJ9hj/jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkghc4ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkghc4ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683B8C433F1;
	Mon,  8 Apr 2024 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584835;
	bh=QOk7UcphlCMllmAq0a6Lbliv7Hp6ZZeRr4WCXo/jG8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkghc4baBr15+V4khZuEe8bQXKrn+CkReXUS9M5svLWwKFAxvYCzgvY95MPzVoFTz
	 b/gLPD+Be/piHIj4siIkhVq053cuJeOqo7jMwX2cIZGAUYaujNucr2HCvpyxRXwy1u
	 u7pXFJOZRdX1Z7+C7UFtGlJxAEgOOW2+9LzgT1T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Brian Cain <bcain@quicinc.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 573/690] hexagon: vmlinux.lds.S: handle attributes section
Date: Mon,  8 Apr 2024 14:57:19 +0200
Message-ID: <20240408125420.370545633@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 549aa9678a0b3981d4821bf244579d9937650562 upstream.

After the linked LLVM change, the build fails with
CONFIG_LD_ORPHAN_WARN_LEVEL="error", which happens with allmodconfig:

  ld.lld: error: vmlinux.a(init/main.o):(.hexagon.attributes) is being placed in '.hexagon.attributes'

Handle the attributes section in a similar manner as arm and riscv by
adding it after the primary ELF_DETAILS grouping in vmlinux.lds.S, which
fixes the error.

Link: https://lkml.kernel.org/r/20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org
Fixes: 113616ec5b64 ("hexagon: select ARCH_WANT_LD_ORPHAN_WARN")
Link: https://github.com/llvm/llvm-project/commit/31f4b329c8234fab9afa59494d7f8bdaeaefeaad
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Brian Cain <bcain@quicinc.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -64,6 +64,7 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
+	.hexagon.attributes 0 : { *(.hexagon.attributes) }
 
 	DISCARDS
 }


