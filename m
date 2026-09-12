Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB98F305680;
	Sat, 12 Sep 2026 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229690; cv=none; b=IkmTjo7zxwk/E6FrC/66HgKU0OIXD1S8LFep6HlGvMj81/BybNV8CvAqdcInQnzgEH6AIGzA1dKTd7jLEhsnJC5iPJvtEieTU1CtB0TPwTqmdqCom6MXs3jHfwwjj4qN8UsenyHLYydEsVDbdNfhIZoRyY9LwdE8dksw5SiNRAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229690; c=relaxed/simple;
	bh=NvrWih7bQgqon0DKcOB/ZCyuKfDU06NexfzoIdFSui0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6M+ztDYXCT/IBFpcKGUAgJjE9zBmgZNp4s6RQ8H3NESUm90jbAgAwDd2vJaPNOL+RMu3TFh8PgKCZ4h/qW/4wdQjPY0PTGd/Tzi9frfBUz0DUErVXYq51QxJxARC0bZvgd+ayGCe133r8i0Lif9Rq377x1998cid+J4Z6exOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9g4hLHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9g4hLHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A40E1F000FF;
	Sat, 12 Sep 2026 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229689;
	bh=DKjQmICCBugXo3RJj7IC7h4HacPgpV68vxQLYojcAJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9g4hLHC+qCLNYXxVeYItc+agkTQbiCKbWOcc4SUDfbdxSSYttbqAH34usfcyr+Nf
	 PuHxxSRG9e4/3RbRnO7OvJzDiPtmmvg+N7j5t7ToCMxTHAbOuHn+5yf0dsUXv2HhfZ
	 2NfCXbGZlTVd3JnWkiIctI3SPJvw7xIhAosI7DEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0639/1191] accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()
Date: Sat, 12 Sep 2026 08:56:07 +0200
Message-ID: <20260912065602.607110244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit bce0e640623372520d9d90c42f33ddbfb576ce69 ]

snprintf() returns the "number of characters which *would* be generated for
the given input", not the size *really* generated.

In order to avoid too large values for 'len' (and potential negative
values for "sizeof(buf) - (len - 1)") use scnprintf() instead of
snprintf().

Fixes: c6e3fd22cd53 ("Staging: add speakup to the staging directory")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260531230804.254962-5-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/kobjects.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/accessibility/speakup/kobjects.c b/drivers/accessibility/speakup/kobjects.c
index 41ae24ab5d086..917cdbf671842 100644
--- a/drivers/accessibility/speakup/kobjects.c
+++ b/drivers/accessibility/speakup/kobjects.c
@@ -92,9 +92,9 @@ static void report_char_chartab_status(int reset, int received, int used,
 	if (reset) {
 		pr_info("%s reset to defaults\n", object_type[do_characters]);
 	} else if (received) {
-		len = snprintf(buf, sizeof(buf),
-			       " updated %d of %d %s\n",
-			       used, received, object_type[do_characters]);
+		len = scnprintf(buf, sizeof(buf),
+				" updated %d of %d %s\n",
+				used, received, object_type[do_characters]);
 		if (rejected)
 			snprintf(buf + (len - 1), sizeof(buf) - (len - 1),
 				 " with %d reject%s\n",
-- 
2.53.0



