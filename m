Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59EB373BE1;
	Sat, 28 Feb 2026 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301533; cv=none; b=Xbw44g8wXLiInkSRzkWAfaQaIUbM/1Qbbvr+csB/iQM6XLfpkLAW/wlNO4CwA4qqda7gITUF/mZAfCEk+KaKABRpUG3WuKl53aGqgMD1k87ie/EyY3+PuJjJutZ8+mTA1w4WbMvOtLhmTltVnlwz4qucmdTh5ddk3HYH2Rqjcsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301533; c=relaxed/simple;
	bh=YB007UTpIrmYR82LZcTIZxezIlKmCVaQ/ScAfFNf/lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q63HWyaUj7ZPWqiWw0Z8c+AvF9K202zKCyaGV3LM0oc/DAXajMZL2k5AwblSEtz5Ed0bV+HYvVzlQOqfi+r0uhbrtEGjXQnpHfGVP3rSIO7LuciCfthO4Ka5hs2n7crR4mrk8d9wJYN1VtBQTZTiHd1w34f4ZX5m17m4P7Yrhwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTnPRkhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTnPRkhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7042C19423;
	Sat, 28 Feb 2026 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301533;
	bh=YB007UTpIrmYR82LZcTIZxezIlKmCVaQ/ScAfFNf/lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTnPRkhLfnhjMwKRGvW0+zLTrQOoAMxvO54ED86XfH1YKQOQbH11pwkxMCeVznl/G
	 GnXItzuYSHembOs2Lj+xlu7s2rWaCV9naYZlphPN829rStWaQ1/nvPGYJZhEbcvQ0V
	 0h2WiqfkL/wICtcjlbcKHQA8WesBxGVpszddmLiPi1CtMIDNvgTgBAH9nm0Mpch7o2
	 Xy9HEaDLHClSwwy+vPjtK82eOamplUXS17mZb34CjqnCN4Od53nPA+mv3x+/uPIIGN
	 3sM2QL0KxwxxJUnu5ae3ykys8dkrfU7oZAHU612NqNAeAB85dPRZA4iR494VM/bTjm
	 K8LOQO/+UOgKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	stable@vger.kernel.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Juergen Gross <jgross@suse.com>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 715/752] kernel: rpm-pkg: Restore find-debuginfo.sh approach to -debuginfo package
Date: Sat, 28 Feb 2026 12:47:06 -0500
Message-ID: <20260228174750.1542406-715-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit ffe9ac1ad56df8f915896b97bd7645f522c47ce9 ]

