Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063023;
	b=cLgr88ell6xwITYqBH/zdt5YMukLid3nhskVDwiaTYq6lTkSU//h1dpwheu6oL2hFo6S
	 /RsF1wamiB1KtyMR0jI05FFseBz+J8I6V6Y0fWn1M+2em/YiJuaCO+DV/qBEZ7FbabPMI
	 wFeI7TsUB0g2CosAgDJCwIgQ0DhRMkYKijt8+gdJxv0CYRN+EKdJtxiSDupCn9FTOYEAE
	 lP5/4QxeVtat+kt4jAwmKiwYG7H9zJn+6KO/Hb4C7Ki1AFnXujxJPNy6Q4wg64qQUhFTC
	 FkIXqJ4zrCHsJJ07najoyIcDz6b6ajKXS9kQUL8HAfaEs86e+2PWJ3XHUKCyQy22Pyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z/7pmZ3iFjpLN54NcSYjZn6brG10BMdq6WQnpgs+TfQ=;
	b=nyX7OoVmc5EWTs8GlnL4Gzfc/UCHWYExazCffrB7EZ2gQ6frYHQ8n4oebV3W5qtKr/ZM
	 dPnFMTWOvot8A3yT1kYaRz/3SrPNrO3o4CZLpxop3CrAL/MxwnarBZnkbKOFueh+ZyDFR
	 PPe0JC9tGjlVw5t5XJOdki/B/o1+u5mwwg57eQzm+eAwaSM3Ve4Z20njQvXl25PlgJljY
	 Zsrg/60sTS4rKP8pyJD2LIluit5cTdxHIY2mtRfmcyba0sToosT2wvBjL5OoVc8K6EnWB
	 QNfz+XgX8xn1Vhr0GsbXbM6vRsKjieuloXeeX2HSesPXvUuZne4Ll7IT4TxCuIVR5CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h70IfU0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9836606EE95;
	Sat,  7 Nov 2026 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h70IfU0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E0A1F008A2;
	Sat,  7 Nov 2026 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063022;
	bh=Z/7pmZ3iFjpLN54NcSYjZn6brG10BMdq6WQnpgs+TfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h70IfU0OGSu6oYOjNsVUZLE+OawW9LBGKw0X8T3/sZzjR6eGkentdubqVuDAMQa9l
	 T0hgKCrP46GEGT6PffbK3HEsUgxdUlSlZ8Gza0OeACONIUXt+nT5GbAH4Hmi0Iwi6r
	 GpyryCSl2u5HyBLnAZrwG1s8zt9b1y2U9HrCBGP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/869] kobject: fix out-of-bounds access in kobject_action_type()
Date: Sat,  7 Nov 2026 08:48:37 -0500
Message-ID: <20261107134859.788151162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5a2480467ab98..bdc2720b7aac5 100644
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



