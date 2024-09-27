Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779E17B515;
	Fri, 27 Sep 2024 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440061; cv=none; b=ENYtSKA5DinT+gt6Yohb3GIoz5Vnt98QJDF2UMwq5EGrBwuVcuJ1pnnEep+H0u3QOPp+dN+eSPYepa2UTk6esZB6SYPE1ezHFvqqDHKwKSVsDqOWAIYPB5qrn5N4ywIcHdHEPw5k289tdbCjq8D8VkTa1JQxYMhNlsR12g0bZAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440061; c=relaxed/simple;
	bh=XK248saLW6TVbvGArg1pqdkixSOz99iJAZn3geksPNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8AILPgC6GmJCO9Kcs3jUUf02s1dzTG3CjZtXyBYlPjOFitx+AkYHJBIVjTNTpKtbejqvqiLO9JkPJPs+VGqNSLuKhG69gTL5KIe3XXNxdTa16+hHTNMp+WDAsFD99z3KqxzkRIP91Kk++yrnW7X3n6dP2KP3MpjpGb/LZPKLrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0dQnzwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0dQnzwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A54C4CEC4;
	Fri, 27 Sep 2024 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440061;
	bh=XK248saLW6TVbvGArg1pqdkixSOz99iJAZn3geksPNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0dQnzwAqrR2ljaf/Hw0eVcixRaXr2V0hPpup668T5Rv/ByKcgvmMyNTp2aj8QOhH
	 Czgk4/oz24gC7x+HzaRCXAWe3GeoiZUcrLNpd3vpxEkqTPF/qM+nfeSBxSUeGdWnR3
	 NCoZ8SNBL86yt0nQH5kucCNHQhNo5V+hysbQWuRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 04/58] ASoC: allow module autoloading for table board_ids
Date: Fri, 27 Sep 2024 14:23:06 +0200
Message-ID: <20240927121718.973816111@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 5f7c98b7519a3a847d9182bd99d57ea250032ca1 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly
autoloaded based on the alias from platform_device_id table.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821061955.2273782-3-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sof-mach.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sof-mach.c b/sound/soc/amd/acp/acp-sof-mach.c
index fc59ea34e687a..b3a702dcd9911 100644
--- a/sound/soc/amd/acp/acp-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sof-mach.c
@@ -158,6 +158,8 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
+
 static struct platform_driver acp_asoc_audio = {
 	.driver = {
 		.name = "sof_mach",
-- 
2.43.0



