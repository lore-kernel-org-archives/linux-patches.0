Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209108;
	b=mrHU7toJ4iSuFjqQhyPj5WiICy2fLR/vqyGaxObcskcz/Mk/E45PXxOKqZ8yW/j5EJHG
	 b+seQZK5IeLQEr18sMSoenVtC62NbIgeh6vBhd/cOoDB8nxuVYwukSI2wpATm/8Sho3tL
	 vOIuFJy65q2ncL/wrXd8ErMeDzUSekXhjKW3N0GeloapzA0+diSIZ0dB+zUT5gZ+XWfhL
	 E7+PsCx0TnscOEIQs5zfXVvNbem8sokHCZh74awZ24cBixZkTKuAzlWq5MtPBfTA97qaP
	 rY+w4NABn3+Nz2gLIuRWXiIFZRxyD+t962mxdnIfItvtBQlXEYWsVvOwVJYHbir4dUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X5FBKvS4d1/7BGMTQHICiMfRyLYYF8lHrsyw7q4KRnQ=;
	b=RHa6KZX8WrpO9XAw3G0ZwBqyP0mm9s3inUby2Hq97MFZzLAmSECJH60Fl5HVmQe1DG0S
	 V1sWLfrK9oOrYYiycwdepDbvng3GhfTE6qdf6POhzASsMABPcuF/7QJlF/JgjiHecIomD
	 KtZbk8DxPYvlwxYFFZBasacdAp2irfhc1FyLxA11mgtEysnn/lYV/+ihb3mpCsZfvtSe9
	 htW32ojQCQ0sQ4XPDVa7fa49f7oEzOS5g5LTJTfeGuoeA7wNj5tDdEJbZdSLmlxOO6Bxj
	 468JJFTCZM3qHzzFWuECWfKmyJlrO6wKq5WfMowjjZ+g34QJn4NwtSSQnyxK5bJkBVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR0pEmmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE5606A32F;
	Wed, 28 Oct 2026 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR0pEmmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BA21F01825;
	Wed, 28 Oct 2026 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209107;
	bh=X5FBKvS4d1/7BGMTQHICiMfRyLYYF8lHrsyw7q4KRnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR0pEmmVwEYmfm0LVtjsveQlL785JRD+O8Vex53cHZHPNPfvm1WIdXpjeHRIY4TsD
	 JenoBm+JMrg0o+6bJNiUnv38P43NaEhbMiikJ7/FDgRV8BhLEC8b7a8bKmmAvuoJ3y
	 k29h6oJueptQOEMQXMVME6Fx+5tlWHmWBMB4zM6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/516] net/sched: em_text: reject unterminated algo before autoload
Date: Wed, 28 Oct 2026 17:58:27 +0100
Message-ID: <20261028170011.898456112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f176afb70559e..1df4d16f44f3e 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -51,6 +51,9 @@ static int em_text_change(struct net *net, void *data, int len,
 	if (len < sizeof(*conf) || len < (sizeof(*conf) + conf->pattern_len))
 		return -EINVAL;
 
+	if (!memchr(conf->algo, '\0', sizeof(conf->algo)))
+		return -EINVAL;
+
 	if (conf->from_layer > conf->to_layer)
 		return -EINVAL;
 
-- 
2.53.0



