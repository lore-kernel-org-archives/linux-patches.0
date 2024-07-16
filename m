Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335251DDF5;
	Tue, 16 Jul 2024 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144637; cv=none; b=RblZTBVp0dLJykM4aQBJBXTsWBjlLHPDKXHx6OHUCXFwq+q75owrYXVDU5PeA3fHHHQBHx43FHzAqRacMIkDaYmLUIUgSs31vJR2er2q2AvkEXXs9szwVfAu7a9jZXBi6V1Z90z34+NRIx1nDdEdPio6fdFtbmGJLAerEBsPAdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144637; c=relaxed/simple;
	bh=Vh4HTRfSNh9uEHb7xF6j47FpxSslNLvOe8l8TpHt8l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myIPXgI3WwGYh1LMdtNlPuzzNcz0G3LFs+VeXHfsqa8JGmEepvoODeByUcMTEXSB56GMMhzzNOFess/wjxPgYr0aXzXlj9VqbElVVx4qRoZjVieqcRict8zAyfsqyL2BH1optn0jmwllgK39eAs8jHypGm9/OdlqG5OICA2ogMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hE1yuYN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hE1yuYN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AD3C4AF0B;
	Tue, 16 Jul 2024 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144636;
	bh=Vh4HTRfSNh9uEHb7xF6j47FpxSslNLvOe8l8TpHt8l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE1yuYN867/lfcOS7stQOTgdYzE2shbb58GN6t4NAKHFNS+WKvQxRJjwIMVp9Z3ih
	 lBopty2w44iPv+dUcgn1F/o1lJuZeryaPPa/nIwYrYCxco0LO46z5d83nI1nGWDQg+
	 rz/2EzGbHgpfELLqzoazCS8JYjAMHZMVNl4XZUuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/108] kbuild: fix short log for AS in link-vmlinux.sh
Date: Tue, 16 Jul 2024 17:31:11 +0200
Message-ID: <20240716152748.137404969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3430f65d6130ccbc86f0ff45642eeb9e2032a600 ]

In convention, short logs print the output file, not the input file.

Let's change the suffix for 'AS' since it assembles *.S into *.o.

[Before]

  LD      .tmp_vmlinux.kallsyms1
  NM      .tmp_vmlinux.kallsyms1.syms
  KSYMS   .tmp_vmlinux.kallsyms1.S
  AS      .tmp_vmlinux.kallsyms1.S
  LD      .tmp_vmlinux.kallsyms2
  NM      .tmp_vmlinux.kallsyms2.syms
  KSYMS   .tmp_vmlinux.kallsyms2.S
  AS      .tmp_vmlinux.kallsyms2.S
  LD      vmlinux

[After]

  LD      .tmp_vmlinux.kallsyms1
  NM      .tmp_vmlinux.kallsyms1.syms
  KSYMS   .tmp_vmlinux.kallsyms1.S
  AS      .tmp_vmlinux.kallsyms1.o
  LD      .tmp_vmlinux.kallsyms2
  NM      .tmp_vmlinux.kallsyms2.syms
  KSYMS   .tmp_vmlinux.kallsyms2.S
  AS      .tmp_vmlinux.kallsyms2.o
  LD      vmlinux

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 3a1ffd84eac28..bf534a323fddc 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -213,7 +213,7 @@ kallsyms_step()
 	vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
 	kallsyms ${kallsyms_vmlinux} ${kallsyms_S}
 
-	info AS ${kallsyms_S}
+	info AS ${kallsymso}
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
 	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} \
 	      -c -o ${kallsymso} ${kallsyms_S}
-- 
2.43.0



