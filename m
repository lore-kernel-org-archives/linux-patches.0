Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFF617CA0E;
	Tue, 16 Jul 2024 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146154; cv=none; b=dFn5h3NN/mlrwt/rKyNBGz4Y7lt2QFU6wQC9T6rW0wE1tmzCLq62FQmmMzJIZirkmPObnBEgiIjge7u1zmUAjfnUsdIlZLjKvF2xxyAD+KK/07JNz1sNBiyOrISCyB0RuLnG3H3FO2cQ172klIIyoOeeHhq1U4hMcK1Lo75p6As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146154; c=relaxed/simple;
	bh=57iNBLmUilpClTaiP3IWKsfd7rJdA+OMZLQR5r66ZjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPnoSIvDq38czVHikTuxX1uhhjF7BqF/8jBJOZsqvPUkxrhLjgI7Qgovi8SmaSoH2grsdGVhtPVXljsxfrGsNruncASBp/islwQ9J7Rpk4bpjWg5Sf26qc5YRAoGF3z951irrEJz/x2hIhrff4V8HZI02M8cQfon9D17PGctpFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jj5FgsJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jj5FgsJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6980AC116B1;
	Tue, 16 Jul 2024 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146153;
	bh=57iNBLmUilpClTaiP3IWKsfd7rJdA+OMZLQR5r66ZjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj5FgsJaCGhdgbW17VAVjiVBbh2PGxYZgka/7zKw5boSu3i5Zrt/u0+Os+h+7Am13
	 HXSyLDauEKyrsKx8Klc2QK25WBA1PfPo8grCCD4KwUV+yy/IdoXCDkAmLqI9jjNTVh
	 lPQLdiK4ttNRoAaQ/wv2Y7DzPmvBFEtRVBnTfVAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/144] kbuild: fix short log for AS in link-vmlinux.sh
Date: Tue, 16 Jul 2024 17:32:24 +0200
Message-ID: <20240716152755.428973484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a5a0cfad69df..40cbc73c7813c 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -278,7 +278,7 @@ kallsyms_step()
 	vmlinux_link ${kallsyms_vmlinux} "${kallsymso_prev}" ${btf_vmlinux_bin_o}
 	kallsyms ${kallsyms_vmlinux} ${kallsyms_S}
 
-	info AS ${kallsyms_S}
+	info AS ${kallsymso}
 	${CC} ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS} \
 	      ${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL} \
 	      -c -o ${kallsymso} ${kallsyms_S}
-- 
2.43.0



