Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621076;
	b=bF4qfOQIfirKUZmEAtYe6ZFuGrMkNoEQHnXVUKGH5JcxUqa0X0ojq5Sud1DOodpOhuF9
	 +suNs2kNpK2NZWcfVNXKs8bUl+y7cQpCCgI5dSyWiA2GYD/cFjVm6sFGG0BgSnp4/PCUY
	 76ccJE3t1LvhipUQQIZyo2EReJL1w+hpC9y10jsl2SKQQg56DB25+3wC9NuRSgusCSQDD
	 /3r1ywQxo7Y46pqW4dz46OV6Vn2asu565c39n14lU9TK1WilVlGqIbWQtUvSKxMJ8zJqV
	 rnpe1+wcsrnC/XBNzyrv/6i3K3H1RTEr94VGeQVciSZ7JmkBgpwaWJzyvjRCylgAYBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9m7Qa0AyBhB/I+3SJoPkeydKt8qFKV/wgJFWjAxpUrs=;
	b=3U0v1fmWJ6Qe33te4wNufOZ6PMpHwiycsINFGJru+Ojwpkb/kYLH/zhlQ/REEtYOrioA
	 Tn99glHNtl6O6Ph75YMVCaDdg19aYL7BRYghT93aVQPy/OFqNiHyhFdswk0uVZA6Q6ZBB
	 8iP4zWMxUISZ1J9yK/hKUVDl4QcKzlNfsWrtZuptXzOgtAomgy2gxBMOZKxXgZ/8smsN+
	 xEpWdj6NO2uQ5WhUrcF+K2B92j2Oy5h0SzJzMkQppOMZ2KxZ74GoVhR95QCpcLcRK8DD8
	 U5Gj0sfYpWJitAVrO+xe9VQwyNe89ZL9DRvgUH2Ar9cS3noJsACPEdhH8+JPlBDZ6tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYVzdP5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A1606A321;
	Wed, 25 Nov 2026 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYVzdP5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64991F000C0;
	Wed, 25 Nov 2026 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621076;
	bh=9m7Qa0AyBhB/I+3SJoPkeydKt8qFKV/wgJFWjAxpUrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYVzdP5eGH5KZ5QEysSJfGRg9AXlPhoLx4U3yRyLqNqVHK5hRGq1zFO4MC07bxDwO
	 yNx5bdd2ZO0LNsKOQfkp+eE8GNSoI6cER18CTisiXRdtMm/KjK1GAqXEFJSlZfHniI
	 zfa90xT2MDug6xvAcGiGLqXLbYu6sj0iY6KU5cDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a079f084653164a652d1@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/990] batman-adv: avoid WARN_ON for orig_ifinfo allocation failure
Date: Wed, 25 Nov 2026 15:23:55 +0100
Message-ID: <20261125143823.681646217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit dfa953ba5366b0a80c303700dab2bbcbdc5c27e9 ]

batadv_orig_ifinfo_new() returns NULL only when its GFP_ATOMIC
allocation fails, which is a normal runtime condition and not a bug.
batadv_v_ogm_forward() already handles this the same way, simply
checking for NULL without a WARN_ON.

Do the same in batadv_iv_ogm_update_seqnos() to avoid a spurious
WARN_ON splat when the allocation fails (e.g. under fault injection).

Fixes: 7351a4822d42 ("batman-adv: split out router from orig_node")
Reported-by: syzbot+a079f084653164a652d1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a079f084653164a652d1
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 38320f6a1dd1f..26f2795fbc183 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1298,7 +1298,7 @@ batadv_iv_ogm_update_seqnos(const struct ethhdr *ethhdr,
 		return BATADV_NO_DUP;
 
 	orig_ifinfo = batadv_orig_ifinfo_new(orig_node, if_outgoing);
-	if (WARN_ON(!orig_ifinfo)) {
+	if (!orig_ifinfo) {
 		batadv_orig_node_put(orig_node);
 		return 0;
 	}
-- 
2.53.0



