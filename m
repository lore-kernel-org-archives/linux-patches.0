Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84453431FD;
	Wed,  3 Dec 2025 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777467; cv=none; b=sG4MLEUEPhBTMn+0ISTOIo92epch+bDflyPATkVf+sXYcuXOFV3YG6elFIFRRTvwtJlSPWzapFam3bSkfHDRnCDeHvgr/PsdKwaG5281IpH5JmKy8J4GD+d/AwQy3v3ch0zOZWDQZcCuVf1cj3tYZ9HbNqeoWCyVMr5d4GV0NqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777467; c=relaxed/simple;
	bh=MLVJiyaABtRXa0HSLH62aNSk+WwCDERQZMTpbE269Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aorTJ1lTaG5ry5VOIiXvLQSl3sEGHvT/R2n9Sbbcitq9MuhZYeFprXcuTOBLVYY+WcYPEZgGDfdhO1ZEsVejzgyjh6NnvCT+ait37jb6ASprrOIvKGiYKq81sNi6v3fE5WjZVGmDWgKZ/UY1njF44yTg7Gd8hPBkcwOls21BRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbAefqgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbAefqgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF47C4CEF5;
	Wed,  3 Dec 2025 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777466;
	bh=MLVJiyaABtRXa0HSLH62aNSk+WwCDERQZMTpbE269Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbAefqgXPLwxv2IvKfSpSzbYmd9/Vp/fEWPr29NUoLNT0hkgWiLwZUPwyU2QL0Kkc
	 VDK/JlmANseedjO47lAQSFHuH72vemBtYaxlAG582fTVoowqVZbr0N3MhwIfDcmshj
	 7vEQOYSqbXd/ZjZpnBWDDF641NqjK043WFqJ5v0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 046/392] x86/boot: Compile boot code with -std=gnu11 too
Date: Wed,  3 Dec 2025 16:23:16 +0100
Message-ID: <20251203152415.803979516@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit b3bee1e7c3f2b1b77182302c7b2131c804175870 upstream.

Use -std=gnu11 for consistency with main kernel code.

It doesn't seem to change anything in vmlinux.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://lore.kernel.org/r/2058761e-12a4-4b2f-9690-3c3c1c9902a5@p183
[ This kernel version doesn't build with GCC 15:
    In file included from include/uapi/linux/posix_types.h:5,
                     from include/uapi/linux/types.h:14,
                     from include/linux/types.h:6,
                     from arch/x86/realmode/rm/wakeup.h:11,
                     from arch/x86/realmode/rm/wakemain.c:2:
    include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
       11 |         false   = 0,
          |         ^~~~~
    include/linux/stddef.h:11:9: note: 'false' is a keyword with '-std=c23' onwards
    include/linux/types.h:30:33: error: 'bool' cannot be defined via 'typedef'
       30 | typedef _Bool                   bool;
          |                                 ^~~~
    include/linux/types.h:30:33: note: 'bool' is a keyword with '-std=c23' onwards
    include/linux/types.h:30:1: warning: useless type name in empty declaration
       30 | typedef _Bool                   bool;
          | ^~~~~~~

  The fix is similar to commit ee2ab467bddf ("x86/boot: Use '-std=gnu11'
  to fix build with GCC 15") which has been backported to this kernel.

  Note: In < 5.18 version, -std=gnu89 is used instead of -std=gnu11, see
  commit e8c07082a810 ("Kbuild: move to -std=gnu11"). I suggest not to
  modify that in this commit here as all the other similar fixes to
  support GCC 15 set -std=gnu11. This can be done in a dedicated commit
  if needed. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -24,7 +24,7 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
+REALMODE_CFLAGS	:= -std=gnu11 -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)


