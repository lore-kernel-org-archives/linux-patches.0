Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213507;
	b=Z09hXX67n6dtZBIjuDw2U1e9zA6sveofTkyBF901LXj7lEbwF4kUrBhpkkJHzuHEu7Qd
	 U6NBq6MxAA2VGjx5E4tS9ECq033jvCLbrGRfe9nmJ0TJWt4pqkVLYtjuSt8Xcb2pFbqGE
	 5NQrxTS3LD7p+DbJcav1vJKU6QndIq9UrsDNfrqJEUr8ioyK/2or1zhY044z3m3OWgMHG
	 NRsOWZpnQ2Mw25+6Eob8fcrarZjUYMKtK07wTbx5ZTdvRYMhvCy6P/4Y1yXp3cKsET6Dq
	 8auHIPO0jVQHitIYCwFsM0bAz8lggMQAdYQ6enrAHu+xa+hyllEkU8wu43E/LLOZH/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ImY3h+WL3IJPMJHyx++3B0WSWkTXr9vSNHBF2UUAXDU=;
	b=iyasWnG1GtAkKf3+X/EnId/0tatsrvsHBAWAjH+baxydsNBj8T0/KK8bANDXScUdF6SL
	 lP+BSPsVkcL+0OcpbYVFoCtQ15gVgh+ImUZ0/a4hEh7UjgOBy8OBNi+nVyqPlsC2LKLTG
	 3h8ts7FQemKkuXUSk9BQHQexG2+qoerRPrfhdSTkyb0vHKMax/W9Q6Y/kvrtbFqPVRoC0
	 t0mpSAi6Ko00FlfL7/SLDDMHwZrYHmpLLSeTz0Meb3dX7fHW0EgNnEuN5HZ4asjygeG2k
	 50+EYZ7yQv32kSwYU/ezQyrzmvIv9EIPa9ea2hf+MHmNeopjA1aTyz7PyK/DeM9jBGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cZ2FPkF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6704606A31C;
	Wed, 28 Oct 2026 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZ2FPkF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345F41F01825;
	Wed, 28 Oct 2026 18:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213506;
	bh=ImY3h+WL3IJPMJHyx++3B0WSWkTXr9vSNHBF2UUAXDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ2FPkF/bom/Pj7KQyzMACKV9qtGEzj3ZXbWOaFjlm1u9uEsbqY2UQUklj9s9Faav
	 LsdcLZUyLdSoJS4n+7kATgmtkxh2KcOted/CMycTlr3uQXJpajM64l6yyP7/WlQX0u
	 fXHdKyxXMIO5BB76krrBUmkGK6zjP70o/0DEi3Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0487/1887] net/sched: em_text: reject unterminated algo before autoload
Date: Wed, 28 Oct 2026 17:43:03 +0100
Message-ID: <20261028170510.349094815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit c9728fcf2e7fb4a7a8d08ebd9524c3b02ae1a021 ]

This is a follow-up to commit 9c572a83037a ("net/sched: fix potential
stack infoleak in em_text_dump()"), which zero-initialised the dump-side
struct. Sashiko pointed at a pre-existing bug that exposed the change-side
input-validation gap open.

em_text_change() casts the raw netlink attribute payload to struct
tcf_em_text and passes conf->algo, a 16-byte array with no enforced NUL
terminator, to textsearch_prepare().  On the TS_AUTOLOAD retry
textsearch_prepare() calls request_module("ts_%s", algo); vsnprintf()
walks %s until it finds a NUL, so an algo[] with no NUL reads past the
array into the adjacent struct fields and payload and feeds those bytes
to the usermode helper command line.  This is an out-of-bounds read and
a kernel memory disclosure.

Reject the attribute when no NUL exists within TC_EM_TEXT_ALGOSIZ bytes,
matching the check xt_string has had since 3ab720881b6e.

Conditions to recreate the bug:
- CAP_NET_ADMIN on the target netns (namespace-local via unshare -Urn
  is enough)
- install clsact on an interface, then add a basic filter with one text
  ematch whose algo[] is 16 bytes with no NUL (e.g. "A"*16) and
  pattern_len at least 1
- the add fails with -ENOENT and the kernel invokes modprobe with a
  module name made of "ts_" plus the 16 bytes and the adjacent payload

Fixes: d675c989ed2d4 ("[PKT_SCHED]: Packet classification based on textsearch (ematch)")
Reported-by: Sashiko (gemini) <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260918133953.12494-1-bernard.ladenthin%40gmail.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-2DIU.v1.20260929183844@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/em_text.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/em_text.c b/net/sched/em_text.c
index 32aae8a9dedaa..d612ad4e5c123 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -58,6 +58,9 @@ static int em_text_change(struct net *net, void *data, int len,
 	if (len < sizeof(*conf) || len < (sizeof(*conf) + conf->pattern_len))
 		return -EINVAL;
 
+	if (!memchr(conf->algo, '\0', sizeof(conf->algo)))
+		return -EINVAL;
+
 	if (conf->from_layer > conf->to_layer)
 		return -EINVAL;
 
-- 
2.53.0



