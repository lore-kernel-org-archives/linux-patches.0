Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045480;
	b=fzarwBnr7xxpg2Eo+b0vE8GFPTIq4M/5K2j9fEjSG5waZqzDiHOfMUg3MYNlYtSWz4MS
	 GL4Xrg/iyIAuVa1icGw8BRlse9vHNohZQ86fzUWiCWyKgVyRUP4JSV7MK6NeYVwVXybNL
	 f/HI/1OWySmCvxn25nZld5tiDBA6hJ8jw9L9DehaMgrkxex67iL2RJ89GlKR/WOEhoQ9X
	 1Er8NKpzqiaiztJ0U+Uz1oHZhyv2cOZpvlti74Mpsm7ToyOQmsoBDtGLWlhEPW4vaE+LZ
	 LKDDA8DavO2WGSf13Ppij+DS7H01yUZQoT3gfZRnm+8vcTsW/7t5gXt5MqscDiogJew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Doxjqp2r4wu0JkGWM3yMcGpKTf4o8CuK4Du9V30SNe8=;
	b=0caJPQEWQrHqnPZ7voy2CiwwfprAh90kWGjmi7C4ky0T0/g5hOaPUcNaBEBK2kWgQbQf
	 ZtWOYOo9ODWjkBP3J9ebefroFEQ3zX5vI2DtwEIl5UNi7FzSLMWzHVvodBT0f1iQ0tBcS
	 UEbtPwJJGW57AzlwfBZYxdlmci65PC8XQA6FuqrAwDNPUl2ZHEpUq/Y5fAE3FB7JF1rvE
	 27Y28fEQMAS+RdvxZxttg56buaECbmmY2Nr7rx2Td2rNO5sp7YaFe3yZ06hrTl4fnNPwK
	 lLxtG/GTg7X5/061o3puaLS1JIZJObKhmeiZvgldP3+UqCg/nZo0hcJETI0LNTKTaIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODkjeAwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8173606A320;
	Wed, 18 Nov 2026 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ODkjeAwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262851F000C4;
	Wed, 18 Nov 2026 23:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045480;
	bh=Doxjqp2r4wu0JkGWM3yMcGpKTf4o8CuK4Du9V30SNe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODkjeAwUdl2YyxLh2KOJOLp5+uSDEg16vQqbOWlZZmkUY8ehMBCVrtDo20OsKmN80
	 N4hquBtBB01NN1Hb79NHh5DNm0lALFcsiLA+gmHLU7HBTu5aUXYvzmJXUgpTC+Uijl
	 lvkMBVpyKxy41EbTN7vTEYYiElEVzq+FSWa9+tNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0936/2857] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Wed, 18 Nov 2026 15:32:50 +0100
Message-ID: <20261118150235.302554235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



