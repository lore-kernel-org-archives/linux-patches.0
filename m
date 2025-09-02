Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03006305E04;
	Tue,  2 Sep 2025 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820543; cv=none; b=urOd4ycovLWM+R9irbFc08FD0CePGphun1nd2eS+IdLwxcLK85UfjvCWtAxfKPRz0pZP5DSM5zvdQS318dfLl4dMNUUNFkD23i1RFf4lb38h4q2hOjBY7IOA9wF0ZYhplnTVuLb5CTqhySineYvSe3t0q/9S9XCNPTONK3No4Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820543; c=relaxed/simple;
	bh=L/8XHzYIApeu3KAzCWweZMeE7Ics+68+kE4LaeDSUEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1371Yjr8AiBuU6/DaYWOep4W8XxoI/U/4PYYpaX/WBmYsMnP6x5jOFhS4S/zdvrN7qU4o+oUPMjMP+EOJ2j15XVM9rbIaG3POo57sjzB1YMDijAuBUr8e/g7hTsWy4dTOKpLvLU5rIMG+gLOpYfcRSgRauyDbwbncMAK7QWd1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyVbFZD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyVbFZD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D496C4CEED;
	Tue,  2 Sep 2025 13:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820542;
	bh=L/8XHzYIApeu3KAzCWweZMeE7Ics+68+kE4LaeDSUEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyVbFZD4uZjpJVgDQ4nRYmgUzJL/8VydZrvJyDJDCQpfhStriX7vZfSK90qPlHoCY
	 dBgrws6xb0ATGxA9Mt7CuScgMUPnTlnk+r+Ct8vYQt21VPY0nMAr9m7W5QNIYiyRZO
	 0MdNFZtlQ7UjTQAbD/2iPY3V8+Mz012y+d4E61yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/33] ASoC: codecs: tx-macro: correct tx_macro_component_drv name
Date: Tue,  2 Sep 2025 15:21:22 +0200
Message-ID: <20250902131927.220714938@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 43e0da37d5cfb23eec6aeee9422f84d86621ce2b ]

We already have a component driver named "RX-MACRO", which is
lpass-rx-macro.c. The tx macro component driver's name should
be "TX-MACRO" accordingly. Fix it.

Cc: Srinivas Kandagatla <srini@kernel.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20250806140030.691477-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 4377e91733b87..095c6dc564465 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1782,7 +1782,7 @@ static int tx_macro_register_mclk_output(struct tx_macro *tx)
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
-	.name = "RX-MACRO",
+	.name = "TX-MACRO",
 	.probe = tx_macro_component_probe,
 	.controls = tx_macro_snd_controls,
 	.num_controls = ARRAY_SIZE(tx_macro_snd_controls),
-- 
2.50.1



