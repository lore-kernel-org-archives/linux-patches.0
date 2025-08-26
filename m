Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA12FC870;
	Tue, 26 Aug 2025 13:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214759; cv=none; b=lJ3g58am5BYS2x3gfDY4M3+/5+eJTvsQh2mehkNyCK0+q4w86AtjrnJgOnByZ7labOOxNQs7/FWVGG6mZ9biiq/q+R+kX/IGnfl4mibB11s6Pi7rCBtZrX2xZOFHmQO0QWhohccGPgGizQOflWoPVqdRTjzVe+4nsAUh26BtSrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214759; c=relaxed/simple;
	bh=2aSOwWj4KAnALPS5dkVb95GCioZvAOgQ05uk+RvjlGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udD8SX7s5Pc8WNdXnzJ9UQUVeAc6SZtJ88k6n0BFAqX6A/YCjRpGzC1TjhWNS/YhMwipqXQSW3I1GqEajPmBcGwUNBVFh8iQ9ZRJjn/4dsLAAC6391N5SZLLSd9W3arQIKCfLXVzRitexY2kV6LLSrDMewJfU7WP0/ODP7VSWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq7eNAto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq7eNAto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A238C4CEF1;
	Tue, 26 Aug 2025 13:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214758;
	bh=2aSOwWj4KAnALPS5dkVb95GCioZvAOgQ05uk+RvjlGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq7eNAtorvvV9AaRIDHgfbmnTN0a/itivE0IcEuRolMfql1CwxuUXwCh4iGzmfNoC
	 8fOPEgrihjuTBobdmGW9XPJ/NZRJzvstJ/GyKtfky9jx4LcSI4Kkmzms+yGbcN0SBB
	 BUHOtpxgo2RuLJnUguaWzyTUIueXG1V9NIHPnnT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	linux-parisc@vger.kernel.org
Subject: [PATCH 6.1 259/482] parisc: Makefile: fix a typo in palo.conf
Date: Tue, 26 Aug 2025 13:08:32 +0200
Message-ID: <20250826110937.167641613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -137,7 +137,7 @@ palo lifimage: vmlinuz
 	fi
 	@if test ! -f "$(PALOCONF)"; then \
 		cp $(srctree)/arch/parisc/defpalo.conf $(objtree)/palo.conf; \
-		echo 'A generic palo config file ($(objree)/palo.conf) has been created for you.'; \
+		echo 'A generic palo config file ($(objtree)/palo.conf) has been created for you.'; \
 		echo 'You should check it and re-run "make palo".'; \
 		echo 'WARNING: the "lifimage" file is now placed in this directory by default!'; \
 		false; \


