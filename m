Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B8374C4;
	Tue, 26 Aug 2025 13:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216541; cv=none; b=TfSmOrio8f0J8BYxC65ScThs5npS+BqgW0+q8WHSmDDSac42wGI06OUmsUSjxYta9m6zIJsZqR14FbLrjEJevP8jLmqMx2hpFUXBPZTeSGU1SQB5tZYYniyxeEwITdpHsb/CKpJPyW/pZiiMyQbuKAVKwnVz2kQfVS75SnKm/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216541; c=relaxed/simple;
	bh=gzJdsmBul2iw/7lBpQ6SouYkMtI9HXN4ofXEEgtFUvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqokJTk7EbUAELfZzL6J3/BeFd/SsjAju3uFClpCrych7LQaC8KFsfQ/zgVQM/6yHCrPwCsYwXsjQib6mAUboNo1DYpNXESincNlDPN1/B4mgwLlLyQmVK4ZMh5Evjk553ugRrkrnx5cZ+dMU0gnTOzI536rg8Z+KvVbryHbJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0DHWVnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0DHWVnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89707C4CEF1;
	Tue, 26 Aug 2025 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216540;
	bh=gzJdsmBul2iw/7lBpQ6SouYkMtI9HXN4ofXEEgtFUvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0DHWVnYRtVX7aSRKFjuvJlrW2eqvxl1Xc2xSEqAOiJl11VTa//ikL9nM0FKZY1SZ
	 TajQ9zVBUKNIksILJ19Y3dLa0jAa8+aSf4k+OF83HR31s82q5J32OjSIGzhbnoljJG
	 umCY2X4Zl4O9BXS1J2qXH9NeA8xyIPA36VvwWqt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 5.15 450/644] parisc: Makefile: fix a typo in palo.conf
Date: Tue, 26 Aug 2025 13:09:01 +0200
Message-ID: <20250826110957.623770011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -136,7 +136,7 @@ palo lifimage: vmlinuz
 	fi
 	@if test ! -f "$(PALOCONF)"; then \
 		cp $(srctree)/arch/parisc/defpalo.conf $(objtree)/palo.conf; \
-		echo 'A generic palo config file ($(objree)/palo.conf) has been created for you.'; \
+		echo 'A generic palo config file ($(objtree)/palo.conf) has been created for you.'; \
 		echo 'You should check it and re-run "make palo".'; \
 		echo 'WARNING: the "lifimage" file is now placed in this directory by default!'; \
 		false; \


