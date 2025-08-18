Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5720D335BC9;
	Mon, 18 Aug 2025 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524494; cv=none; b=sjNnWMe1QUym3NsdYyU2akq+vD3BqfYMfAUpp8u7UZ/0EXDU1RBvAaEwCDH8poLQjcMOTTvkz48ZBWjSyAS40ttMEKcuMIqjTHYXqKsQOvDOFC9g1NPTw+k559UlxfZCujDB30Xp+noHn/M6Ma9uQAcm+N8TXWf+iv0Ng7TVXYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524494; c=relaxed/simple;
	bh=WakBklAWGLjAQSOVjTQC28FD2Qtt2Tza2Sg6CDUknGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkj8M/xDQA2i962sQd70jD4TrMXRTYOHL1weSPaWdJzDG9EKTJoGKbyqW6zyPILHL4Zfj8hm6IumFFzN6cNxTYd67icjp7i9TPnbmwNTSaHzuGg95zTSs1Zv4PXt3/AL4Wj5N0KR8u99YHh+2xTGlqgeTP3EhK9ymfNms2VJr/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBa8cy+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBa8cy+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699A1C113D0;
	Mon, 18 Aug 2025 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524493;
	bh=WakBklAWGLjAQSOVjTQC28FD2Qtt2Tza2Sg6CDUknGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBa8cy+BsBHDYOJS9JXuFC1PETyHwwS6iulrmzk0ty58gp/7PBSTuwy7vo6QLUbeP
	 BCKbdn6cJvegWeKhKYcjQbjRjRKez6iBMhrTRkne3Q6w0YyqL1b4fp5JtJ0QU18ntJ
	 opvIHrNyphVDI/5YVaEDbfKMitEY1wFo3hxhc0MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.15 489/515] parisc: Makefile: fix a typo in palo.conf
Date: Mon, 18 Aug 2025 14:47:55 +0200
Message-ID: <20250818124517.261069211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


