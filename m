Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D001991C4;
	Thu,  6 Jun 2024 14:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683658; cv=none; b=BQRIVZcWqYZzew1/IQkj4r79HAmsbM1Xl0jj8vHWl4PeWwdeYIWRKKK06Kz+ZPCP3uZcWmNAPLL0p+BhPeY+sNiw18MnDX1CRf5MPz3Mwr1c9fvt3ISxb+wN1gzIZGFEUfYG+F8RSIC02QgBAJc2ib1qdAmDQ1ROuUUMiVIrJrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683658; c=relaxed/simple;
	bh=MfG3CCbDI+aFougpW9xDRaR7OKHX78PdHsavigCTzKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTJwUbow9GTR80hxOKwNTsNVbGCUt7asc4WNsCbQ4JyEynAs5CgZmPyMCh7lEXYOq6HaFe1aeWVtjBPUF8MDbOd13QxrSA7fafRUmvIrc93aH1Nfa4I2xzmXMUwtcx0jGS/zPLPRElg7wHWKXfjLtZiOiZtgv0FlR4j3qGeQR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsqGlsLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsqGlsLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BCFC2BD10;
	Thu,  6 Jun 2024 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683657;
	bh=MfG3CCbDI+aFougpW9xDRaR7OKHX78PdHsavigCTzKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsqGlsLg6wnTp8yEV8FHy/Yg/IvWft/qnaBqsjPMRbqiVweD2NheIZuGF9fRYaPML
	 6WzVmxf6doWqTy4eKr5yyGqb3JQ2XQQmfqyXtxg/DVL76mgqkOKSQLhEL8MMPGImVO
	 8HZEQgPXLT7WzbqL0sYAloKS93OHlV4PjHPNqiuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 536/744] kbuild: fix build ID symlinks to installed debug VDSO files
Date: Thu,  6 Jun 2024 16:03:28 +0200
Message-ID: <20240606131749.651782202@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit c1a8627164dbe8b92958aea10c7c0848105a3d7f ]

Commit 56769ba4b297 ("kbuild: unify vdso_install rules") accidentally
dropped the '.debug' suffix from the build ID symlinks.

Fixes: 56769ba4b297 ("kbuild: unify vdso_install rules")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: fc2f5f10f9bc ("s390/vdso: Create .build-id links for unstripped vdso files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vdsoinst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.vdsoinst b/scripts/Makefile.vdsoinst
index 1022d9fdd976d..c477d17b0aa5b 100644
--- a/scripts/Makefile.vdsoinst
+++ b/scripts/Makefile.vdsoinst
@@ -22,7 +22,7 @@ $$(dest): $$(src) FORCE
 
 # Some architectures create .build-id symlinks
 ifneq ($(filter arm sparc x86, $(SRCARCH)),)
-link := $(install-dir)/.build-id/$$(shell $(READELF) -n $$(src) | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
+link := $(install-dir)/.build-id/$$(shell $(READELF) -n $$(src) | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p').debug
 
 __default: $$(link)
 $$(link): $$(dest) FORCE
-- 
2.43.0



