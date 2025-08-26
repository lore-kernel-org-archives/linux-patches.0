Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99175148850;
	Tue, 26 Aug 2025 13:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213359; cv=none; b=F9SO8rjQ22XVItDkdSW1QzT4Jyq+zMj//b1c1oirCBxMZbg2m/In2Fz/WjPP/6BOOk59Qxs3OJ8pm1EWCiVe/39erU5CSqxL08yA+JCjhFg7+2QhzZbQQN7amPJzBrD//SfistAsjjIYwVLtkmasRlq/JLIfpV2hm85YfRXYcAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213359; c=relaxed/simple;
	bh=7pkzUmMMZFiWDRO8fL6duQqEGW7OoSkBoeaSNKG2SJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz5CP3T3q/Z2CrZiCV/X5npvDgv60QHaSP488Kzuv352Prp/f0kXE+AHry1kY3x382I3sFYNfjTzYfxxABeHUynGIV5MxiR1WPjYW4WG/Zmwry/2dqD2uAgquHVxs2pi6EfZHz3ATpaoEP+KqQ8UkFrW6s5wfSo6PPJejCEm/WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uE5Ysjc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE5Ysjc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28650C4CEF1;
	Tue, 26 Aug 2025 13:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213359;
	bh=7pkzUmMMZFiWDRO8fL6duQqEGW7OoSkBoeaSNKG2SJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE5Ysjc8Kef6d2VPT/oQzJS1nOolWRQ0syFJRontSmib56Rdna4QOL0ZqY4ii3Arw
	 2PLJpmSz3/sEoI0UVTEPCGs8jJs/G1Vl5ghNmfiRXv2Zz+iEQbI9lsQIRHhwZNyxlY
	 7PjaEP80qjT6SYIaufpFVMhHhHgAP5ef6vdg6xBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.6 318/587] parisc: Makefile: fix a typo in palo.conf
Date: Tue, 26 Aug 2025 13:07:47 +0200
Message-ID: <20250826111001.004620857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


