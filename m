Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FCC31CA7D;
	Mon, 18 Aug 2025 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522751; cv=none; b=GJNZykKrf5YuWSW8G3fgkcWowDYIGl1cNjh/6mgn1iCJgxkWmXdkKcXvTA2+2dWAKVqsiGwPjhtaX3JhpX0HKf859GQ5832zbup7NqdT2XgEyKieugKFGL73jQO6O5DJB7+4K9bGhyvY2IWPRSkMWlXu4h6PCIvezgij2X7OJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522751; c=relaxed/simple;
	bh=cevtIg4MdZfhmfO8Bgg2mDHsQJTQmpbceQL5AbNIFeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFeBirTL70RjHneehu54c+OEbWy9jcAtxWd2FXYjggXuEZ52E3KvJnqCkoUnBvIeKdExoGz6oba7urZTVX1RVPFxNLIDXPp6KlnE1Gr0T2wn6REAHpGhkkJEjMMqitpf+gRF5v9xBddz10E9/4HgKezD+zeZCwxu4VeAiFrjaLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6oYY5xU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6oYY5xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C02C4CEEB;
	Mon, 18 Aug 2025 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522751;
	bh=cevtIg4MdZfhmfO8Bgg2mDHsQJTQmpbceQL5AbNIFeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6oYY5xUtoX8WVxFZpr9l+WZ83SKo92BGvkRt2q099O1nNwQM9oY4ld+2EXgBYxbE
	 geO8GXPBM0MTJkl6OqwHkcYotyZqNQ6aj7E9a7kETpctaUcurzmKPkZqjRc9wb+SeB
	 Ki/HvjZB+so6buCSAW9n3C8FfRddtQ29lFfs7ZZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.12 411/444] parisc: Makefile: fix a typo in palo.conf
Date: Mon, 18 Aug 2025 14:47:17 +0200
Message-ID: <20250818124504.336839241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


