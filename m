Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319202EE61A;
	Tue, 17 Jun 2025 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177312; cv=none; b=pD8PHl2zD//2F+oXpRCYLxzESATLhoEbrSx3bYGsPLwCitfRRCEZsoXdcJGXrvmJqQKXmug+Bi+HJ3yJvdaIPhT9MVNtbl+YM0UlZtPNLg17/EskaSTjjT7s6Rq08huw9TXzJJZDuaBFzbYYmSBPjPkMR67HrX/3mMd+m+OvgcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177312; c=relaxed/simple;
	bh=etrEsRUGKjPJuaQYO/Y8UzT3kEl/SJiljWIEiayn+Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUBN4wkJEcLGCFhPA3xt2HGtcj64ZvKvCHTf2UylzbiwhKnVvvE46OcDP7Px9XKqIu4XDDKy0nRCRR53GYxKXPRPydirVzuTZ0ELlkCnJpWx7l9mL8xwDAYiUJtFkdbMBosq+2AIBGXJBnsATNXaQybvHHiYd92oQ2G6lQNkqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rtzf8Dyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rtzf8Dyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CB3C4CEE3;
	Tue, 17 Jun 2025 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177312;
	bh=etrEsRUGKjPJuaQYO/Y8UzT3kEl/SJiljWIEiayn+Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rtzf8DypLZV+hKT7wih1mshDvcFKqf0k/IYERr71WCzGU2ktG7jJvvrXzhNnhkDip
	 zG59+IvMqX3Zorw2faOmLl40ZPncHP+FE8wdPGb4jit4eoRZdBNUbCfjPZIV4yFbNA
	 KiFSdJgtFtrDuDXPCS8GlG5MMb1MwBStxeLITc0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 288/780] wifi: mt76: mt7925: Fix logical vs bitwise typo
Date: Tue, 17 Jun 2025 17:19:56 +0200
Message-ID: <20250617152503.202018811@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 88224119863c39fa67581874e1ba218fa56113b4 ]

This was supposed to be & instead of &&.

Fixes: f0317215b367 ("wifi: mt76: mt7925: add EHT control support based on the CLC data")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/d323a443-4e81-4064-8563-b62274b53ef4@stanley.mountain
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 63cb08f4d87cc..79639be0d29ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -89,7 +89,7 @@ void mt7925_regd_be_ctrl(struct mt792x_dev *dev, u8 *alpha2)
 		}
 
 		/* Check the last one */
-		if (rule->flag && BIT(0))
+		if (rule->flag & BIT(0))
 			break;
 
 		pos += sizeof(*rule);
-- 
2.39.5



