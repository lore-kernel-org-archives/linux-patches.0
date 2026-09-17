Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B85649D59C;
	Thu, 17 Sep 2026 18:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670593; cv=none; b=BxhmTkWAkAmEIOto6RKoJVnCb9qj4FMvYnPkqsWYX/MVSxUliuI+UMnqWkcsZ3yX3b4g3gFQRF302E/0+ti5T75tJTymV1iE9O35XfOFkdU6QowLRqkhRH4lDiVOqycQ65R14N4JWzu+VWqJdjOGDjpFncxWq9pSeZ3N3JNECWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670593; c=relaxed/simple;
	bh=zcrMjDe82BM9DUZfJCPYRS2SJS/4o7WvaFsTVg/m4bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4Jr6wFS3b1fUDC4e6sY2G1byiTQl3WR3XCsY1ZAvm5rIqi5N7uTPvubkaq52b1g04CGo1gCoUIrVZNYhXJrQO/xmJ9vHzCzqx/emtexmYdMByGQmWdhx/nDjmcY/uXS9UyuYX+ydxrQXCJPJ1/W6+hyDcioMrBb45bhURF0YZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI7bZULs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI7bZULs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9532C1F000FF;
	Thu, 17 Sep 2026 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670592;
	bh=U40qMZ7eaTXFFdjTICiRlQD3JtpR32FFNfoVB88OvS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BI7bZULs5CGuaT/wJ0nf2+w/SEg68IZFfC6ChuxBxzXqOh1lw5xKWVKeTm+UEEiFE
	 8+ry8Vb80xyJnoS5fBwcnW6mBHA2mMEQbWOi7skYn17e8tFXGXfz/RuQgq1lCx5bcq
	 39CroiZIihOKp5XABqqyvvbOvjRk13ZkRW/ih+KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0710/1102] ASoC: mt6351: Publish the OF module alias
Date: Thu, 17 Sep 2026 16:10:53 +0100
Message-ID: <20260917151558.152368752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 9c3882ec10399c14c59b7e4599d33c4395367c37 ]

The MT6351 codec platform driver uses mt6351_of_match to bind devices
with compatible mediatek,mt6351-sound. The codec can be a separate
module, but the OF table is not exported to module alias metadata.

Publish the existing table without changing codec matching, register
access or the machine-driver configuration.

Fixes: a74d51ba0e17 ("ASoC: add mt6351 codec driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133210.63803-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6351.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/mt6351.c b/sound/soc/codecs/mt6351.c
index 2a5e963fb2b57..401cb0b48c972 100644
--- a/sound/soc/codecs/mt6351.c
+++ b/sound/soc/codecs/mt6351.c
@@ -1479,6 +1479,7 @@ static const struct of_device_id mt6351_of_match[] = {
 	{.compatible = "mediatek,mt6351-sound",},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mt6351_of_match);
 
 static struct platform_driver mt6351_codec_driver = {
 	.driver = {
-- 
2.53.0



