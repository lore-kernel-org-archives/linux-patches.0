Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79414BEE32;
	Sat, 12 Sep 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212115; cv=none; b=e75NZ94GYEHpEtorXpsAl9Cxnno7O2wnaAMZv2TNOZz1KlF4gx3YiuBjwgGB3zq7OpymiKctEfPJZn3keAmm4XgGfqCkSuif54D64EC9T/RWt1CVv1CavklF2Loexdrys5WF4+P9jbldmi7Lz5R0k4RWmkwtRpQHYlrnGo/+zbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212115; c=relaxed/simple;
	bh=W67XmOB0RO7cv+QLYdUNrNkSCj86yhxgGvrDb9LZn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZDB2/+14bCf88hQ896iu6kod5KnmKDOiUhiFvE0QX2IAMQ3cBjJLjJBRklbURqa3Gw063oHqxikHnLzR/HnGZAb1/sz6uYo2VwfNDd/Wbi+DOv+5MGTOL8bWvJshmfXIRrWaEaAS/tOrGhsULP6E/v3pChBc9z71s9NakgeAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjlYIUl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjlYIUl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEA11F000FF;
	Sat, 12 Sep 2026 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212114;
	bh=52RQAzYwq00Hcx8QlL1Z+vHrpaNTLNreAR90FzL3nMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjlYIUl+RvohFD+4hvUjHIIusn8/MZ999b8eSzPxuZ8/zXjA7IQf2JwPgmpTsS9uQ
	 7ejsyYY0H0eulaCs39vQQ3B2PYfMhRcEZLsCBmZWuGT4aXJ1WzlYP/o/HJT3NVsgGm
	 Xw7Zc2NE/BCKXFiu5dmXytkIGT1LGizPsH1BOjX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1369/1518] bnxt_en: Fix call to hardware monitoring event handler
Date: Sat, 12 Sep 2026 08:58:58 +0200
Message-ID: <20260912065654.510406824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 622d698df4239fef3e0eb51fe59f4198f957f28a ]

The first parameter of hwmon_notify_event() is supposed to be the hardware
monitoring device. The bnxt driver calls it with the platform device as
first parameter instead. This API break results in undefined behavior and
may result in a crash.

Pass the hardware monitoring device as parameter instead to fix the
problem.

Fixes: a19b4801457b0 ("bnxt_en: Event handler for Thermal event")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260821044512.663941-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
index de3427c6c6aaf..faed0cf726e1e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
@@ -40,7 +40,7 @@ void bnxt_hwmon_notify_event(struct bnxt *bp)
 		return;
 	}
 
-	hwmon_notify_event(&bp->pdev->dev, hwmon_temp, attr, 0);
+	hwmon_notify_event(bp->hwmon_dev, hwmon_temp, attr, 0);
 }
 
 static int bnxt_hwrm_temp_query(struct bnxt *bp, u8 *temp)
-- 
2.53.0



