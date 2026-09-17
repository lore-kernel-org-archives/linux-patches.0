Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272FA4848B7;
	Thu, 17 Sep 2026 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659694; cv=none; b=G6knYdhm4tAaJHHh7yrYoxV8USFFe/NkexW/oQrM8bO7SnKB3dv6t8wZtinSu/p2wDWjePdh/WZzEBISkkfuYR9i40uEmRr6yWApk0IgHhprJKO3pyL5oXfj7KDquzvNlEFmpGfuzBO+mqdQR6gQfoU2FP6JcjroI0ucgh2cTfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659694; c=relaxed/simple;
	bh=OISFBBld0QQhixhSp+XL/aQbuKMyFEtyhohgyj1KSPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWbWqFPomrZfE4iuxoTUJrSACxIZsYTmY9mMWJ3BhZBJmB7XLzabxLKGYhOHJR5q5qk80vkRt93Hk3ZzufMtzW7jPpOP1WUjRpHIZTjW4JHRA1sOwYi1RscxTVyiEiSPv5yzDZSHbjyUZv/iZPI13d1Ra9kKVnMrsQvQ4JRBF6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+NtlKNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+NtlKNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AE81F00893;
	Thu, 17 Sep 2026 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659682;
	bh=dWASDiOAqg++JNHURGwilICiD3N7wFB+topk6u0zRoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+NtlKNS7pfR+Nfizv/kjOY1MdkdZ39nguSUYTr8ABeZabua0qCS034Fv3HgCru0f
	 PC6lctXudW6+Iax32lClp6xf/Y9GFyME1mxvwZ7G7i4Wydfernxln4QsRDbEr4cI7F
	 PvY38ntwUAeT8Z1JOInnote1Z4m+sMnfJxYP0/g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 339/733] ASoC: mt6351: Publish the OF module alias
Date: Thu, 17 Sep 2026 16:10:47 +0100
Message-ID: <20260917151359.988282675@linuxfoundation.org>
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
index 1768c249650d8..3be0491a2588c 100644
--- a/sound/soc/codecs/mt6351.c
+++ b/sound/soc/codecs/mt6351.c
@@ -1478,6 +1478,7 @@ static const struct of_device_id mt6351_of_match[] = {
 	{.compatible = "mediatek,mt6351-sound",},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mt6351_of_match);
 
 static struct platform_driver mt6351_codec_driver = {
 	.driver = {
-- 
2.53.0



