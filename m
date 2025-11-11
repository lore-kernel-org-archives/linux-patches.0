Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF059248F6A;
	Tue, 11 Nov 2025 01:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823077; cv=none; b=Z5+mfQ0rLZvkKlQxhTehojJKUxL3SWuGaNIsgTVp2Gv0hqDs0bZ57pQP+G6wsXTzxzVcxzFPvfybbMZNiUvwjC2VtvcRsd6M7MOcANFTUU6swTHRkAuZSKxpKzgfHD/FLGKXL4ZiGa6UQePq6ggRHUBJc5pDyEgoatUnWdu0elc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823077; c=relaxed/simple;
	bh=CkVnboOp9rHOg6d4w+7v1VTBOGxvTJqpfQa94wsk3G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlqykAaz4zkVzB4q0xTbU0pWhqIkEfpJBLXmUMYVIv1qo6VaBgV6oqR119kKT63g79rljN05dnacCdx7pBTEGWKD7JlLvB5RhgV/jMMi/6NOJcr8eS7CT1ufjxehN3JpjzlHP/ehX5GN81i87RDyUDa83Dpl8cLIVth1dqhb148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yO6SzF3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yO6SzF3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D435C16AAE;
	Tue, 11 Nov 2025 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823077;
	bh=CkVnboOp9rHOg6d4w+7v1VTBOGxvTJqpfQa94wsk3G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yO6SzF3UyPRFXCyl6HS36rGugCbO4neJ9v7Egxdsl6XgdrbNNVrjHTB61Hf7Aoe12
	 45sINVfXWIbLhfQt8UNZNgMl+NHBXpqN1eCIP4liHbfOaxtf3ILIH8rRY/dizZSzPp
	 oN3PihvVc+PMfdbhmHcDJ/foR3iMTxezeKNj6SdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/565] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Tue, 11 Nov 2025 09:40:23 +0900
Message-ID: <20251111004530.692929242@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index fe018bedab983..7e2ca39758825 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -137,3 +137,4 @@ module_exit(stmpe_exit);
 
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0



