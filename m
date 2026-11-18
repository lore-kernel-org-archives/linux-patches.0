Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016178;
	b=KUVPSwELKRq15Fq5lneysXlJ2adC9nGEJdBV4uWG0DFg1L5OwzsU+ZoR33MGRA2OIYp5
	 4KDf+ZfJbnLhEF4RO4BT/si7Bcb7+i+XB8+VsSCzb3N/JcnNJYMspxfTQWF2OPcmfcF56
	 Q355PUDS54kx/X+sCpqmcDgaoOUpXgI3bRT+0RJSF/SP8gFJS33w3UPXG6ADPprOLSt7M
	 XMHj7s77ujFhUZB68/zhFD3yi5h6RK0dtGPCQrZP6vvi87yPqjAggh3bcGfbNigYHrTvo
	 qDdSXUKOD/Gz2ku5IToL+OL91oCENccZXgYnc0+29k7Q7+vBOdyuyg9ywNoffpBVQqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ff5mIRbZrWMmQmD1qTpyJuCKDJnWWYO84B9gigQHWqw=;
	b=QDDGJ4KVEZ0Pj7dAxnExXLYRtRkQQNVN9RgrWLUxWmEvkBwvrKh4UtvAYfrzDmEZ59pE
	 Y1XlAGD9xngA1bpFCdBOMjEDY1tEzjWv76fwhRA++I9sWjW9pf7rAbXOXsNEABzpwlx5m
	 c43RSdAY0sR4Z8PlGNsFW2AWD2xRXoDCxWqp1uoka/ftLtUqVWuSbNdynIwMEeTq6fnuL
	 2+g90t0wdzE3wMNCYaqb5Jk6/tCntc2LSSZmTj0+aMh14pXzcnTemD0FCSFt4PnyUm+N7
	 oS7ujK2tcBHlZ9W0ElFqJ20qhmMAc5PL4ZrlOU8cXCSSA93KpzOjMkNLhRl7Zz5nl9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzU4qPyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F36606A31C;
	Wed, 18 Nov 2026 15:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzU4qPyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8241F000C4;
	Wed, 18 Nov 2026 15:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016178;
	bh=ff5mIRbZrWMmQmD1qTpyJuCKDJnWWYO84B9gigQHWqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzU4qPyOBXJKCCw1TSOXuVzu3Cz8qem6Q6i5Zymn/rkNLDHzKzjMjaTtIioUa9D+B
	 EwKuhXGH0pSC7KQj57DWH5rSAXeBN8MopfrSLZOaI46olJAONA2d2+qp9X3YXtdW1d
	 NpG659kctqVpyIbgSFTH24UcvSoldCv6cAVy85ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0438/2651] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:27:58 +0100
Message-ID: <20261118150303.594760877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a347cc458d97ecd8adb5462b91559682a70aced6 ]

The snd_ctl_add_follower() comment refers to
snd_ctl_create_virtual_master(), but virtual master controls are created
with snd_ctl_make_virtual_master(). Correct the helper name.

Fixes: 79c7cdd5441f ("ALSA: Add kernel-doc comments to vmaster stuff")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912100548.86134-1-kmehltretter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index 909db0d0485df..37e9c545503e5 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -244,7 +244,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
  * @follower: follower element to add
  *
  * Add a virtual follower control to the given master element created via
- * snd_ctl_create_virtual_master() beforehand.
+ * snd_ctl_make_virtual_master() beforehand.
  *
  * All followers must be the same type (returning the same information
  * via info callback).  The function doesn't check it, so it's your
-- 
2.53.0



