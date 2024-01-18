Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D0223762;
	Thu, 18 Jan 2024 11:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575732; cv=none; b=TSgpBDCOc2pMIJpFOus9SJB7mS25rD0IShljIUTlv/FqfVPJrW43BvRzqfSNdKKR2icn5+0Xzu15PIv/zCnFRzqRfbBCK8b7ZalXcOzlKKYRf5NKxAJNI0eIe/XjNyLmstVmAuyi1YTcYtZ3fykt9pwsT+Ujqy3av4loA16/vec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575732; c=relaxed/simple;
	bh=vSgCP0XslL8OsyO5ZN1bRY1SHJHmeyCy3mVBqWmK+Wo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=OV6ftqfZyYzD2fYg5u8Q6Q/xAO6mu0NTdAOzKDKkTrRtpRDLaIHj90AQ8pWkxV4vxgiDPc3xut2bCG3RUrMa57nneJx/s9TuX4blx7H/DVfOLDbLcieBNbYeTKCkGhe5Y5TK677QWLzK9cZAXye9uMPh7RwLy4zuCo8rj+wegmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEYcnw/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEYcnw/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A13C43390;
	Thu, 18 Jan 2024 11:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575732;
	bh=vSgCP0XslL8OsyO5ZN1bRY1SHJHmeyCy3mVBqWmK+Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEYcnw/4mqVbOJV3sw8c5BWc0rD/PhD5Azkay1ASSjaVwbihXUKgeHV6WrPXs0ncZ
	 5TLV23edgCGiMCWK3IFUvTusfei1IxbSG699EmFxzOOLBYU5vTBA9oULzVbKOtOEe5
	 J0jl6yOtR4rAqvpFr0Q0X7J5VbAlQsSdOuNplAew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Curtin <ecurtin@redhat.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Neal Gompa <neal@gompa.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.1 085/100] btf, scripts: Exclude Rust CUs with pahole
Date: Thu, 18 Jan 2024 11:49:33 +0100
Message-ID: <20240118104314.599592214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

commit c1177979af9c616661a126a80dd486ad0543b836 upstream.

Version 1.24 of pahole has the capability to exclude compilation units (CUs)
of specific languages [1] [2]. Rust, as of writing, is not currently supported
by pahole and if it's used with a build that has BTF debugging enabled it
results in malformed kernel and module binaries [3]. So it's better for pahole
to exclude Rust CUs until support for it arrives.

Co-developed-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=49358dfe2aaae4e90b072332c3e324019826783f [1]
Link: https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=8ee363790b7437283c53090a85a9fec2f0b0fbc4 [2]
Link: https://github.com/Rust-for-Linux/linux/issues/735 [3]
Link: https://lore.kernel.org/bpf/20230111152050.559334-1-yakoyoku@gmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig            |    2 +-
 lib/Kconfig.debug       |    9 +++++++++
 scripts/pahole-flags.sh |    4 ++++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1914,7 +1914,7 @@ config RUST
 	depends on !MODVERSIONS
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
-	depends on !DEBUG_INFO_BTF
+	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
 	select CONSTRUCTORS
 	help
 	  Enables Rust support in the kernel.
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -364,6 +364,15 @@ config PAHOLE_HAS_BTF_TAG
 	  btf_decl_tag) or not. Currently only clang compiler implements
 	  these attributes, so make the config depend on CC_IS_CLANG.
 
+config PAHOLE_HAS_LANG_EXCLUDE
+	def_bool PAHOLE_VERSION >= 124
+	help
+	  Support for the --lang_exclude flag which makes pahole exclude
+	  compilation units from the supplied language. Used in Kbuild to
+	  omit Rust CUs which are not supported in version 1.24 of pahole,
+	  otherwise it would emit malformed kernel and module binaries when
+	  using DEBUG_INFO_BTF_MODULES.
+
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -19,5 +19,9 @@ fi
 if [ "${pahole_ver}" -ge "122" ]; then
 	extra_paholeopt="${extra_paholeopt} -j"
 fi
+if [ "${pahole_ver}" -ge "124" ]; then
+	# see PAHOLE_HAS_LANG_EXCLUDE
+	extra_paholeopt="${extra_paholeopt} --lang_exclude=rust"
+fi
 
 echo ${extra_paholeopt}


