Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DD43BDCB;
	Thu, 30 Jul 2026 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421965; cv=none; b=dzZhsBsKum+XVWrUmg6u1h6ySenXG68S4Z039+lgmrICBD+QZzHvnaLGUQPX/DxxMWQPAzCExGOqQvFNUYF1Vf2VyJGNUMuRswMvcg4+oCh/QkA9/cy0qFaM15stqB7xXnIwfm7TJDcTZaE6LN+lMkybZo6N4hm0DDf4alk13bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421965; c=relaxed/simple;
	bh=M8MnM2MxWpemrR+QU26EbgRWEOZ0zpJ0xuS9tmkdRB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMMOrxefQBWRPiSZztqnqgE9e3GdQmpmdR7vgxdoK04wQ9P51CG+EPBUTpnpbEVdLco9S0vuB2UbuKmf76w7sZ0f4VtDFQQbMzTOEDcDJN8f1E4VPOoVijfoB5oOl3472QOcLKUZhO7+sR3sKrGeFxAtprqDzQw5rbvPask+wG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K48qfI0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K48qfI0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA381F000E9;
	Thu, 30 Jul 2026 14:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421964;
	bh=j/65vdS6IZC3xZ2pRf007MjD6hKAfZhH3JhDrAINF3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K48qfI0Uh4dLBTBMkPb5rjQZlXn3Rz+6oBoJ6K/glSVfLTUfV/OVbU0qoO3urOlA7
	 MjNBfKWdlt/Aooz2hPE3zdNOB9OKIr/vhZn3/pO5vl7flUF1NDBri6YICtJOdY45HK
	 RGCtQXXr0cRk59S0lXPD2HCGEcgtpeOhl5XHEsGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 280/744] selftests: ovpn: increase timeout
Date: Thu, 30 Jul 2026 16:09:13 +0200
Message-ID: <20260730141450.239488900@linuxfoundation.org>
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

[ Upstream commit 61ac7049aaa86ae044e8a5b94d852218163d5bf8 ]

The default timeout is 45 seconds, that's too low for a few ovpn tests.

Indeed, these tests can take up to 50 seconds with some debug kernel
config on NIPA. Set a timeout to 90 seconds, just to be on the safe
side.

Note that the Fixes tag here points to the introduction of the ovpn
tests because I don't know when they started to take more than 45
seconds. That's OK because a timeout of 1.5 minutes is not exaggerated.

Fixes: 959bc330a439 ("testing/selftests: add test tool and scripts for ovpn module")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Acked-by: Antonio Quartulli <antonio@openvpn.net>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-4-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ovpn/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/net/ovpn/settings

diff --git a/tools/testing/selftests/net/ovpn/settings b/tools/testing/selftests/net/ovpn/settings
new file mode 100644
index 00000000000000..ba4d85f74cd6b9
--- /dev/null
+++ b/tools/testing/selftests/net/ovpn/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.53.0



