Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA923F23C5;
	Wed, 20 May 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301076; cv=none; b=gY8pMC4FMsjk7tnABMFkmTA27VR/1+GrcWofXTtHSrqDTyOfRtR59zBxrc1B/aPY4/L5KJEa/u9Q8ulyiP77/CseEROaZV0VO4TgpBqEF3BIqOK4z7PfcuE9FHiA3JMKhS6jzhSRF94xe2R7gpw8o1TYwx8EFbxcegyeq7Svdqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301076; c=relaxed/simple;
	bh=uEm+g9YunSQYtmpRNDKQ0uSBGWc2rvxwd+zzYVt9O+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UByiCEEUdy7BwFpG2vOKFRlc5YAxN4E/QTZG415MOTljx/ik9st9zMKkYxspB5fxhv3wUwNKSPlyYnOUWplLDwIKJrLXRR1dDXz5NxhG8DbtjVX60fbTLa7R6xnViFejU94ir88kwjyuqDlyYwA1S/Bn1IHrzXAlIx+pp1hb7A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k+DGtHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k+DGtHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31801F000E9;
	Wed, 20 May 2026 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301075;
	bh=atJg9WthQOb7Y+yTv/wQFiBDGfYqzSv8sB14KJkJMIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2k+DGtHR/FiYsZxBnXKktXtGZLZAXzv8bDldFgQJCX8yhlHvHHyTqUKUThU4sHUxf
	 YEsXY2/SRq/HQAzFjUgNjJXZECQAnJVZDl1j6PDdJ35MTYnRBYsSrC5ATxc4JfE6H+
	 dQ+xryRUQnJ1T9Y3OqpEFs8guoRyWIt240sJohw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/666] x86/um: fix vDSO installation
Date: Wed, 20 May 2026 18:20:27 +0200
Message-ID: <20260520162120.281377166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d1895c15fc7d90a615bc8c455feb02acaf08ef1e ]

The generic vDSO installation logic used by 'make vdso_install' requires
that $(vdso-install-y) is defined by the top-level architecture Makefile
and that it contains a path relative to the root of the tree.
For UML neither of these is satisfied.

Move the definition of $(vdso-install-y) to a place which is included by
the arch/um/Makefile and use the full relative path.

Fixes: f1c2bb8b9964 ("um: implement a x86_64 vDSO")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20260318-um-vdso-install-v1-1-26a4ca5c4210@weissschuh.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile.um      | 2 ++
 arch/x86/um/vdso/Makefile | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index c86cbd9cbba38..19c13afa474e9 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -60,4 +60,6 @@ ELF_FORMAT := elf64-x86-64
 LINK-$(CONFIG_LD_SCRIPT_DYN_RPATH) += -Wl,-rpath,/lib64
 LINK-y += -m64
 
+vdso-install-y += arch/x86/um/vdso/vdso.so.dbg
+
 endif
diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index b3dfd60619e8a..bde42fac402ca 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -3,8 +3,6 @@
 # Building vDSO images for x86.
 #
 
-vdso-install-y += vdso.so
-
 # files to link into the vdso
 vobjs-y := vdso-note.o um_vdso.o
 
-- 
2.53.0



