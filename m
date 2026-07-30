Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21B440A06;
	Thu, 30 Jul 2026 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421956; cv=none; b=Ecc9Qt7o06enHPHp3nUJBQlaArBT4BNXUQR98tuBsWRr+g9FFEluKK0FL0CDvZsmZvqwLQOjk3UyFtLhR4S7HiD/rsbj+rAd3VR3C9nILt86ISFsUiSuqOTXb/iWodxno8IJOM8TpKS37/aMehxtrY4Y4+oQVxxvHX9/4EMwqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421956; c=relaxed/simple;
	bh=CeLmmabubKnN1J+SsreHFNAskbdNldDN8QHpgWCkJEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkKPakur8ZxENCacsWNmTIcNZpswWjMC0nEWxav+7mPIxadzrW/CRI5EqlD/p2AI/+L5tOGzagzPfXH/txkHuHYysFlzya/r9ORkLLUgn4zSxgFZHDmTWPvQbW2mtQfXnVA9rpJy1Twf8DC1u4g9tEuCuVNfnYVkotlincwMyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uac180tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uac180tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7F1F00A3D;
	Thu, 30 Jul 2026 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421955;
	bh=TlgA7A4EIAsnc8eZUA3KMvGrtlacp3gyufi8hMa3o3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uac180tBDchE5AlGOhG+dBH/EV9p+aC+LRGBPi5afqTCpcHj6P99TIOfz9kdx8CVx
	 bf2p3le7mKyUr+7luJscLzLu6/9w7XAVd3OIQEvFUtfxqKvZGrXvDQmIFPE45d+JM4
	 cQmcdE2dV+8Vc1k2xZdcOxt5RcIti1NwVOT4aqlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 277/744] selftests: af_unix: add USER_NS config
Date: Thu, 30 Jul 2026 16:09:10 +0200
Message-ID: <20260730141450.177133729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b5429c15a53c75..41dbb03c747eb7 100644
--- a/tools/testing/selftests/net/af_unix/config
+++ b/tools/testing/selftests/net/af_unix/config
@@ -1,3 +1,4 @@
 CONFIG_AF_UNIX_OOB=y
 CONFIG_UNIX=y
 CONFIG_UNIX_DIAG=m
+CONFIG_USER_NS=y
-- 
2.53.0



