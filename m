Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CCE21E098;
	Sat, 30 May 2026 18:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166956; cv=none; b=g4BtTUiAJS5njcngVAX5qqgZvmP0iiMEEA4usvVGcReuGupohVSC3IsJkcnI6jz614AaEfC7bhYiumrbdlBiOG1h88x7PqSSwJJEkhSaMUUEdeI4XBpBAInJkaV2F3NWKTs3mOLG24+4NDSeF1+nY9rhbLEiLI+/566fF3Mi/w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166956; c=relaxed/simple;
	bh=k+9YcnxZ0oxDdji3Unt1iulHTN7O288J8mLxsLA3I/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK7Eu0yWwuN5lOsrWgv4yvGFvm6DLt8NpqhgoeJXgcmqWObPh8ytULOE5PZr73//oM03l5HM0DL23KiFbwXhDuuRRUrag80AFYGXHxZCQgtg1X6MDcni5GbBfMhs91WWkQoJKb97tCBA2Cu60qCw8GXYtIG6t81x82y5qZ4C3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj/WqsCe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj/WqsCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5958D1F00893;
	Sat, 30 May 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166955;
	bh=tvDxUKrxC+TYgUl4+FAZWJqYBDDfNgB6f1OLehyor0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj/WqsCe6KGfsa7/P+6VwUHmJ4Svp89Ej1PAA2FBdVUXjEcs8EzXm1odMZ0eTbQOf
	 q2YjgpjkOfctm9CoMjG1Q9GhMvUIa7BBMIjFgwUPiI1CWLAa7Wp2QRlYsUeN5WTE3j
	 xSid1LOyYZYPaTSPK6UsaCMTTDI9bW0WWoyqRRoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/589] selftests: lib.mk: Also install "config" and "settings"
Date: Sat, 30 May 2026 18:06:43 +0200
Message-ID: <20260530160238.334837451@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit de53fa9baa701963722e9fa3d0fe34b897104497 ]

Installed seccomp tests would time out because the "settings" file was
missing. Install both "settings" (needed for proper test execution) and
"config" (needed for informational purposes) with the other test
targets.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 56e360e019ecc..a3df78b7702c1 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -101,6 +101,7 @@ define INSTALL_RULE
 	$(eval INSTALL_LIST = $(TEST_CUSTOM_PROGS)) $(INSTALL_SINGLE_RULE)
 	$(eval INSTALL_LIST = $(TEST_GEN_PROGS_EXTENDED)) $(INSTALL_SINGLE_RULE)
 	$(eval INSTALL_LIST = $(TEST_GEN_FILES)) $(INSTALL_SINGLE_RULE)
+	$(eval INSTALL_LIST = $(wildcard config settings)) $(INSTALL_SINGLE_RULE)
 endef
 
 install: all
-- 
2.53.0



