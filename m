Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064142;
	b=g32uv7kriRPeGEpOG324cAoWljYlY5LM7QV33dlxJeT65dcJ+K0BX6W0hbOEoK+xwcUm
	 +9GPb0d95HRGjywEQi4YBU6ysQmtRPAtjwvJPwqy50aioQRI3yPkF2WEcZHYAYj3oT96F
	 H6cYrtMRPMa3nkeBWHtFWkOjfAGXTnethXe5J3R4b4bb0OOnetAeDnWYQ10VQz4z2O+jF
	 VrBHhYgR0ahd6VFEC5JXEyfga4m8Ts4YQOYNdn6iTSS6mAVAg6w5JIq6wKAt/WiRhT1qX
	 GhIppa4fqVtYM9sNlKFPj8IsFy8Wnqfp2OdP+I8DUy/UQT79vt4kzPYEoqpFYrnEeFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfXy+Ct8PG/ZxQVTRTCkV9wqas7VyG2DobzlGp2wzMk=;
	b=tomWwOm593XhldM61KyMZU4HlcyeBGb0y2kSEzGeLebVe67UWYjYQN21uUXU8dGmNbLG
	 PzmvzoMNwCbzyvfk4g9mOyr4BsOx1C7/wDDkKRavTJVEMcURW9b3fNwfbTlDerV45EVD0
	 gmVGdK6qkuDzsyakQ1VwKiWAakrRoTR/77CgWD1yHd5EtoOWPddSybXU3WBNDgvFuVXvf
	 12sel31oJps38utbE+vVW01OnrIplMR98WzylRAdGx1Ypz7jdIsQ8P5sPxZK40OmDnmV8
	 mcKveJdLALamMOjDZi8FNA2NeK0qIbakKyo4yMSNaG5sQg96wGf8Ao4UeuM7GZu4fsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMvoNUHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DCE606B89A;
	Sat,  7 Nov 2026 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMvoNUHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC17D1F0089F;
	Sat,  7 Nov 2026 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064141;
	bh=DfXy+Ct8PG/ZxQVTRTCkV9wqas7VyG2DobzlGp2wzMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMvoNUHwnYjLMqt20gLMExcy0D7ii2LfNXGa143bopIxyf4DTIBR9bwN/bd9uIDWD
	 LPF+I3G5g7hkhpVJYRMBPDg0xRHSP2HgZ3llzDo7i28A9OuFGv3UQDWp9v2o4miIBB
	 X9+nbUezxgx2c54lLbxFPz2USY0fqEeML0DsIidQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0290/1257] kobject: fix out-of-bounds access in kobject_action_type()
Date: Sat,  7 Nov 2026 08:43:06 -0500
Message-ID: <20261107134947.477637054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6ecd39e4b7048..84853e096811b 100644
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



