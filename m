Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5779D363C4C;
	Wed, 20 May 2026 17:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298960; cv=none; b=hTd6BZ32NYa8mJaNXduTiGRpLN3eYwhfIhMVtdaF3KgldxRLk20+8W0pG4DAeVRM+KgvNoxolldIzJReQKVsHGUxBfyfKKgJl6lWqFZv18G0hf+HrgkczDwnZ3DujULd2Y0dEn8m2X3ys9d7EvrePO/aL7Tuk6JO1bnDu1PQSUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298960; c=relaxed/simple;
	bh=v4mQmTa5+I4kOGxy0Elw0uEO9QysLXfdNvwUqp9kbhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYodklkUOeLMvH9lFBZOcE216zskJqND6L9J5sK3JoaxlW8H0k+pmFN3r3EBVT+BnNafesHG963S9V2GFgfyVxotc9fxY2AH1/0hGZZJKdUoaQpmQjwqsK6liT+tV/f+mZmN5gniE0rBx0wNOQIELohn4ZOflIUxqzbABV5fyjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKGbTaIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKGbTaIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4DA1F000E9;
	Wed, 20 May 2026 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298959;
	bh=kgBpexKwJ6/gjf6GK58CTzfmZTmw2N77usx3OlwW8ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKGbTaIjfnBUetXtezpk4uGPD+Eiz2fOS6cS5+VNAtQiQQA9lbfKZvlRj/lWHpq4V
	 m+s+c3acaHWeyu3GIxqxdOatw+qg0JXzR+VxJEIW7FVk1sFHtYDYlm+PMxRA/bKQ8R
	 BtbN2aoiHgnWFOWZKJExaf/nbNJ+76zZS+0dLq8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 608/957] PCMCIA: Fix garbled log messages for KERN_CONT
Date: Wed, 20 May 2026 18:18:11 +0200
Message-ID: <20260520162147.720413625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit bfeaa6814bd3f9a1f6d525b3b35a03b9a0368961 ]

For years the PCMCIA info messages are messed up by superfluous
newlines. While f2e6cf76751d ("pcmcia: Convert dev_printk to
dev_<level>") converted the code to pr_cont(), dev_info enforces a \n
via vprintk_store setting LOG_NEWLINE, breaking subsequent pr_cont.

Fix by logging the device name manually to allow pr_cont to work for
more readable and not \n distorted logs.

Fixes: f2e6cf76751d ("pcmcia: Convert dev_printk to dev_<level>")
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index da494fe451baf..efc439c748862 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -188,7 +188,7 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
 	int any;
 	u_char *b, hole, most;
 
-	dev_info(&s->dev, "cs: IO port probe %#x-%#x:", base, base+num-1);
+	pr_info("%s: cs: IO port probe %#x-%#x:", dev_name(&s->dev), base, base+num-1);
 
 	/* First, what does a floating port look like? */
 	b = kzalloc(256, GFP_KERNEL);
@@ -410,8 +410,8 @@ static int do_mem_probe(struct pcmcia_socket *s, u_long base, u_long num,
 	struct socket_data *s_data = s->resource_data;
 	u_long i, j, bad, fail, step;
 
-	dev_info(&s->dev, "cs: memory probe 0x%06lx-0x%06lx:",
-		 base, base+num-1);
+	pr_info("%s: cs: memory probe 0x%06lx-0x%06lx:",
+	       dev_name(&s->dev), base, base+num-1);
 	bad = fail = 0;
 	step = (num < 0x20000) ? 0x2000 : ((num>>4) & ~0x1fff);
 	/* don't allow too large steps */
-- 
2.53.0



