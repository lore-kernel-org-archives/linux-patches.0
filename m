Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19958223338;
	Tue, 26 Aug 2025 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217976; cv=none; b=Frq/8hW1CsRQYL6R07Y0Rskzha6/Cea8LDxoMluM6Jmw7V/5DKc0WCokL4DpUElLHZzc+AdioEbmWQfFMNsFmounVNxnh2mO92x1KO00GZCcbRrb7GFo4hvP4IY6V6mzrYo+FIoJ3DMaiMqL0gxiIBed7f1OyPSbUK/nchPd6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217976; c=relaxed/simple;
	bh=go3AzjVbv6MRKBiY6KYTphkt6TB9GXG7pUQPsi8jCkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/5CIheGIqCflezWSjqLOeky6ylrA9WvQWByGtb1tPEPgISBwMsZfhBMQnME3Uh9TwQmm8kljNbJVEYz7jkhnW1tFeRli3yoAbN0SQ9VdqnqabSzQQfd+lPyj5YCRmn1PSML8iThFUo4F0LFdunm7OPhr+PZmhasyJUig1hy0/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4Nzb+wP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Nzb+wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9DC113CF;
	Tue, 26 Aug 2025 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217976;
	bh=go3AzjVbv6MRKBiY6KYTphkt6TB9GXG7pUQPsi8jCkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4Nzb+wPwVg33cZt5EGec7XQJEfljqUsW5hyAXchv3+AGdNTcGgBNpYHI8a6t57BD
	 czGofjJm5xnJyEjSIy6onyHgmdyxJw01UPtW1W+AMr3FIdcXUZFppkoLwq+cyOulko
	 wN+I2udy4mzf72W17KjxiJFAymgHGQQItSUkk6mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 5.10 347/523] parisc: Makefile: fix a typo in palo.conf
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110933.027297519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,7 +141,7 @@ palo lifimage: vmlinuz
 	fi
 	@if test ! -f "$(PALOCONF)"; then \
 		cp $(srctree)/arch/parisc/defpalo.conf $(objtree)/palo.conf; \
-		echo 'A generic palo config file ($(objree)/palo.conf) has been created for you.'; \
+		echo 'A generic palo config file ($(objtree)/palo.conf) has been created for you.'; \
 		echo 'You should check it and re-run "make palo".'; \
 		echo 'WARNING: the "lifimage" file is now placed in this directory by default!'; \
 		false; \


