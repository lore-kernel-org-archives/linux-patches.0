Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B35A192594;
	Tue,  8 Oct 2024 12:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391422; cv=none; b=d9aRqECbx4l7hEvmZZi1/33dGO/Y2VLRkR+3+NXD4NjlqEJrEATNqoukOROcge8Sjb6Vxs524G2+wN69Sf5GsmfZUZaqO3RkGvQVIxUYzJxFloK3KdFN4rTqNoQp7r1j9UIl4RI6blFqlG2GiFtFEcNws5k8C3eAuoKaYVRwIQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391422; c=relaxed/simple;
	bh=oLqsdmTmlW2kWSwm0fT4R+CP5p7oGXEQxPa/gKMEu6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/zI3IjCfeJCPEpYPUMjjusyXZJTctAqmp208EXuv4AlXDVVF4qyGwsKeA/0Kr72aHBuBR7GbsHzbn5qpOenbq5m4V1ONxJU52IstJpUfrOA3NJ9giqMjywalavQHTFaBd5xu3scudSl13/jpwDHNtl8xErDyKWB5E6oNiny6SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmWbZeS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmWbZeS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE8DC4CEC7;
	Tue,  8 Oct 2024 12:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391422;
	bh=oLqsdmTmlW2kWSwm0fT4R+CP5p7oGXEQxPa/gKMEu6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmWbZeS3Zw7PaNSY/4aD1KQLlZPD4hwMBxgJOfiaEgYcCmbqKJI1nCPnfc8vlu4oD
	 aSzb89WhqNlYUkYAfli/i9ZcZjxqJhEsEAXmkMQiW2ovd3M3AVzksrURLOnu8QX/lT
	 jOCGNlyRs88yH45rFGqlxN0s8spSoz9639lng76c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Ben Hutchings <benh@debian.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 077/558] tools/rtla: Fix installation from out-of-tree build
Date: Tue,  8 Oct 2024 14:01:47 +0200
Message-ID: <20241008115705.406651073@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



