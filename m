Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036075;
	b=vT0PkqxRnK55SrMcNm6LGcS0hI1EvfTNazTyXI9l9CWmtdj0msl4RP3xL+GqVgeCkmlc
	 Tvpk32GDkWtOdjjHdYcAhuIkO7hVa89RjPX12tmaITR9G5kfXaLoQGIs013qDDW5IyRWz
	 DdXAU5541S3tcO5p7FF8EWd/nE59SnNKPdS2TXabk/hsdPeij+Nli+NhII5ZftmXyqY4z
	 6CBiKfp1zaAW8AQYh+NoNaSHEYN6x39/oLB8eH54RSwCqtgufLCZ12aXdcoKKrsCVTd6O
	 Kvz/v6YqQjk3Tyw5PxRsPCkM9ZkDlF26+ChDP0o0cxh+osI+oxjUsj5N4jBo/+9M+Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xhW27cXFJU+HTkmEYulU0TrARcyh67d+EgH73rbR1LE=;
	b=Y873r9E7e7oy9b7/V4Ja/laxqgSPbcoaEKcjRu7e6dB7Qtfdslt0x8fNQAr3TDZfvPLO
	 YfbGoSx0mORs85aZE4Tt+lHmNV1vmEgHJ7vdVejhZfbeSn5ae9sjLrMVnh5e7WckipfFi
	 Cyb/Mu/oJqidfIHQqLA9O1EDQaUKRwQFA9txG1W1CIKnPlrphkb4gr66s875Pqs8bWroZ
	 u8DMoo8bH5zh+HBd8uATk+iTO0G9ZqNg61+7Ed/+9OuV5qhTtxsnkhdW+vbgDnOjbWamt
	 LVPYOFiIGYK3SoDIn/MU+feAHb7vjqNTZXuZ0YXvgSCclrkMvaYScUohb4549Sx+Yrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrFKfYOr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861B606A320;
	Wed, 18 Nov 2026 21:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrFKfYOr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFDF1F000C4;
	Wed, 18 Nov 2026 21:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036075;
	bh=xhW27cXFJU+HTkmEYulU0TrARcyh67d+EgH73rbR1LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrFKfYOr5BlpANDPae6n1cd55K87HYHYO90i1dXmeS7uT0TB18HO4Ok5Uf1Vv7b68
	 v8PywgJmYGXGAQkM42ijyZwgZPziWiEvzZZ3wYE/ZPDxvAIoYJZ0by3knBU+gMsR1m
	 cGzr5rb6S3uoChW61e9ljhRTYYeENE/sbGlKDPXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0931/3318] kobject: fix out-of-bounds access in kobject_action_type()
Date: Wed, 18 Nov 2026 15:25:53 +0100
Message-ID: <20261118150347.478418792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiacheng Xu <stitch@zju.edu.cn>

[ Upstream commit d516455c940555566642b975d1835c67f08136b3 ]

kobject_action_type() compares the input against each known action
using strncmp() and then indexes the action string using count_first
to check for an exact-length match.

An embedded NUL can make strncmp() return zero even when count_first
exceeds the length of the action string. For example, the five-byte
input "add\0X" makes the parser access kobject_actions[KOBJ_ADD][5],
which is beyond the end of the "add" string.

Check the action string length with strlen() instead of indexing it
with the input-derived offset. This rejects malformed action strings
containing embedded NUL bytes with -EINVAL instead of invoking
undefined behavior.

Cc: stable@kernel.org
Fixes: 60a96a59569b ("Driver core: accept all valid action-strings in uevent-trigger")
Signed-off-by: Jiacheng Xu <stitch@zju.edu.cn>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Link: https://patch.msgid.link/20260920053726.22626-1-stitch@zju.edu.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject_uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index cd6db04f30c33..cb64874288bfe 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -84,7 +84,7 @@ static int kobject_action_type(const char *buf, size_t count,
 	for (action = 0; action < ARRAY_SIZE(kobject_actions); action++) {
 		if (strncmp(kobject_actions[action], buf, count_first) != 0)
 			continue;
-		if (kobject_actions[action][count_first] != '\0')
+		if (strlen(kobject_actions[action]) != count_first)
 			continue;
 		if (args)
 			*args = args_start;
-- 
2.53.0



