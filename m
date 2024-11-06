Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3391DF26F;
	Wed,  6 Nov 2024 12:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894848; cv=none; b=APKTaDXtLmD/HAsouUQyCbA3YDI8PEENptMiCpZDbS/BNCfIIwtdzSEsE17NdoreIMhW1TpyJFTILcGzkGEZODMdcOd6akuHBPABbepfUjks/moeN/n3IzAh++bF+xHR/3uXjPdwytZ7Q1p1mupIgWHtTt8aulocQ4Pmz19q+QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894848; c=relaxed/simple;
	bh=Anqu1gQqtdUgsIJn5ZHSe7Yd5Rt+j2yMINWgPZzAJyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amxK1fd00gXoeDIqElfHJSbTQEXchVYN5gUbtphydmupWECL4RCaiFRsVw6ks9GQUt44kKUHzCQdb9knbZfH4KcByG4zEhGDup9EC6mM5YFlYEJub99gIG0UIIo3qBvgFqnj/A7pk7gsrlQlAsRkpR4N43tBz35f2+wqPJPjlDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igZAp7Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igZAp7Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506EEC4CECD;
	Wed,  6 Nov 2024 12:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894848;
	bh=Anqu1gQqtdUgsIJn5ZHSe7Yd5Rt+j2yMINWgPZzAJyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igZAp7Q357eZpFQHFpzz/87rdgaof33YqXKyIPamuy2IwaUDdAxho+NXVAukfIohF
	 r51LUKGlB7PI7UicCROEpvg0hKunzkTyUn7WLWKCDKfQiAqkOBTQIaZYMMdOnoXe7+
	 Q0togfm6VsXCw83isXw1zfnZ9qwluU8CmuJuYjNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/350] ASoC: tda7419: fix module autoloading
Date: Wed,  6 Nov 2024 12:59:09 +0100
Message-ID: <20241106120321.400200032@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7f3b79c5a5638..a3fc9b7fefd81 100644
--- a/sound/soc/codecs/tda7419.c
+++ b/sound/soc/codecs/tda7419.c
@@ -637,6 +637,7 @@ static const struct of_device_id tda7419_of_match[] = {
 	{ .compatible = "st,tda7419" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, tda7419_of_match);
 
 static struct i2c_driver tda7419_driver = {
 	.driver = {
-- 
2.43.0



