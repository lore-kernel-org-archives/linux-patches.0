Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A83D143C76;
	Thu, 11 Apr 2024 10:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831322; cv=none; b=Rebsxuto0IHS0tpv0NW9u1D9/NDaDce/B/gT0daFieSUdvl00p8J92GB49HFI6SrxOfMWvTly0ZehX1BB+g9xUZBupD7PPk6wwTzrfXLYEWEWk7mj3pKk4IuZpoH+ZQch5nLCItkph93DN1Raz1nFVZjr4BR3h2Wz+iDlJjBch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831322; c=relaxed/simple;
	bh=nPHAh0pd8KRDgMf0D5grRZG9GVts7ZkyU72XMF9qwG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpsVPGziS/4czXiGAmaA1vUW9DQBOU/FWouhyOUAVQnLoVPgUjSP3CylRPUXwc3HtGvESLJVFXo32mWQ+vzIf/nN56/TpI0H+ZKun0c47lkAsZIHyhppjMXHJFnYHHn6+/7+Mm9JO0lg43yXaqttgrvkUHYRrMhpknhNFlQeTtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuCxX+Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuCxX+Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38BDC433F1;
	Thu, 11 Apr 2024 10:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831322;
	bh=nPHAh0pd8KRDgMf0D5grRZG9GVts7ZkyU72XMF9qwG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuCxX+KjGWYHXfwDHzjZwGfbxO57NX2q+BmMPa5FHuXcplUze1r3ZUFme9fUIMJk1
	 6qYcGPrxKoqYFWvyjd43EriB51Y1a3iJvNq+SgYBcHuX2VPL4XxLGKbTVZicyLxCmP
	 OJ+kR2DTbwCWZR/lkzEpD7+0vHX1X44ihb6XeOqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/114] ktest: force $buildonly = 1 for make_warnings_file test type
Date: Thu, 11 Apr 2024 11:56:50 +0200
Message-ID: <20240411095419.394514665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit 07283c1873a4d0eaa0e822536881bfdaea853910 ]

The test type "make_warnings_file" should have no mandatory configuration
parameters other than the ones required by the "build" test type, because
its purpose is to create a file with build warnings that may or may not be
used by other subsequent tests. Currently, the only way to use it as a
stand-alone test is by setting POWER_CYCLE, CONSOLE, SSH_USER,
BUILD_TARGET, TARGET_IMAGE, REBOOT_TYPE and GRUB_MENU.

Link: https://lkml.kernel.org/r/20240315-ktest-v2-1-c5c20a75f6a3@marliere.net

Cc: John Hawley <warthog9@eaglescrag.net>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 829f5bdfd2e43..24451f8f42910 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -843,6 +843,7 @@ sub set_value {
     if ($lvalue =~ /^(TEST|BISECT|CONFIG_BISECT)_TYPE(\[.*\])?$/ &&
 	$prvalue !~ /^(config_|)bisect$/ &&
 	$prvalue !~ /^build$/ &&
+	$prvalue !~ /^make_warnings_file$/ &&
 	$buildonly) {
 
 	# Note if a test is something other than build, then we
-- 
2.43.0



