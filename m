Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB9B3570B7;
	Mon, 18 Aug 2025 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526389; cv=none; b=jKkinXgLiq14QB+EBC2hVscS3S2PXB4fRVT8Qqg50YM6CXLdBnUbL1YFIbcSor4jVIAH0DrW0i7I+NvlxUNSdrYLrbxVvQRZmlykeiBI1MZz4POH0fp6V9F0EwefioyRk/3Pvrn9EVOWY/dKJOD5rTkCpAmwTlRBPGO5SxVbqQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526389; c=relaxed/simple;
	bh=JTqC9v0vnpCH7GxvQmJvPc3etaIzGXadZ12jX90cBJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1sykY3g336pXWZsvKxET7LRypO3nl22Rn54D9UvbZw27y7ud+3wCHFaIh5QQ6wpXZmA7Z9KU8JVbjwkK+qkA+gAfwUquH2NKJYmZGvjZB6ihE7CghxcJBv2XrdgMFs86HjnsZQ2reX6To/sF0h4u97caF+ln21IjeKv7kGz8Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVtCpla0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVtCpla0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A58C4CEEB;
	Mon, 18 Aug 2025 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526388;
	bh=JTqC9v0vnpCH7GxvQmJvPc3etaIzGXadZ12jX90cBJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVtCpla0l9olErDQgDOXzhBR6OfmuJZbd4Qvrei7UZ50yu57JPslXjZVmUVzv2r9x
	 JG4e0boIY9mfD0M62SpqBjzpnWkggSZn44rR9j4XHZrFNO0x+z44BO5SkuOh/rD/m8
	 cKjCwm1PV5BtdIPFicio3NjH53/JVyq1O76FDc7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.16 541/570] parisc: Makefile: fix a typo in palo.conf
Date: Mon, 18 Aug 2025 14:48:48 +0200
Message-ID: <20250818124526.720115167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit 963f1b20a8d2a098954606b9725cd54336a2a86c upstream.

Correct "objree" to "objtree". "objree" is not defined.

Fixes: 75dd47472b92 ("kbuild: remove src and obj from the top Makefile")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -139,7 +139,7 @@ palo lifimage: vmlinuz
 	fi
 	@if test ! -f "$(PALOCONF)"; then \
 		cp $(srctree)/arch/parisc/defpalo.conf $(objtree)/palo.conf; \
-		echo 'A generic palo config file ($(objree)/palo.conf) has been created for you.'; \
+		echo 'A generic palo config file ($(objtree)/palo.conf) has been created for you.'; \
 		echo 'You should check it and re-run "make palo".'; \
 		echo 'WARNING: the "lifimage" file is now placed in this directory by default!'; \
 		false; \


