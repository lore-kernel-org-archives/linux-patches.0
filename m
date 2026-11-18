Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057655;
	b=vG6IUpzPBBVteYtR/dlmZRYodrFqPLzIMd9WHkgPMBU6Jd+g96CmHpeTdY2QCGGINkWT
	 raiymkUN2AEgN8vrrfOArk18dcL5IKr4HA272EVo6uS5Au0IJFzYPTfH47gRd6WMIyCyD
	 1mhPMIUoXIuKWfj1Lpa/bRkF71Kgzx148/ooDQaocRc0hwdIygatof3QXgC0eBdyr4Il8
	 Y8HvctB/0mCmnVvA29as8gNfjd1hNh0hh6Aj8qKvWSGQz/j33M5LEAzlE/yR7pVl9Tnib
	 6/xNhFEDZAo/IYUCY81Q7TQG9z8VfxgbRrwwQxggBAoReIyC5s9Y8Z5TbZd6M76pWeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=k3Cxq96V/ESrmqLcgNd6OXoTBBMxQMRXDSYM1n4M/Mk=;
	b=qoCCJGvlJ4Sftdv15Egn11zUtuzA2g5Jegh40oSeZaipfGURK2pYrQvAXSeYW6r3I/8r
	 de3kF3imscZrCC2zYjgxThOTvo6/KMGHDD4fjuttj6Ouzo8Mgw98Lf6i6wCY33d6/bn/S
	 7I6QkggFiXuQvfQ4n/pFsZjyd4FtAF+ZiQM0XsHCIvwgDsFsWm0lNtSJQ1xn2PFhGc52P
	 FDTjfoBFc2rXqCwyrpi9hBgNYiyEyQF+/i9RLw8KWJ2W5VMMaTbHqvHHB6XYajROwmPJW
	 /mayIFNEw5dIDcpuMpZAU0Wgln0RE+3O8GxCuyZRYhOuzq8jDOK23IzR+0GiCWh0H5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCR31pQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EEA60A2602;
	Thu, 19 Nov 2026 03:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCR31pQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9B91F000C4;
	Thu, 19 Nov 2026 03:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057655;
	bh=k3Cxq96V/ESrmqLcgNd6OXoTBBMxQMRXDSYM1n4M/Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCR31pQxNNc2Kqtw49k5u5YPyoiCZM1Vr+sqtpjCrIrW+KcHKlabi/HGdL46l1RpQ
	 QbCAddq6HjdwgI5KsC6ZwC5bQeq6uRhK96h+bDMeioDMPc+sUgAEajpwX7slJFlILU
	 lyIt7XaIO20MVjuGTy98f2WFDKt95leI+kQ+ua1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0206/1848] kbuild: link-vmlinux.sh: improve detection of third pass requirement
Date: Wed, 18 Nov 2026 15:37:24 +0100
Message-ID: <20261118145920.540918823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

[AD: kallsymso_prev is already tracked by kallsyms_step() here, so only
 add kallsymso_changed() and use it]

Signed-off-by: André Draszik <andre.draszik@linaro.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index bf534a323fddc..58cd30583c7af 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -180,6 +180,18 @@ gen_btf()
 	printf "${et_rel}" | dd of=${2} conv=notrunc bs=1 seek=16 status=none
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
 # Create ${2} .S file with all symbols from the ${1} object file
 kallsyms()
 {
@@ -344,7 +356,12 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	size1=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso_prev})
 	size2=$(${CONFIG_SHELL} "${srctree}/scripts/file-size.sh" ${kallsymso})
 
-	if [ $size1 -ne $size2 ] || [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
+	# Due to alignment, file size of the kallsymso object file might remain
+	# unchanged even if individual symbols within change size. Changed
+	# symbol sizes can still shift other symbols, though. Therefore, don't
+	# rely on file size alone.
+	if [ $size1 -ne $size2 ] || kallsymso_changed || \
+			[ -n "${KALLSYMS_EXTRA_PASS}" ]; then
 		kallsyms_step 3
 	fi
 fi
-- 
2.53.0



