Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBFB336EFF;
	Tue, 16 Dec 2025 12:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888120; cv=none; b=FQWTMLJ15EZOT6lcOvdlXaidNGPXikgsyNTLai/zVYOSQzi35NeXTDX6JA8tw3J8akPmUl9J6/4lhaVuAf+qRp21MiRzvbYSk+oymWalZFs0pZZfHHy47cMkVKkqEFhDgm5y4xmicYX1itOnHMudc/dnmb/DzJrKVdVqBNv8DNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888120; c=relaxed/simple;
	bh=X8lZhWYfw9y32RK4GZ+UEF+BJ47yECQk/OuV7PD6j04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivef0Ns2kSgz37yoRDTpwa+ID6nKPB27kLRYr54wbYsvPjswjwoN0Hy5kWb+mzCJvM4nAM1ROSyQYw5njg+R7+N4GdW1p2pVD7f1b9YdMaxFdLjj9qMe6APUSRVsLpL5aeEwsWmNmQE6brqlYCVFqfBZBNBYfDnhOsUJk19rEZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZg4tVX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZg4tVX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39168C4CEF1;
	Tue, 16 Dec 2025 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888120;
	bh=X8lZhWYfw9y32RK4GZ+UEF+BJ47yECQk/OuV7PD6j04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZg4tVX/ZJjdFntq8T73XuDh8LkQRahINu/iI4K/J9Xum6uOokEE6gKm5FyLpVNVM
	 dHxeOrHwj7wZmTDgwlHBfRnhtf2sSfb3/dk7Z7gmASoshTFdbhMJG1Oeolf/qF4P1I
	 dpNEfpWNr5U/IHD0NGFr4YVEnFJXO1ikn5RrX/UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 438/614] ASoC: nau8325: use simple i2c probe function
Date: Tue, 16 Dec 2025 12:13:25 +0100
Message-ID: <20251216111417.243479270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit b4d072c98e47c562834f2a050ca98a1c709ef4f9 ]

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20251126091759.2490019-2-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: cd41d3420ef6 ("ASoC: nau8325: add missing build config")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8325.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/nau8325.c b/sound/soc/codecs/nau8325.c
index 2266f320a8f22..5b3115b0a7e58 100644
--- a/sound/soc/codecs/nau8325.c
+++ b/sound/soc/codecs/nau8325.c
@@ -829,8 +829,7 @@ static int nau8325_read_device_properties(struct device *dev,
 	return 0;
 }
 
-static int nau8325_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int nau8325_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
 	struct nau8325 *nau8325 = dev_get_platdata(dev);
-- 
2.51.0



