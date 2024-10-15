Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F501E32AF;
	Tue, 15 Oct 2024 11:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992290; cv=none; b=askD/tNI3Y8yvn2v+/ZGGH/is5AeRoWrfW03213Qwm+Pp7t7kWx842Wc3lSbExbFHZV8PReq5PPZYFy5WSlvzqQH1/r/NudYwVEwjDD/SL4tKUYwJsopCyMW1dm6k3/8WZjJ4rqx/0Q+70pl4aCfKYoJElcSO/TwcBXlwtWcj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992290; c=relaxed/simple;
	bh=xwaBcvgR7zguJe99aKPUDwcVI2BZ4uXpk176uGFgGM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU6YSMbQdtfkzjtY+77k6BihZeq+xYEq8p0x0+tM4qDx28GI8ift/aJXsDjg+JNr3/IW8n+pMrJe9TFdX5r7dpzphYpf/FNiX9neKZDq3pJAUyipnlws6Dl/Urve07kav+WcLH3R1t9TskxmxK+UnxNXLOlluFNB0Zebwnl6NfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JO5UR+z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JO5UR+z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE1DC4CEC6;
	Tue, 15 Oct 2024 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992289;
	bh=xwaBcvgR7zguJe99aKPUDwcVI2BZ4uXpk176uGFgGM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO5UR+z32QiCU+JffIO6/y08+1c6kGyYWqEafNhF4+WjBBGQ37Y9EfAyPx2sPYB5b
	 2esRkIATd7MEzY5kjuLeppFcZxztuoBEf7tIUTY3Bc+NQiVzyOt0rBzIPO8vqqs6Gx
	 2y8yvpjE/lVtMVTYQZrendCQYIVTRzBo1zRZ4Qrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/691] ASoC: tda7419: fix module autoloading
Date: Tue, 15 Oct 2024 13:20:20 +0200
Message-ID: <20241015112443.213980771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 934b44589da9aa300201a00fe139c5c54f421563 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-4-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tda7419.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tda7419.c b/sound/soc/codecs/tda7419.c
index 83d220054c96f..9183db51547d3 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -624,6 +624,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



