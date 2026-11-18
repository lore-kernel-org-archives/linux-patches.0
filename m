Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029534;
	b=OSLkDFN1rADjX+lMjOJSVJVOKzqkQ879GOAnl1of+iKdXLruVlNhtgySaFmjt3z36w51
	 zXOiCwd71U7vWjVPbKhOQLMsnDgM/AG+INedDLGuWILJD8R02jSN6s5ed+jGJmj50404I
	 Ai0JlgWllWgIvD2R07pAoY07sL4AObaOsFuqK3x46qAwPum19LzzGP2Q3PlFE9VCHxeFL
	 E58nE9/Jq+ziRqC3oVsvdLcCZeCB8o+9dasMNAlAiQAUMnyF1pipVeHISVC/Yzzsl1u9V
	 P3mo6UQR8pp/vjbwTr6Ojmac3LpEVJuuf1LAmuOXqEU5p/ylBh9iDEVaWjPhca/z+qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXccoeMYMzmZsxATRxjFOXtBt86tYbWnlcSKXdt0RcY=;
	b=dAub2j0be689KahNSFe97wCQjeo7rAj1dRbSBWNrAvr3CnIjIcVBIcF3F/y+4rYF5aYT
	 KDJBFBMEBY7IePm8s0d5NprJzgrRis2Bmcx2opJLBzH9bmPoXKcZmtacIu2o/UVvpY2Ig
	 ArbKSVNCDbF+iMJl40RjZic16j1PJw0WaTXpxOHFBM/HzjiuGWMHRGvPDzfSYfu1NmbYC
	 eNKunYHBd4p6A9GSoVGqlfP71O2sPHZwOxdSbaz4JZuiDRt8H8RnaJ3Fe3Rd3H1YpSTzY
	 YaxjM80W6NACQjFiZurNmEl0LJSJiKMtJ9xILhMEsrazcGvKu3adz0X9diLWF4WqNBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ku2B8COB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF7606A320;
	Wed, 18 Nov 2026 19:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ku2B8COB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672421F000C4;
	Wed, 18 Nov 2026 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029533;
	bh=YXccoeMYMzmZsxATRxjFOXtBt86tYbWnlcSKXdt0RcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku2B8COBEvCWqVXaqj+iHnW90nB/Tox7/1CZ7TgUtmWRLGuMrAF1y58pJDm82TwlX
	 huM/9xapp0abYj0YOOk56XBr73CwuG3UONT6FgmSbQIHI4++hCa4jyQwSrGcjht4xS
	 N1u++2TgL+3bjDHIOgSkelnwWxTu2YIwrrp9g7RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0385/1756] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:41:52 +0100
Message-ID: <20261118150023.931463999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index e07f6b960641f..72d401983f53e 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -241,7 +241,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
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



