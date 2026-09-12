Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D92282F1B;
	Sat, 12 Sep 2026 07:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199005; cv=none; b=rdmGfQYYaA9s/hhjFlADZ7yb/yWN2+xhlWFE+AeEHqv4t9n1lx2ATfqq9ICiGgkNRNK1VHex0n7t3WBCbUqq08qM5Vm2SRra9wxIU8qlk721SAgLcSeXlJhyDBxh9G2zZWeqyZiEvMmp5zSgUBMnSzTVvaU7FEYV/WJhxCvhV1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199005; c=relaxed/simple;
	bh=XylxQaWrYSn7zAnAXDMC5LqimK5D6hSTUs+06NHIGKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCOodOfLfFzA1WFqObjgqA7Bm0tugAZATVv/ba4GsZiNBy+0Lg5ebI1ajdpyV9VsjhwhFwwriecL4l+2JxKIA24JFINQLUBe0zgmxiKldoVdYa8scnJd1q1Uhr3WMV7hR1885UUqOauiAWhq2wOjGHXo5U4qtT4Snj5fOb0ERbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7KjDbTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7KjDbTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C8D1F000FF;
	Sat, 12 Sep 2026 07:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199004;
	bh=74V7mB2ut4U+F7heMbVyXYuGIiTPpav9WhHROc6faM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7KjDbTmpkB8cYWqwAxhWtt6YIaCdjHjHLNrY35Ta/YGmgH1xMnbttJ+jR9akZ8P/
	 f/dxSjgk5/FElXSt1OY4810DKKjGm0N6FQjhZNZgMZVQbSnsljELBUvR4tg6UnuLvI
	 AyuMZwSAdyGPkz1moy0f8rTv2uT+Vg2nY2Wbhpvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0494/1815] accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()
Date: Sat, 12 Sep 2026 08:37:24 +0200
Message-ID: <20260912065700.488934033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



