Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060550;
	b=OGIvX385tqvPo/7VasR8bWzmuoGdqKj+d8prp1DEY5z6+2bAav1TzqOkqcIoMaixBpL4
	 yh+EEUIpQNAaIgJFK7cptX/3ZjRe6JVQ4LRv80moF4yBmG796zQaTJgg/hIVzxjcQDHrt
	 KNjcK1mZQgALMVKqW84Rw/jOzfYs7GG1hwfEWfRRiC+oXRIQR3etZG4+iomkYuwfQeICe
	 E/f9ImvXCr8+hK80A9l/jVHoqrHi3aGpbTDA8H1pzjQysZkkBkZmt0LVxuKpbiQyfQ8dF
	 8K6ernd0c4nU/tpBTNr1fF9WNPLQgN/sutqPw63gBtQFbL06jYVvzn6e8DrTXsfmSHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3OdIwu2Q3eRY24MoSLH1+aA5axXLoxyg81buol68Pc4=;
	b=jgYxdHTRYW3+3RkI6AbVN2f9hHGxvM0w8aiNXbjaSBVCMgR3UjV3HSLUBg13CuDaFO47
	 skuuDITy4UaXzM8OvWNRJ8o3w9YrbNgQoPmoOnRdzQ7k/d5vfHgEqc35IHZ64dJ0Q/mAY
	 Smdhfenff7rX3oZZQGSI1gTkNrts9AZrJoitqNAleaptxWitCur9P8cbLBTOEMXAgdXio
	 bOr+WIzW55z7b7Pi3ZNQ0INvPq+uply8lf6rFAIvVJ1zZLVU+65xIHOUJ78PvXcTFio2D
	 MR90aGFBPFjZ+jh/0QA8V2tl+suWS14viVhq/kbGebzWUERsr2XUi2TBgxFfA3GuMFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amlyL5Zg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF31606A326;
	Sat,  7 Nov 2026 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amlyL5Zg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A5C1F008A1;
	Sat,  7 Nov 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060549;
	bh=3OdIwu2Q3eRY24MoSLH1+aA5axXLoxyg81buol68Pc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amlyL5ZgOeoqS1YSCeOiqBGcvCV0w8WkbRanO0xXpsmY+9ASguTB31XFLxU97UGae
	 5nceOMheFA3Y0CXm+VrPHrUWLmpgUlV7LbmHUMMvecH+iZ3/PACdTNFo4AXmKknGT2
	 eUC5Q3YGGr7aDAbDVRtHSRsjJkAyC5Zkiqprv5/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0016/1536] kbuild: link-vmlinux.sh: improve detection of third pass requirement
Date: Sat,  7 Nov 2026 08:33:52 -0500
Message-ID: <20261107134958.134072570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 94f794ca11ca8..a5729419a452f 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -131,6 +131,18 @@ gen_btf()
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
@@ -151,6 +163,7 @@ kallsyms()
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
 	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} -c -o "${2}.o" "${2}.S"
 
+	kallsymso_prev="${kallsymso:-}"
 	kallsymso=${2}.o
 }
 
@@ -263,7 +276,12 @@ if is_enabled CONFIG_KALLSYMS; then
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



