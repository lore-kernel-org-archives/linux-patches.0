Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70E4F96CB;
	Wed, 30 Sep 2026 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783179; cv=none; b=l9PbBy2vxZbYB2dWzktjtPsr0u47ig4CMxzZ8aJDr7QtUesXZmXOtFop9HRw0uwCvIyvRVXn4JYCZQBYAvIBXHjnVd0QdFabwXrIEkB9/5Ff5iS6B/6BA5tlJ7AZIuTiS/atcEfm7/g6mhWknJg+XmP67S+r7pvhbWkOVq6bsy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783179; c=relaxed/simple;
	bh=ABX8HrJkb6NJsjzqVZ4TlsenZm2etMZAww/fdxJpYPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1oB0X57mwMNeKJ+XsWsj+QLr5Pz78+h4dnwtaoTtnzrplYEdEBM37pM07knfT4JoLEuP54rchHQo7JWdNAIClPfUlJ/+Ub5cFJXfYdBDmtO4qnzaucIR+BaS92a841Jyw872172Clr01AEWPeGAHMIY8YUQCM8pEBRsi9TOBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KORweHnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KORweHnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84FA1F00893;
	Wed, 30 Sep 2026 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783174;
	bh=Jb9YZvERSJPZbHiOSTPBYDD1iUlNjSEP1BWi31YxJnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KORweHnwNINtJF3EPfDKPSC1KcD+JLtlWX9sFjetAQ/3GT9F3uXtJwc0wYhoqf9QS
	 Sp33v+BV/83ekdQIncFACzr/6hI5ZK5IoUzJlnm5s12/1wPi1XwJS9x66GA21fCA3K
	 cMUxSR/PvDbQppvFVfraIv1Pn7AATc2eT+zMWmRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/595] ASoC: mt6351: Publish the OF module alias
Date: Wed, 30 Sep 2026 17:22:34 +0200
Message-ID: <20260930152353.323478659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0536eb1044f..cb6c5bd7a233b 100644
--- a/sound/soc/codecs/mt6351.c
+++ b/sound/soc/codecs/mt6351.c
@@ -1481,6 +1481,7 @@ static const struct of_device_id mt6351_of_match[] = {
 	{.compatible = "mediatek,mt6351-sound",},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mt6351_of_match);
 
 static struct platform_driver mt6351_codec_driver = {
 	.driver = {
-- 
2.53.0



