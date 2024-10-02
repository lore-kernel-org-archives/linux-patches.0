Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F881D0786;
	Wed,  2 Oct 2024 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876574; cv=none; b=NjcvR+wGYOEustmYUpQLcWnSwjeTKZ1cDJnUeH7OCi0vTvXJkkQA4TZFFHE3FimH5KySRkcea/Yg76prAXQ4mCBIVDz6qRNNfUy7UOKLIga5wn3YbQsd4IKL6njrKIW8h9yrFYyIqRToi6wWjFO5okXIP/6uDEw8hxcFq41vdKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876574; c=relaxed/simple;
	bh=5ggDRUF/cn17mRNuJ0ZMiip0jp2larOUMVh7aIAb2/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pO3HYk1MXaNvZuMPcNWbfuf8zkQ0HJrrkQkAZqOzJbZWhXo03hZkViRal8UcKY/3LXnXAaDwn2ANUnZWcDB2tji7Enm7a0Yui4P1UvVBerYJ/ykrJLU85wA256bjkKBaXShb2Pfwh+7KLMcZ73Gh1Qq3QasjM1bCw6RsW6LdXKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOUlhQ16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOUlhQ16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D260DC4CEC5;
	Wed,  2 Oct 2024 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876574;
	bh=5ggDRUF/cn17mRNuJ0ZMiip0jp2larOUMVh7aIAb2/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOUlhQ16GD4SUtYTMfrgcbSOiafNNOpqF5KgFHy06nS5SvK24SisjIQr1iGcdgB0R
	 VPGRpB7qdl88bPoca0ClonF1Ctz6J5sVWv4SlZT4lvhv5lu54BaUPbZgNV7VFKM0Yr
	 ZyFS557h2z/KgxGsqsVoE22YI52IZnVphnd52YR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 459/695] iio: magnetometer: ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:57:37 +0200
Message-ID: <20241002125840.777213150@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit da6e3160df230692bbd48a6d52318035f19595e2 ]

All compatibles in this binding without prefixes were deprecated, so
adding a new deprecated one after some time is not allowed, because it
defies the core logic of deprecating things.

Drop the AK09916 vendorless compatible.

Fixes: 76e28aa97fa0 ("iio: magnetometer: ak8975: add AK09116 support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240806053016.6401-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/ak8975.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index dd466c5fa6214..ccbebe5b66cde 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -1081,7 +1081,6 @@ static const struct of_device_id ak8975_of_match[] = {
 	{ .compatible = "asahi-kasei,ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "ak09912", .data = &ak_def_array[AK09912] },
 	{ .compatible = "asahi-kasei,ak09916", .data = &ak_def_array[AK09916] },
-	{ .compatible = "ak09916", .data = &ak_def_array[AK09916] },
 	{}
 };
 MODULE_DEVICE_TABLE(of, ak8975_of_match);
-- 
2.43.0



