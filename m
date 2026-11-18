Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052347;
	b=p6ih4dMJ2uLdnBua0VV+ckjq/ZshLHQV3iG4Zf6C4fCKOUROwZiQwm6foU55iVRiNP1y
	 TP1sFlEidTn3kIG1ItnxUqyXMt2bySHBpWK94rL82fRrKZkuLBPc/DxRAFOi4Wt39T0b4
	 9BBfkXDFMuD02TkhvD89cw7+LPC4t5sILMHPTyKWmnd5C2T41i/27x7QEGrFaIL71H152
	 HC4sY3bZCsmlyn6M64HezJ92A7x3MFDrmp3x4G+VNtUDSXQ0L7JHLYo8HhxM8bTUfiRBC
	 Js9TF36BzZ5Iw3vCf1EDb9P9Cj+0ztKQvj7u064WOVkWOt4cjZnsyHWARy+VxiRqxAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5payN6fGDzVuNKTACOZJyzLMe6Eaqc4mzejCTlLu/gw=;
	b=CPBjfTCbbEZw4nKJpkURJNnP44A8u3D5PeJOmjZDW8rFSApkQjhO+9KM3ug8WFr7DiQ9
	 gZYv9qmKVoYiZBSLwNMhx4yvkHd7jXQtGcnX3XHxTrq34JYty15FxJJ6B1FTuKEQO+SBg
	 lVMXWj5fyEkf1uIM4cBgZTsFVVlp3qs10TWsAvKTs5Afzatfi4eMW+CPUFWngY+NL3lg8
	 Egqnn6q8sD3+hAPVq2CnsWxnIUYTIqm3JEuCW3qDz5SnwQyCNK0td3Sm2U6AKhH877Zsh
	 Jm/J3+O+X+jNnik2tcTPP04HXxWUj8ef3qRKuoIdCKiZORoprlaY1oql1n0K/sDOHxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yGgZ/4oo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D913606A335;
	Thu, 19 Nov 2026 01:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGgZ/4oo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938E21F000C4;
	Thu, 19 Nov 2026 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052347;
	bh=5payN6fGDzVuNKTACOZJyzLMe6Eaqc4mzejCTlLu/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGgZ/4oo3ZyfOfqGm/qiQXLtyesb7sPYfVYSM4Yll38KScL4bzNKVmHYoF2pQtGLh
	 DG1K72GhHXNPeDakj4oGYCsgxfkaFId50gbcBHuz0RsWi3/+OBBUOx8Hs42EGwifzi
	 EGi8bLw5hGP2Qt1hckD5WTMce/VoKP00KfZxEmbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiacheng Xu <stitch@zju.edu.cn>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0532/2214] kobject: fix out-of-bounds access in kobject_action_type()
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118150032.337628777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



