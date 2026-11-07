Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062085;
	b=yHjhMt5NVsKU51yfSoh57/ZzhajcaOczNFMizWlg+mA5FhBMFEtVs1BctLOdFHkCCrMV
	 PLIRTdkL5/4dk5tyfHW0yqu7b9ISVDxgbZsS8tlytXs7VtqkOWRzLyc2gJIKbzXhghrcB
	 F10Pm24LX3urR3R3OWztcq346I3wyJAle13+u7bXJ1GltnBMEssN5AV9HnZihAbkQCgDw
	 ehuF7mFWPy5tEzQzi4ZPYXNAIcFn2836ntE8Sfqt1VSOuR2S/j+dC22e9sm+4DFwQLt0n
	 QFmOA1Xe9jn92iqF+Op5fQZAYMlNiL+nM1zEpOx1fppsJwekZMrc4cl6qUctEEYnjbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pijzlkf/nsyYMuzRQj1Xd9VeI/TADbSaU2yehhB9bA0=;
	b=2+4bQ8yso4scAo3RhAwt3GlNW6gwrNBQ1xj5Trn+mhhl7sR2B2nHUXeHn/7gEda7NyvH
	 e0Yr87kNl9TPfZvr8e4Zv1HtmHAOipYa9EoIrBZlz7guNMdZ7wBrYtbX7Zd7W1Ncf5x65
	 IpU8S/Cw45+lBVWJdO8W299BkJMT/IpxrG1VnE7YByHdKDzOzsuXjsnMBtJLV8r6aHTnd
	 JdXktmFNKHfVP+a+npZ32ghHcWEuf7Ry4rN+tb2zVxs3TteMlr19ohyYZYlAo5vBWio/V
	 4xonSXzi4APMhqnj1lwJm0tjHf6W5CY1sk1UF37QQ+3T8Wvr/24bUbdJxH8Hc6uzBgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO2V5iwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B21606EEBF;
	Sat,  7 Nov 2026 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO2V5iwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F91C1F008A4;
	Sat,  7 Nov 2026 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062084;
	bh=Pijzlkf/nsyYMuzRQj1Xd9VeI/TADbSaU2yehhB9bA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO2V5iwcx/iPuT/pxdMaavnGqP5xVVwE3l5sg0hxZw7VM29BiR4h+cI8GvlzBcYVQ
	 QS7CwImS9zZFi9Y7n6detfrfKh80iNzJ90DsBjjmIzgozb29Q0uGQmfuZW1Zkeus0F
	 iXUv3MhcPCLV2M8ESPpEtEX1AxXgGPBUcIBbUD98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1059/1536] kobject: fix out-of-bounds access in kobject_action_type()
Date: Sat,  7 Nov 2026 08:51:15 -0500
Message-ID: <20261107135027.426722247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2bb08826680ff..c1c3d94dea7eb 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -83,7 +83,7 @@ static int kobject_action_type(const char *buf, size_t count,
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



