Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E28055E4C;
	Tue,  9 Jul 2024 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524777; cv=none; b=PKYZZhZ5cbAw9jlo3qpUnC/T7+m99lSY6U5O+rTKCDKBris19sPEOyxah4sFjzQT8h9nPzbGQUl5VJKmYMNBzrQCDAYKx+BSqh//39E6dviNY17TXUdHs+ldDWvH/fPg78+n86DCKAfbrS4sFAqSQCxoB8iKLePV35+TB7dLFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524777; c=relaxed/simple;
	bh=WX7li5YqdQizlgW0ZSTCuAaUFN2H68l7/0pN7m4MlJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HX61OA9CKPmi6FMG9sc/iVvh1/N7ecb0eODTCu37vpGSFqHvznPQaDqKrFjmvmoe7fPt5zN3A64k/02aJwkzFFOgqbvyx/C0d5Sd8+3SKlAfs5T6clYbmzlLokd+aGO16JwwiQBYy/gQO7Mn5h1a5LuPUnZMGHh9urgmUTLdf+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa/6DduR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa/6DduR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA961C3277B;
	Tue,  9 Jul 2024 11:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524777;
	bh=WX7li5YqdQizlgW0ZSTCuAaUFN2H68l7/0pN7m4MlJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa/6DduRqGPV4YRueQHV5esWJSJf0iagDbS+MBsvSZ9H8DqseyfyCaUdOXgI0IVUW
	 NKL2l06F6EwqAcOycVEJNf7S4DZNYPWfrzT+9is1NYFgebYFDz9yv8DnCaY2zy6tIY
	 SKaqs3dbrBmIHW/Jq4Dd6GV+Rab20nRcwdbluirw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/102] kbuild: fix short log for AS in link-vmlinux.sh
Date: Tue,  9 Jul 2024 13:11:01 +0200
Message-ID: <20240709110655.178632445@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index 458b2948b580d..019560548ac98 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -182,7 +182,7 @@ kallsyms_step()
 	mksysmap ${kallsyms_vmlinux} ${kallsyms_vmlinux}.syms
 	kallsyms ${kallsyms_vmlinux}.syms ${kallsyms_S}
 
-	info AS ${kallsyms_S}
+	info AS ${kallsymso}
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
 	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} \
 	      -c -o ${kallsymso} ${kallsyms_S}
-- 
2.43.0



