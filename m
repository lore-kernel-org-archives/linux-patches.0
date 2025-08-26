Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEA352FD9;
	Tue, 26 Aug 2025 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219167; cv=none; b=a2sUy2eTiS7DA2/veVtGJC0I43ymUeOTQmHoA/gZ+v4FGFFAIDHnc6pU+z3Zase6xFt4lei3Y9Efm7iRh+CFC41/vCS3HRkvwG7CkaB1YMiYRKWXV6xjjjXZZaELvGA887+psXb0qFVC1ly0QyuPGnqYuNHlRIZno55lK+rqW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219167; c=relaxed/simple;
	bh=xuqdUlLD7tnOdj/e0qjbCN1vwSWp9UGMpwcJ0YedjY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4tbmHASVXJ88z1QHlaodNwUiobNAxmaXiYBWU26srMCfng98sTGj9GmrrTrxcRFlRDSuGChq9+zquktltAINk1Cz2aeLm6aEaqJFoFJ+6gFyDUAISt8EerV6shwC0xtFBLlPuFx5eePlgg47Htnwd21J2OPyMQiDzs+FrWl62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeWzgX3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeWzgX3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A07C4CEF1;
	Tue, 26 Aug 2025 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219167;
	bh=xuqdUlLD7tnOdj/e0qjbCN1vwSWp9UGMpwcJ0YedjY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeWzgX3YOPRfQ7CRw46iTcqCV9t0SszICg1uG9rFGMnhxL+yVDwSAv1UtSDaCi9Rf
	 MuYHCusC81IEPGTFoUR2BTJhrOqoko67RAH6N7a5fssoMMEbWhaRfMRvNCpNRWvNFV
	 OJCMvyoMWvFljbfx9VDOqxWe1oLibYFMp65hIx0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 5.4 278/403] parisc: Makefile: fix a typo in palo.conf
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110914.477838065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,7 +134,7 @@ palo lifimage: vmlinuz
 	fi
 	@if test ! -f "$(PALOCONF)"; then \
 		cp $(srctree)/arch/parisc/defpalo.conf $(objtree)/palo.conf; \
-		echo 'A generic palo config file ($(objree)/palo.conf) has been created for you.'; \
+		echo 'A generic palo config file ($(objtree)/palo.conf) has been created for you.'; \
 		echo 'You should check it and re-run "make palo".'; \
 		echo 'WARNING: the "lifimage" file is now placed in this directory by default!'; \
 		false; \


