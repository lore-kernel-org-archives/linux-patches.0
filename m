Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21EA17B515;
	Fri, 27 Sep 2024 12:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440086; cv=none; b=Tqnx+TV2+lWuzBr+Vql1JxO+eonPwiVa3F5NBnLH35Hiap9+WUhJtRyzFWgQvy0wOMP+NcBiX6zDdAEGNyUTrNnxgbySSZQQo4e2mVWOEe5LmPOGqlZgskX0FAtDXkyd/SZ6+EfZUxjQ3hc2ZaNqHXWRqHHX5MRemX/Y3bT5zZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440086; c=relaxed/simple;
	bh=3HkEojfFWO+bwZ4frlXwrlQze/2nNszEZk0vJY7H6hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBINirl3p2T1NWEnsqsL8VbEUpxhqqRdQ8Qj49yWvP8FofR62xqGYOS42YQFgGF4i4M4pVY1qcjxNQxVX8KevGuv8H+2qmPACn3FSF3V/n3H59mcd4n55ojlGoT2b/xjCD0HakHrOMEm3vM2U1LE8kok3kTNDfmdTE0BRwbyi3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlEitsYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlEitsYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3A3C4CEC4;
	Fri, 27 Sep 2024 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440086;
	bh=3HkEojfFWO+bwZ4frlXwrlQze/2nNszEZk0vJY7H6hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlEitsYMufl/RTK80oncPmXRyCCKOwV+u4TJBWr/WoAI1pBYxnROTNx5U/3K8qbvv
	 bxqiQjjVIFxZnaiHtC4xcstgbVoRNfaSaWBzjHvhbA541nECWtLI84Tg1NCylEUE51
	 eUQ3KBCc4Es2kHrjKjDcT3Lii/Qs2HlFqI/gEci4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 28/58] ASoC: tda7419: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:30 +0200
Message-ID: <20240927121719.941466677@linuxfoundation.org>
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
index 386b99c8023bd..7d6fcba9986ea 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -623,6 +623,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



