Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD85143879;
	Wed,  3 Jul 2024 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005212; cv=none; b=c1npG7VQwRN/zT2EZ2aVwArZsyZm1a41LFjmerk1eHNS4oGd1l+J88AchcPVc/mm8odHvGVMYRAa18LJOPqILJrAz1HKLkuNG1mI/XthLtiAQqH3P1CjXRMHSBJURGf8cc9DX8NiCAWB8y2oxTEXC7drOjg1t4M7eyha32KbY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005212; c=relaxed/simple;
	bh=rnfpfTcHxE/wvkQ2mhA4x4zZEu9slPsErnYM8Kr+Ug0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqtUoaKLhJTJPAx6R46ZVZAdCV6zDgkn6IDMrfKoE9uNmVHt1eNX+qSJn66sMRLg6xQEvfkA8RgBpEi7YmxbzQJ+D82xBikjPMy+m58eil56WI9024/uBLxB05bBfj3ym2IHj8Zc1q1N+Rrxm4e+XsCcscpAUb5A1AiZ/cKdLvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeJEo9D7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeJEo9D7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02554C2BD10;
	Wed,  3 Jul 2024 11:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005212;
	bh=rnfpfTcHxE/wvkQ2mhA4x4zZEu9slPsErnYM8Kr+Ug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeJEo9D7StLc2VPCIvBfrP9jzglHOpOv6UjgzXR6q6Aw1GJrtZUgdxVN2rbYI0s+e
	 JkHgDFTSOfqGJrEeFHBeUG6dDbgcHGFpipxjSoyTZDRH6DPMvNBVXYt56JmzhkdW4k
	 aEfuu/VupJtaKz0xk8a1pAt/Wcc6GMFQDjTFQ/Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 264/290] kbuild: Install dtb files as 0644 in Makefile.dtbinst
Date: Wed,  3 Jul 2024 12:40:45 +0200
Message-ID: <20240703102914.114606364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 9cc5f3bf63aa98bd7cc7ce8a8599077fde13283e upstream.

The compiled dtb files aren't executable, so install them with 0644 as their
permission mode, instead of defaulting to 0755 for the permission mode and
installing them with the executable bits set.

Some Linux distributions, including Debian, [1][2][3] already include fixes
in their kernel package build recipes to change the dtb file permissions to
0644 in their kernel packages.  These changes, when additionally propagated
into the long-term kernel versions, will allow such distributions to remove
their downstream fixes.

[1] https://salsa.debian.org/kernel-team/linux/-/merge_requests/642
[2] https://salsa.debian.org/kernel-team/linux/-/merge_requests/749
[3] https://salsa.debian.org/kernel-team/linux/-/blob/debian/6.8.12-1/debian/rules.real#L193

Cc: Diederik de Haas <didi.debian@cknow.org>
Cc: <stable@vger.kernel.org>
Fixes: aefd80307a05 ("kbuild: refactor Makefile.dtbinst more")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.dtbinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.dtbinst
+++ b/scripts/Makefile.dtbinst
@@ -24,7 +24,7 @@ __dtbs_install: $(dtbs) $(subdirs)
 	@:
 
 quiet_cmd_dtb_install = INSTALL $@
-      cmd_dtb_install = install -D $< $@
+      cmd_dtb_install = install -D -m 0644 $< $@
 
 $(dst)/%.dtb: $(obj)/%.dtb
 	$(call cmd,dtb_install)


