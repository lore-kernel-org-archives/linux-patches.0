Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058287;
	b=lXqNl4i3hPOxOYYHyB3p+p106J4Z9F4zFWXfHMBiqxKoPI3ixpBli2J+M9dAxMmTqx78
	 6+b0XcZFYoEynBmMhzqQVIBHL8NoBRgnGYafUF4Y6m5k9ZSCt3+UcwTh7jyC2fv1ZgMqO
	 wQeazJVRWCPFAX7Hmhut+F96WBpAKO9LlF5eJVWiDQmWAs6zQvPl25DaCMfp4QwqCL5kR
	 Yz3pNYZz2Rb8680LVXTiGuZfEuxgxQ+g8GFzI5BwpHFF/+krYHt20lZOybzdrTfUpNWIJ
	 QlPA9MPr92r2lAI3tG9mXJWbgQJlvTBbcFHTw8EH25Wwp/q5ql5B79nGOLo8bvYWklw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtpQ5HCBbixDyVnzFFOm4cyOof0Tkxv0heBiFxBSbtc=;
	b=Ry19AIRLsDdC2jfeCIkqpGRg+4kK+K5q2S2J9tdb33fOTlNLAWpEoEmTyGuLFxHBBI8e
	 Ab8A5Oz3avw9S1+4LJHcfaV6Rft7elo7MyvqNiUTgsHKAFuc3EBgcjx7kXUC/Xmd0KneT
	 S2RrFL5tNkqhSJqMdLvoGjLhcECmZiyoXKvMJ6XGq5XJQpEk4Yief4jJiXB3+Aa2unqcv
	 QvufT75WIqCeWkohaF11MHW9WB/XwhjsRBug/4kH6fCqGCpQEY+K1KweYAhA281ru6P8w
	 EG5B1y/PmCbxWs2e30Sd4NG7biO6Nv1iH3zyvjg1WbR0PkIchxq+NoZPHtT1mM/lLOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufDqsg0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64D4606A320;
	Thu, 19 Nov 2026 03:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufDqsg0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1372A1F000C4;
	Thu, 19 Nov 2026 03:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058287;
	bh=dtpQ5HCBbixDyVnzFFOm4cyOof0Tkxv0heBiFxBSbtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufDqsg0ZftSPmUESX1c0ej4BwXS8elFtJR3hWQYYNKw3dxz01YXjIGa23QtpdQcnu
	 FmFgCntNbYWiGi0QpqAUOGnqiWdT4tZpNn9Ch08RsA4G8zhBphKFMUq3LwW8HovPSJ
	 /ixzTKLqucs+RJjAv+Kv7DXD7xX1/HFeDK+DOFpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0431/1848] kobject: fix out-of-bounds access in kobject_action_type()
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118145932.205067365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 99de6689ccc21..91c30bb517abe 100644
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



