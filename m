Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7443082C60;
	Tue, 29 Apr 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947951; cv=none; b=QSAshburT0+eEy2h8l57vaTTxY44+Q73dPXe0KnrB9w3VQjFhBLxMkYXo1xutgu8aDqLhU9Gdt+DhTpD6Of6XkScN5LJOnvUkbHM+vLtSlvxHemJJTymOunRixetOkqoU4mCQvlH0HZ7kWo4wCYbOcQNZP6BRxRck5DQXqdhVzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947951; c=relaxed/simple;
	bh=/wiAPiyyGnaUfa/h1G5Z+9qK0LBUpHWJn1cuUuG4phU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BidySlPIKSQwxLo33FHgXZayWhVh6flXpY6+PCUXwT1FE2SuyGHnUj5JStPxHOFY3gOlSUg3oYOQipN/bBaJTKHi6UXbrTlk2jwxTrB6vEhlxpjS3iGJJ59FBU/MRax7dh0Wx4Sdl2NJLvVb5L0zP2PP00MVIsnVHRwedrXERk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm/JCisE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm/JCisE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FC7C4CEE3;
	Tue, 29 Apr 2025 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947951;
	bh=/wiAPiyyGnaUfa/h1G5Z+9qK0LBUpHWJn1cuUuG4phU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm/JCisEkWEbE9cTrpu7daU7wWI+U+dt2kzKv5Y0wbRTDlwg5LgxH3w/WAmNR2he3
	 5xpFqfX6GQARfWRCr+dbv7ZH9rVJ3AZ07fKIrQ64vE9CJFTT+f6WPqLOao8v2tSJFc
	 tt6RwBZGTOamyLvJTc6/P12JGkpdiAeXfL3OHb5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/280] pinctrl: renesas: rza2: Fix potential NULL pointer dereference
Date: Tue, 29 Apr 2025 18:41:34 +0200
Message-ID: <20250429161121.382234828@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit f752ee5b5b86b5f88a5687c9eb0ef9b39859b908 ]

`chip.label` in rza2_gpio_register() could be NULL.
Add the missing check.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/20250210232552.1545887-1-chenyuan0y@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index 773eaf508565b..8369fab61758d 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -243,6 +243,9 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 	int ret;
 
 	chip.label = devm_kasprintf(priv->dev, GFP_KERNEL, "%pOFn", np);
+	if (!chip.label)
+		return -ENOMEM;
+
 	chip.parent = priv->dev;
 	chip.ngpio = priv->npins;
 
-- 
2.39.5



