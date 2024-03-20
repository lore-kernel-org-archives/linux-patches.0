Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FD1A32;
	Wed, 20 Mar 2024 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895074; cv=none; b=ufXcPva+KerS0QstXdOF26GnybgnswU1maGbkQuz/+srxDjce2xVLfC8G8hSwov/bsYIaHZiYlZBTpC/RtpDUzECKzdCCQdRryKsmRJ/cXv/9V6Gh2hZncq2ysmO/M/MIXqbJmHp5lK4rIJRjjJW81kDLFhyB2XNaJlWUnvXtuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895074; c=relaxed/simple;
	bh=H5PLorY6Ln0claIexaNlOnDQb1/MD6u9Cfxdq4YBk4g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sjdj+5Rn680c0DcJPLVOHtI6W0/wGQiihw7MLqredST4RDIqaHUelc8/MLRGcT8PuG0bkAUf8jVPj1AvsL722aTtlDrz8wLNts2L8PQu9JeihRVpMzoH5E0kXsOSJ7ljOhEZi8+c8XMFJKIDVjVAPhsB8cp6Y657NiV+02zVZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka1sC+6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka1sC+6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAF7C433F1;
	Wed, 20 Mar 2024 00:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710895074;
	bh=H5PLorY6Ln0claIexaNlOnDQb1/MD6u9Cfxdq4YBk4g=;
	h=From:Date:Subject:To:Cc:From;
	b=Ka1sC+6a7uyb7+Ow9StGXtuG0370Lf55eX7kC7fEzCN+KIHfNRe9oTjCK7HXSdPCx
	 ZH5pcBQszzqBXWCdnM3xuFUIJ52XIFYc+ROhO6he9e+EqT4j3hRf9u/BisgQqPq38J
	 nq4R5/+UB7UzE2edwxuf3pe9Tgl0/5e+kgkbch/5OzmxvzAlychGgH9hq+gMUwy10b
	 FkOysl1OywhTpmFeklZDw5iWOXD2TSEFFQzOeMfBMlSyj/HsIzx6M7F7d292dbfgJX
	 +NY6Ej8ZdD2o05ed+Xsxu24ZxYumUOECxPpBYIUg4If8RV+TGPkMYt0vzD6fy/qhbz
	 qKxUjiDaSFIaw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 19 Mar 2024 17:37:46 -0700
Subject: [PATCH] hexagon: vmlinux.lds.S: Handle attributes section
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org>
X-B4-Tracking: v=1; b=H4sIANkv+mUC/x2NwQrDIBBEfyXsuQtqhGB/pfRgdJMsWFPUBCHk3
 7v0+GZ4MxdUKkwVnsMFhU6uvGcB/RggbD6vhByFwShj1agdbtT9umeUMiZC31rh+WhUsVJoYuP
 5SZyPjilKhsZrO2s7ORcUyOq30ML9//h63/cPfZ1W8IEAAAA=
To: akpm@linux-foundation.org, bcain@quicinc.com
Cc: ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
 linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1276; i=nathan@kernel.org;
 h=from:subject:message-id; bh=H5PLorY6Ln0claIexaNlOnDQb1/MD6u9Cfxdq4YBk4g=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKm/9B9qsb+p+SRtGH/n8z8rPsHpTIs9dQSYs5QechR1y
 JxwijzWUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZi+ZThf46n9RW10IRX21T2
 v3um8tm76yHLDVWnjs3ffNgFs7tf7GD4KxoWdrBDi1s1r25pW7GwhUTWcm6mlR+5T5/b/OSPwuQ
 pLAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After the linked LLVM change, the build fails with
CONFIG_LD_ORPHAN_WARN_LEVEL="error", which happens with allmodconfig:

  ld.lld: error: vmlinux.a(init/main.o):(.hexagon.attributes) is being placed in '.hexagon.attributes'

Handle the attributes section in a similar manner as arm and riscv by
adding it after the primary ELF_DETAILS grouping in vmlinux.lds.S, which
fixes the error.

Cc: stable@vger.kernel.org
Fixes: 113616ec5b64 ("hexagon: select ARCH_WANT_LD_ORPHAN_WARN")
Link: https://github.com/llvm/llvm-project/commit/31f4b329c8234fab9afa59494d7f8bdaeaefeaad
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/kernel/vmlinux.lds.S b/arch/hexagon/kernel/vmlinux.lds.S
index 1140051a0c45..1150b77fa281 100644
--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
+	.hexagon.attributes 0 : { *(.hexagon.attributes) }
 
 	DISCARDS
 }

---
base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
change-id: 20240319-hexagon-handle-attributes-section-vmlinux-lds-s-2a14b14799c0

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

