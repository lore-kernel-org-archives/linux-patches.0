Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063326;
	b=n+8K8dlupMGlTiwOScqgd42RiFPxiyJc5AKX0LBVkwFMGSGrQPjOcJuLat4LQvgMuLMV
	 Ss6g1ulHSICGh0bFx2JRv1pjXKoNZSWqaVvYHa+7e1DCpbFCa0Jf4FODkem2oe1n0KIxL
	 HefKacynoSAuwURra0Upo1bpdFKsnfGrD7f9obrnLwx+LbZdD7ParMLMD24eitxHdUJ1Y
	 Qye82H3Vb30EE04bHZYUwGPYDLdkG0wmyL5r3xuCY6HM0JMC1h+IiAlf6FMXwzgXAEvR1
	 Q7k8HfUUTRs3HhH4kurA9D0nezaGLkbuc6YY4fyUWx//3dgBaM9mm19mzkiBh0Ba9+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cU9TiQG347Azplg/027fAL9FS5ne0EvofP7o8lXUEI0=;
	b=U9eyJrrLmV969wvdPYxH3s3urkk+pUgxFKMHiY9THFmGoHRTOCgtFb/+q8snWx5LfHn8
	 aWA5NRwBeQLGW+KiugHC50X8eQu+EZFbLwz6YDVQUK/iiHjMPbNusVPzPCHA0RKn/GUUJ
	 R/GzVyMakOZ71GsklzTEr/ccr4Yu3YDifENxVlI3di8MlQYHRNFVEw8J2wXehI3SaPcjK
	 AS1en7sP+ZzEKzpElNPd647i9A8HBZU7yhzdCV0Zs3+E44PMq9E3Zo7ERGAZVFcXalc6b
	 P7dl8/etJhqDKwqX3H3BvlB+Y49kjHxC2nDYBbBuw92T+t6NNGe/OL283kSqDJBX8bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVNbX0Ts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491FE606D810;
	Sat,  7 Nov 2026 14:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVNbX0Ts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC11F1F008A1;
	Sat,  7 Nov 2026 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063326;
	bh=cU9TiQG347Azplg/027fAL9FS5ne0EvofP7o8lXUEI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVNbX0TsOyw5uB9SGkKcXWc0k85Wd9szJimThIcnfKFrlsqXNUn/vgvno3Iq9BgMc
	 Cv0uwqI6uUbldBQpQ9cL40J0n8JH5yMPwjMhm6I2D15vBkwjCf62U9Ii9pFwgf+2eK
	 NwdVpgFPvsCMkUlMmZ/cX/OpzQPgnVFCk5mseF9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/869] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Sat,  7 Nov 2026 08:53:12 -0500
Message-ID: <20261107134910.872174199@linuxfoundation.org>
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

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit e1301ab8a8411fccc7effe0711fc09939a94953c ]

When selecting/pasting very quickly after VT switch, the tty is not set
yet, leading to a NULL dereference. We can just abort the operation.

Reported-by: co+e5693071d903b832@bugs.sh
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org
Tested-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260829164945.2691317-3-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/selection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accessibility/speakup/selection.c b/drivers/accessibility/speakup/selection.c
index 7df7afad5ab42..463a7ef19315e 100644
--- a/drivers/accessibility/speakup/selection.c
+++ b/drivers/accessibility/speakup/selection.c
@@ -61,6 +61,9 @@ static struct speakup_selection_work speakup_sel_work = {
 
 int speakup_set_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	/* we get kref here first in order to avoid a subtle race when
 	 * cancelling selection work. getting kref first establishes the
 	 * invariant that if speakup_sel_work.tty is not NULL when
@@ -120,6 +123,9 @@ static struct speakup_selection_work speakup_paste_work = {
 
 int speakup_paste_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	tty_kref_get(tty);
 	if (cmpxchg(&speakup_paste_work.tty, NULL, tty)) {
 		tty_kref_put(tty);
-- 
2.53.0



