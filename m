Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064720;
	b=VRsVAPKD2TiD0VU4h4XTZG5wTAHTO0cz83sJjMjBYsfD/WXDMsHiF/L/atopvucG9Q9c
	 1wfUx82IY9XwS6NIa/O9i8TWYSX2E8jfj3agIVf7Ib6pGoUSS9GNdNDyxzk7OKsQ0LSof
	 jGvvDMFlpXmMH6eITRjUFWWPENcRSKMYqpg4FqBu9egJvXztntL08y28rIwxiXxoV0zps
	 hN5J7NkTHD+F/v/8mTP7qCxv4Cvpi2KeX6bfXHXjmCKvwVxy5piWZqPKbsXWOJuLe722+
	 qL+LDUAckBIPjLfvP5GpVqFKr58Lv08H2Jzt2OyCk7vjkTi+04xtm7DVNxasoVHP6Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJeotyh7XuuHwumemLNKyRyx2TdFdtE59kkA91onFos=;
	b=ARxqRRywzMUHLfZQvotb2owvucuCDRl/Q0kEjWx9knCFl0n6M6qFoL+9iFY4V4kzRCQL
	 y+jNyldR6DkLeaX9paz92M+lThaEc4CUe9mapk/W8XrjXusBNTJjophVigWJw8e+OG8r6
	 1x+5XuQyjlKTAoWpNJ14AiFywsoJvCcXnjihvsempQO+MGsUp7CRLUQVq4yv6UWQ6PQBJ
	 fpLafuait5dxqO4mKayJ/1yjgo5iVGA5vXdC3zVB0Cxexhznz4FsHxuwvdzvOhiq8PfSj
	 say9d3jPnBQF3+xUrRssyXiHVmVtfReP5Kj1SRnPR4MAsOsFRLEDoQW4rzAgSvSbnOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hq+KbbZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD6606A333;
	Sat,  7 Nov 2026 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hq+KbbZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A01F008A6;
	Sat,  7 Nov 2026 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064720;
	bh=XJeotyh7XuuHwumemLNKyRyx2TdFdtE59kkA91onFos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hq+KbbZLAN4E2Iyt9yPUBwJ37MFHyamkkUptmKvXtdQ3NLoptlY8hQUTMC871/jXP
	 wNjEUHiMAxQNEX3Gt1oYL4Q5tYsgBcay0FAMdM2ut9O3/F505bzw9hanQvjLHw8rPV
	 t/fy5gsxY21k2cSB4peWQF6G4ZiJ3C4CbnYE2chw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0700/1257] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Sat,  7 Nov 2026 08:49:56 -0500
Message-ID: <20261107134958.587900648@linuxfoundation.org>
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
index 1713ce4e0ba53..a04a7e8c307b3 100644
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



