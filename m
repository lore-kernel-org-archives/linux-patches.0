Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10774EB852;
	Thu, 17 Sep 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659069; cv=none; b=qt2fgsY+sC9iS5ZzUQY9eih+9BU68WBrknj+zidClafxquyttd4N3yTYhBsNkIFlgNrDZ3tl2Lh6BPGc+CAX8QYSxLtqxLEcJR6pere+F7bq+VZ6tPNRopuMZvG1p3aTmz3emnFFhIHYYZQ4I/JcHcmiuw8h+UTOulIu0sqvKOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659069; c=relaxed/simple;
	bh=9l04J4bv6qp1hIJHGx6DNwBN1rX0fE1E9yfWVFXawmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB2d0eq2uLUJWvwU1+kJ0nJM4HRqEi6exKnEHQk9HzZKbPfMItD4rSz/m07qdlS9dRG4I2n0VW8L3vGteWuL52trs+WvfTHEF/AJrY+M1FaYLEefjQvs1LY5jttCCuew8yoqfj4H3CIxkjYHiJCHNOey09x4l59cm4E2Pnwimns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRHr6Lw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRHr6Lw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1951F00898;
	Thu, 17 Sep 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659063;
	bh=MSEf9WIGMx+aF/+tSB0yldSorCv+0Y403mx+Pfwn/ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRHr6Lw3tXs8RMqPA8j28vX70FMCHAUvl5EDc1mIQRb7+W8lX3sYQpONxqg+5OPTW
	 X/Yz7FuNUSkGXwPYqv4bDoFA1uKgHMULltGd0fnOhPBLpjTmAJ1GT4xckP+jlwxQsk
	 hpShfo7V1q23iDdTpOmFxVpIBCHSe9bGV5erLTII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 132/733] net: ethernet: oa_tc6: Fix for the wrong data type
Date: Thu, 17 Sep 2026 16:07:20 +0100
Message-ID: <20260917151354.314168289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 3cc2aa96b97184abd6fc106aac626ddf14389813 ]

Inadvertently bool data type is used where int is supposed to
be used. This might turn a negative error code into true or
false and sign of the return code would be lost.

Fixes: 8f9bf857e43b ("net: ethernet: oa_tc6: implement internal PHY initialization")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260824-fix-race-condition-and-crash-v7-4-4323279b18f2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index bc468cd86a140..f552165e503e1 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -410,7 +410,7 @@ static int oa_tc6_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
 {
 	struct oa_tc6 *tc6 = bus->priv;
 	u32 regval;
-	bool ret;
+	int ret;
 
 	ret = oa_tc6_read_register(tc6, OA_TC6_PHY_STD_REG_ADDR_BASE |
 				   (regnum & OA_TC6_PHY_STD_REG_ADDR_MASK),
-- 
2.53.0



