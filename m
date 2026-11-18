Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052781;
	b=qVmErsPdhbN42WMGMthCeNSp+vrY1sxLgBNAWNfNyLV4r2dRshvU+fy6StVQOeC5V/mv
	 BqSoIllz8AGyp08+FIcdcnw+tbiJ7l5EoCNZp7S9zyjvbVrB6YsHOn8SBcjfXLt5vgskO
	 CQzeDq+j1jfToyD5wX2ArDZA0Qxc9Q+adwO3/+e4g9TV0Gk/FPbx2a3NlVq9PIUzRrL/y
	 /P34t6VKM9jHwPge9CFVA9fPaToDR5lEuuCndEYuU7K7GpfABHdZ7pqs/mzoV7Q15R51X
	 QLuBPTkOJuX7d0ulBPq9Zw36IrExeB1tpUnXnnDhKikND2JOx1uN9xAk82zCQ6UjUQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZ612AU8wruuPMp5oul+UrdSl59CZ9NPJvPQvSijEPw=;
	b=5H4FxTpME9OFGQpTdgTAlbju1PxI8QxEGYCzMgSSX8gLAXQpQI71pYgysgLRZYpjHqc7
	 ucDiWcrKQvWVpMbCKqdVV4BXP+O17poR87JxAZBJ29W+M3dLTMwJdnwn3jJ4id22+g91i
	 GmCwgRKvqAJoSl/eTGPrP9xA4uUeSvAO5EB9JDoGJyMQqb/FklwAqZ2vFDtNAv0+Il1U5
	 XL3Ulv28r4Z0jaLT9DmUayPq+gP6Arm/s2BikppJ8HsXkosLRUx3LxzRy6UdsVBsFXwhQ
	 CleYNZSnZo3K05ppxrctatVAX52B7r68d3oNLMFbjLCT5laiEM/U1fpB8OSXyq89phg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnNsehyl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF540606A320;
	Thu, 19 Nov 2026 01:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnNsehyl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9081F000C4;
	Thu, 19 Nov 2026 01:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052780;
	bh=RZ612AU8wruuPMp5oul+UrdSl59CZ9NPJvPQvSijEPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnNsehyl4e8JbeV8loY93rZ7+UE+DUaSTOWc6SB3XhcsncwA5nn0IHAIU1NOW+JHH
	 UxlYiHYf5PzUJmEurdgPzB78njUCMLCDWEw+U+VrNQyQnb/JqKVxZPAdBmLuMPGLwO
	 NOWILYeFlJf3SRRoW3/TymMsU9WCWUlf5M4QlLn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0627/2214] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118150036.450146800@linuxfoundation.org>
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



