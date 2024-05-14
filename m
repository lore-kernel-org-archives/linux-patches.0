Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747FC2943F;
	Tue, 14 May 2024 11:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687155; cv=none; b=oiP8hJu6AXAWFv0I0gw/QtK0KtEFbYqfvWIKy7sSvX+D/7K8LaRN3VZjcHZ9TE8VBMqJRFjrnfhQ8JJOdikrJn7Csz47y9x8/Kbj261Ci48tN16w4DfYAcony/3lwnNfwrIk3w6INpBPzgFgx2gJcfJDR9XEZD7d5ilpihjr9Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687155; c=relaxed/simple;
	bh=TjGh8KjOJZ1tQQm4WTLNbpZkB1dnNl/xpULIU5ShoHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzl3ZaA863EkI9eexpUXJy0X07xB58/vOuJDd4E/cxeWbKnDzjhzF0x+Ty+4XVwJHempp7HKXUeeFuN95OBBSzeqcod4Ba0M32G6aJKkWnj8ror4dXcyspQKRKHLLfKYYA1uxl868XwW/nblQPwoYY6O2SeuY8kizKh94Isx9ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1sddIk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1sddIk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C5FC2BD10;
	Tue, 14 May 2024 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687155;
	bh=TjGh8KjOJZ1tQQm4WTLNbpZkB1dnNl/xpULIU5ShoHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1sddIk318jAawyOO9CCfHGLrOGLAsMvRANU1Z5a+OANsfpZOXgUBC+M5y+9GTB+R
	 VYkdZ37voLxv5sDD8Y5QSDHtGaj683YuQIgrVuE/THUKKX2sVOgfnGXHEkKQpukNFk
	 A2QpB38yIXjnGUZSs9bTO6OzwkgEH77GeZCFl7Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	YueHaibing <yuehaibing@huawei.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 83/84] pinctrl: mediatek: remove set but not used variable e
Date: Tue, 14 May 2024 12:20:34 +0200
Message-ID: <20240514100954.804790361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit 86ecb7d6853c77711c14cb6600179196f179ee2d upstream.

drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c: In function mtk_hw_pin_field_lookup:
drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c:70:39: warning:
 variable e set but not used [-Wunused-but-set-variable]

Since commit 3de7deefce69 ("pinctrl: mediatek: Check gpio pin
number and use binary search in mtk_hw_pin_field_lookup()"),
it is not used any more, so remove it, also remove redundant
assignment to variable c, it will be assigned a new value later
before used.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20200218023625.14324-1-yuehaibing@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -67,7 +67,7 @@ static int mtk_hw_pin_field_lookup(struc
 				   const struct mtk_pin_desc *desc,
 				   int field, struct mtk_pin_field *pfd)
 {
-	const struct mtk_pin_field_calc *c, *e;
+	const struct mtk_pin_field_calc *c;
 	const struct mtk_pin_reg_calc *rc;
 	int start = 0, end, check;
 	bool found = false;
@@ -82,8 +82,6 @@ static int mtk_hw_pin_field_lookup(struc
 	}
 
 	end = rc->nranges - 1;
-	c = rc->range;
-	e = c + rc->nranges;
 
 	while (start <= end) {
 		check = (start + end) >> 1;


