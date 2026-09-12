Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E831D47B437;
	Sat, 12 Sep 2026 12:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215672; cv=none; b=jl5OFrA1FglCF6jBxm9S1SAg8JxDOrYOjy3rwX1ZL1inEmHqaYudOdja36vAAlV6Aa6ssTTAQ/s+iN9bssnb3H6K5UB4U85AwWiMujb2TyDArGZe7NSL+OWlvtKrM9Z2XXNLNnrYe2+3n9cJumgmHc1Em8QRCVisX1km2egBcfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215672; c=relaxed/simple;
	bh=hMXavP7u8D5NEEd3RPq1ck3hPL/ddVwB6xxhm/+FKyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNGO2jVWQ+7Gkr5vqQ3N86kCpKNSMWI8yNsf/NX2z6RbqchXRg4QCyta9CBo/M8zXYfPYuM/smcWJ6+JbYyunShvgw6REw48h1QBoq2yAJi66kNWJ8IgpmDJ77344vLNOsWVHh5CW3NFsaugI9k0iDubgECW5HYigQr4J4uoyhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySIprM4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySIprM4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A21F000FF;
	Sat, 12 Sep 2026 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215668;
	bh=uYWSg3AgQHHhDyn272JgPtuP1vPYO6Ux4GXVx735B5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySIprM4ZdXmTwLzxBk9nu/5kjxfI90tN8jfgNICiCr4484Rpfnclc+s8/Q0bM1Cmo
	 2TGXADoOpSMrztmqL3gv23SNG3hSX6hemyB61ohNq7Cp647KJcFP94QiIgw/5cs0Nt
	 vcOAeRwgqtRQ6wR3n9sWU154H26vCyJkctXyuEhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0579/1376] accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()
Date: Sat, 12 Sep 2026 08:50:05 +0200
Message-ID: <20260912065620.435254546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0dfdb6608e022..943ef71b1329b 100644
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



