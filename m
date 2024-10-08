Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AAE18CC12;
	Tue,  8 Oct 2024 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389691; cv=none; b=JHBhBwwnqUe0MfV/O8j2oVqvQ1A8MykFhAaj/H4pMTCO3F0kcXbUGpHy6K48ufAoki10JLHIkKOVPrMwoy4+vXTTom/crGZCsMKTepwztovsOknYxjS5oT27DJ5L1LJ03jdmn+9v6x5fas8xQvosomm2YLNTX/XqLVk6t5STQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389691; c=relaxed/simple;
	bh=YgFRT5KqNB2jA+QYKMql6arwe+J6VrYc/UmL8vFuCfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzZQYlSdPtHtSYAi2Em0qcMYa6vlLp3C7Qf4+ByFvuHG42l6fTKi5XWKsEwGFkpI/zdoFjYabEZ3Cvzk5k19ia1YmRZZX3kIZ+kMQ0hlLWnlql+U7V6Z9HmJ1bUMS/UDljB3mnC5V4KpW+b4OBUPmJvnsoT7ZHxH2SC8qLHVkJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gJ/lOdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gJ/lOdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60F0C4CEC7;
	Tue,  8 Oct 2024 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389691;
	bh=YgFRT5KqNB2jA+QYKMql6arwe+J6VrYc/UmL8vFuCfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gJ/lOdFjsOQaLHMC8N2iO8SIjRA4B/hcR7TquMo4CxR7po/VhwAIi2FR2u3MJjgk
	 /Ox4/MusrmesRb/i3Yf2z4AnySfEf1ZRUN1B0LYU43e8plMXxcHYvd/7X6LqgJZS2A
	 n3jPzOzoibvbsP7RIAuTbh76QQvICl+7dNPpP35Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Ben Hutchings <benh@debian.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/482] tools/rtla: Fix installation from out-of-tree build
Date: Tue,  8 Oct 2024 14:02:11 +0200
Message-ID: <20241008115650.984069218@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

[ Upstream commit f771d5369f1dbfe32c93bcb4f5d7ca8322b15389 ]

rtla now supports out-of-tree builds, but installation fails as it
still tries to install the rtla binary from the source tree.  Use the
existing macro $(RTLA) to refer to the binary.

Link: https://lore.kernel.org/ZudubuoU_JHjPZ7w@decadent.org.uk
Fixes: 01474dc706ca ("tools/rtla: Use tools/build makefiles to build rtla")
Reviewed-by: Tomas Glozar <tglozar@redhat.com>
Tested-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/Makefile.rtla | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile.rtla b/tools/tracing/rtla/Makefile.rtla
index 3ff0b8970896f..cc1d6b615475f 100644
--- a/tools/tracing/rtla/Makefile.rtla
+++ b/tools/tracing/rtla/Makefile.rtla
@@ -38,7 +38,7 @@ BINDIR		:= /usr/bin
 .PHONY: install
 install: doc_install
 	@$(MKDIR) -p $(DESTDIR)$(BINDIR)
-	$(call QUIET_INSTALL,rtla)$(INSTALL) rtla -m 755 $(DESTDIR)$(BINDIR)
+	$(call QUIET_INSTALL,rtla)$(INSTALL) $(RTLA) -m 755 $(DESTDIR)$(BINDIR)
 	@$(STRIP) $(DESTDIR)$(BINDIR)/rtla
 	@test ! -f $(DESTDIR)$(BINDIR)/osnoise || $(RM) $(DESTDIR)$(BINDIR)/osnoise
 	@$(LN) rtla $(DESTDIR)$(BINDIR)/osnoise
-- 
2.43.0



