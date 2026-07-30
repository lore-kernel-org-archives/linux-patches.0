Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8853194A6C;
	Thu, 30 Jul 2026 16:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427437; cv=none; b=YGy2rQCOJbnqbsii4qh6SDfZWCo5st51a2roNNiF6AJhrqB/4Vg/s3pnyrp+CKBlONQqXEwnNOlkhoBcQreJZ5p46Lg4/t98BRQ/vwEA2kzQ3HarZFS17S20EAt8Cx1D5QXXPNoiINTGUIPdxiiGPmOeL1lpjvvxfpEXYAt1Tz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427437; c=relaxed/simple;
	bh=7LDD+J4LrLj4q72Ob5MmY7Pnuv0ZfID39ovVopo+kos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU07brtbZUwngVjmHKblr+cl4ARC4yjLWCMtyY+kWuQvVAN2N+VoEl68JzhYsf8n26NkK7LdkcS0Vlnc51PMxzyBfO+oLAglUVG/uhjoWinhhVPhEnCyjs/NuXgaDWbs1yj/mAm+cAtk9iMhGKwQP429IE1BNQyw6AVKW1ACZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQVTv9TP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQVTv9TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1321F00A3D;
	Thu, 30 Jul 2026 16:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427436;
	bh=B9blqChrgKpt19j4CUXhS/ePyPRx4ZZdIlz+Ok7yfFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQVTv9TPWO7mqExH5qW2fCJ1bT+TViVdArdQnp/Mwkr+tQgVatm37UR6g/58IW7bA
	 KXows2+ZdfUbqORDRrBtMqqs21rNovFGe7PhArsH78UcrHEl/wYNLrZui3qv+WJPtZ
	 6mlmjsrojfpZ8IAM0/PYfzRADI9tlJF1auSWGTBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/484] selftests: af_unix: add USER_NS config
Date: Thu, 30 Jul 2026 16:11:06 +0200
Message-ID: <20260730141427.142653476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit f8b1abed736111f914b2c567d9a3db1f71e788e8 ]

This is required to use unshare(CLONE_NEWUSER).

This has not been seen on NIPA before, because the 'af_unix' tests are
executed with the 'net' ones, merging their config files. USER_NS is
present in tools/testing/selftests/net/config.

This issue is visible when only the af_unix config is used on top of the
default one. This is the recommended way to execute selftest targets.

Fixes: ac011361bd4f ("af_unix: Add test for sock_diag and UDIAG_SHOW_UID.")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-1-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/af_unix/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/af_unix/config b/tools/testing/selftests/net/af_unix/config
index 37368567768cc0..9c4fb9c31c9506 100644
--- a/tools/testing/selftests/net/af_unix/config
+++ b/tools/testing/selftests/net/af_unix/config
@@ -1,3 +1,4 @@
 CONFIG_UNIX=y
 CONFIG_AF_UNIX_OOB=y
 CONFIG_UNIX_DIAG=m
+CONFIG_USER_NS=y
-- 
2.53.0