Commit 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package
manually") effectively reverted commit a7c699d090a1 ("kbuild: rpm-pkg:
build a debuginfo RPM") but the approach it took is not safe for older
RPM releases. Restore commit a7c699d090a1 ("kbuild: rpm-pkg: build a
debuginfo RPM") for the !CONFIG_MODULE_SIG case to allow more
environments and configurations to take advantage of the separate debug
information package process.

Cc: stable@vger.kernel.org
Fixes: 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package manually")
Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Tested-by: Steve French <stfrench@microsoft.com>
Tested-by: Juergen Gross <jgross@suse.com>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260210-kbuild-fix-debuginfo-rpm-v1-2-0730b92b14bc@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 50 ++++++++++++++++++++++++++++++++++---
 scripts/package/mkspec      |  5 ++++
 2 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index b7deb159f404d..af682a7054779 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -2,8 +2,6 @@
 %{!?_arch: %define _arch dummy}
 %{!?make: %define make make}
 %define makeflags %{?_smp_mflags} ARCH=%{ARCH}
-%define __spec_install_post /usr/lib/rpm/brp-compress || :
-%define debug_package %{nil}
 
 Name: kernel
 Summary: The Linux Kernel
@@ -56,6 +54,38 @@ This package provides debug information for the kernel image and modules from th
 %define install_mod_strip 1
 %endif
 
+%if %{with_debuginfo_rpm}
+# list of debuginfo-related options taken from distribution kernel.spec
+# files
+%undefine _include_minidebuginfo
+%undefine _find_debuginfo_dwz_opts
+%undefine _unique_build_ids
+%undefine _unique_debug_names
+%undefine _unique_debug_srcs
+%undefine _debugsource_packages
+%undefine _debuginfo_subpackages
+%global _find_debuginfo_opts -r
+%global _missing_build_ids_terminate_build 1
+%global _no_recompute_build_ids 1
+%{debug_package}
+
+# later, we make all modules executable so that find-debuginfo.sh strips
+# them up. but they don't actually need to be executable, so remove the
+# executable bit, taking care to do it _after_ find-debuginfo.sh has run
+%define __spec_install_post \
+	%{?__debug_package:%{__debug_install_post}} \
+	%{__arch_install_post} \
+	%{__os_install_post} \
+	find %{buildroot}/lib/modules/%{KERNELRELEASE} -name "*.ko" -type f \\\
+		| xargs --no-run-if-empty chmod u-x
+%else
+%define __spec_install_post /usr/lib/rpm/brp-compress || :
+%endif
+# some (but not all) versions of rpmbuild emit %%debug_package with
+# %%install. since we've already emitted it manually, that would cause
+# a package redefinition error. ensure that doesn't happen
+%define debug_package %{nil}
+
 %prep
 %setup -q -n linux
 cp %{SOURCE1} .config
@@ -99,14 +129,22 @@ ln -fns /usr/src/kernels/%{KERNELRELEASE} %{buildroot}/lib/modules/%{KERNELRELEA
 	echo "%exclude /lib/modules/%{KERNELRELEASE}/build"
 } > %{buildroot}/kernel.list
 
-%if %{with_debuginfo_manual}
+%if 0%{with_debuginfo_manual}%{with_debuginfo_rpm} > 0
 # copying vmlinux directly to the debug directory means it will not get
 # stripped (but its source paths will still be collected + fixed up)
 mkdir -p %{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}
 cp vmlinux %{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}
+%endif
 
-echo /usr/lib/debug/lib/modules/%{KERNELRELEASE}/vmlinux > %{buildroot}/debuginfo.list
+%if %{with_debuginfo_rpm}
+# make modules executable so that find-debuginfo.sh strips them. this
+# will be undone later in %%__spec_install_post
+find %{buildroot}/lib/modules/%{KERNELRELEASE} -name "*.ko" -type f \
+	| xargs --no-run-if-empty chmod u+x
+%endif
 
+%if %{with_debuginfo_manual}
+echo /usr/lib/debug/lib/modules/%{KERNELRELEASE}/vmlinux > %{buildroot}/debuginfo.list
 while read -r mod; do
 	mod="${mod%.o}.ko"
 	dbg="%{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}/kernel/${mod}"
@@ -124,6 +162,10 @@ done < modules.order
 
 %clean
 rm -rf %{buildroot}
+%if %{with_debuginfo_rpm}
+rm -f debugfiles.list debuglinks.list debugsourcefiles.list debugsources.list \
+	elfbins.list
+%endif
 
 %post
 if [ -x /usr/bin/kernel-install ]; then
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 1080395ca0e16..c604f8c174e2c 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -23,6 +23,8 @@ else
 echo '%define with_devel 0'
 fi
 
+# use %{debug_package} machinery to generate -debuginfo
+with_debuginfo_rpm=0
 # manually generate -debuginfo package
 with_debuginfo_manual=0
 # debuginfo package generation uses find-debuginfo.sh under the hood,
@@ -56,9 +58,12 @@ if grep -q CONFIG_DEBUG_INFO=y include/config/auto.conf &&
 				with_debuginfo_manual='%{?_without_debuginfo:0}%{?!_without_debuginfo:1}'
 			fi
 		fi
+	else
+		with_debuginfo_rpm='%{?_without_debuginfo:0}%{?!_without_debuginfo:1}'
 	fi
 fi
 echo "%define with_debuginfo_manual $with_debuginfo_manual"
+echo "%define with_debuginfo_rpm $with_debuginfo_rpm"
 
 cat<<EOF
 %define ARCH ${ARCH}
-- 
2.51.0

