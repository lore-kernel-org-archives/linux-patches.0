Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826769;
	b=izn7V1T1nAUXqRi7W+D3+5PeQtqOKh7QJ4StFL027wTU0PUtCoUmbL9OotdEG6wFwZC7
	 4LDWTeyE2Ex4NwDAz/3qwrlJEYk7hAzwta9Rt7FCDmIXnnmZtAxPlQ3XRtm/2a/tYQYEY
	 oXdC3DOyX59EyFXQMDUS1rJ+meA3zj8ZLEA9AeYS603fssSdXi6PU2sDOfpNDNANVnR5Z
	 nURJPld49sN6vjD/wNLQFCDrmCEoqCnDrY/Gx5MA1lvatcAS9SpVNmHupPU0tPuFqkX+V
	 cpoHJl2TWRuwYZqXvUE0jWr/1xPcy7DCQhR9AxSWTstTETCiYuI+IVBKOuHA9sPmgGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oyE5rY3Yw2/JwlnXYX1qls3YDf1Wkg9jMmZrcOroeto=;
	b=PUn5XD4dLULJshAxBF0nCSUCTPy0BkVF44WAeSvEYRA4SvsNRFhalHIcN0smSnZk+rj0
	 pTJdMLydJ8VKl2jMHIice/NnJI9EBV0SKxV4Jl7ht8oEyXwQN/SnOprHWBTy0899dB9KA
	 AHSa537HxOonmWNLEgvQ7EciNlgDAJJqgoPXfo7Ie3WLIyiEVmHLNLJgIutiG4JliiXiK
	 bARsp10F9EZscwYpFLs2UB/Y8MGb9o4xfWRi6yj2TJ9pdoDlQhSMI9QjveJZHjV/MhW+T
	 A2zritWNt3rD9gPWdDJHrQ1tqqiFLvKjd6FBMooD7G9DGZ3FinQc30OUQolmOkbZujA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ex1fYchY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCE960ABB3B;
	Wed,  4 Nov 2026 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ex1fYchY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EAC1F0093A;
	Wed,  4 Nov 2026 21:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826768;
	bh=oyE5rY3Yw2/JwlnXYX1qls3YDf1Wkg9jMmZrcOroeto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ex1fYchYNKs8/RCyJNzhmH1ZTj/hQsP4QkFOsc694q+sQ+NeEXVpxf6angZw5TpTd
	 WoA5VFJhAMNaK0PGEqRwP4fMU1ME/X5wxEmccZ+L9saYaSBgPyac6s3eRVPNhsZk5u
	 zguQTCP3pPOBl4taSUUa894iCI92i3QMlqoLpSMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0006/1005] kbuild: link-vmlinux.sh: improve detection of third pass requirement
Date: Wed,  4 Nov 2026 15:55:39 -0500
Message-ID: <20261104211043.708162316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 14b8b4bf2d7bd5d58c17adbeed0edfda1dfc1a7f upstream.

It can happen that symbol sizes within .tmp_vmlinux1.kallsyms.o and
.tmp_vmlinux2.kallsyms.o differ, without affecting file size on disk
because of section alignment and/or padding emitted by the assembler.

link-vmlinux.sh doesn't detect this case currently and keeps using
.tmp_vmlinux2.kallsyms.o to link the final vmlinux. Due to the
different symbol sizes, other symbols are shifted within the final
image compared to .tmp_vmlinux2, and the final comparison of System.map
against "${kallsyms_sysmap}" fails with the message:

    Inconsistent kallsyms data
    Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

This can happen in particular if the linker emits additional symbols
that might have different names between our (re-)linking steps, e.g.
because those names depend on the virtual address of the symbol. Linker
stubs for ARM errata work-arounds are one such case.

These changed symbol names can cause the output of the token
compression of kallsyms.c to change due to the changed symbol substring
count, which in turn can change the size of the kallsyms_names symbol
itself, causing the potential shift of subsequent symbol addresses in
.tmp_vmlinux2.kallsyms.o and therefore the final image.

Update link-vmlinux.sh to not rely on file size of
.tmp_vmlinux?.kallsyms.o alone but to also consider symbol offsets
within to resolve this, and do a third pass if required.

Signed-off-by: André Draszik <andre.draszik@linaro.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Nicolas Schier <nsc@kernel.org>
[AD: adjust context]
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 433849ff7529e..050791ea10235 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -133,6 +133,18 @@ gen_btf()
 	btf_vmlinux_bin_o=${btf_data}
 }
 
+# Check if kallsymso_prev and kallsymso differ
+# If symbol sizes within ${kallsymso} change, any symbols within vmlinux are
+# likely to shift, invalidating ${kallsymso}.
+# Since file size can remain unchanged even if symbol sizes change, compare the
+# actual symbols instead of relying on file size only.
+kallsymso_changed()
+{
+	${NM} -n "${kallsymso_prev}" > "${kallsymso_prev}.sym"
+	${NM} -n "${kallsymso}" > "${kallsymso}.sym"
+	! cmp -s "${kallsymso_prev}.sym" "${kallsymso}.sym"
+}
+
 # Create ${2}.o file with all symbols from the ${1} object file
 kallsyms()
 {
@@ -149,6 +161,7 @@ kallsyms()
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
 	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} -c -o "${2}.o" "${2}.S"
 
+	kallsymso_prev="${kallsymso:-}"
 	kallsymso=${2}.o
 }
 
@@ -267,7 +280,12 @@ if is_enabled CONFIG_KALLSYMS; then
 	sysmap_and_kallsyms .tmp_vmlinux2
 	size2=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
-	if [ $size1 -ne $size2 ] || [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
+	# Due to alignment, file size of the kallsymso object file might remain
+	# unchanged even if individual symbols within change size. Changed
+	# symbol sizes can still shift other symbols, though. Therefore, don't
+	# rely on file size alone.
+	if [ $size1 -ne $size2 ] || kallsymso_changed || \
+			[ -n "${KALLSYMS_EXTRA_PASS}" ]; then
 		vmlinux_link .tmp_vmlinux3
 		sysmap_and_kallsyms .tmp_vmlinux3
 	fi
-- 
2.53.0



