Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CDA1D90CD;
	Tue, 15 Oct 2024 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992238; cv=none; b=hMTZpYE1yPGq3MLZeK1poRGpb238vZMmB2GjMJSKavE0lBk4s35fncAm7ZXpq6mqiDrN4MebkAXDTSnLwL8RzOjUZZ+6uIJMW2tD8zXSYw68uK82Xaps364Y3iYI9agqLDGtZbY1ULsQFp5MdNBrlMnmmmjzsGJYF6lxlHnD6UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992238; c=relaxed/simple;
	bh=m7XYYZ2X1sTU+Eo5Bya32LR3cufD/hAivBSHIQ5XPOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5FH8vjpIvDTxhQms6kotJHFzDG2F9aBKZQ77KwKyvfFfsED/UUNUl6jkl5iGSI6BfK9PQ5eIfS7gfeKDFShJRI+uTxqJ5/1kd9AmEL7xZoOqgsR9gATt+GdP55ra9JV0h0Iz3ReTMkc9x6tVK1JCIPaf9m/w+EpiNwix8Z9ga8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rsd95D+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rsd95D+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B4C4CEC6;
	Tue, 15 Oct 2024 11:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992238;
	bh=m7XYYZ2X1sTU+Eo5Bya32LR3cufD/hAivBSHIQ5XPOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rsd95D+5lHX4QiDj+piqn2isfihWUSic8MQAAwUszVIPhrkaZ/+pC+MLva45mQIdT
	 v/KczMKbc5KiUh7v8tM+CxZlj5rcUufFv8oOWeaWYSQlKQjuQOWAwdWJvwkR7EK6rB
	 BJ7pATCs1jw6kbRVLzLDij1DAlNP8gqS0x5PBWyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/691] ASoC: allow module autoloading for table db1200_pids
Date: Tue, 15 Oct 2024 13:20:07 +0200
Message-ID: <20241015112442.696401743@linuxfoundation.org>
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

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 0e9fdab1e8df490354562187cdbb8dec643eae2c ]

Add MODULE_DEVICE_TABLE(), so modules could be properly
autoloaded based on the alias from platform_device_id table.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821061955.2273782-2-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/au1x/db1200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/au1x/db1200.c b/sound/soc/au1x/db1200.c
index 5f8baad37a401..48243164b7ac8 100644
--- a/sound/soc/au1x/db1200.c
+++ b/sound/soc/au1x/db1200.c
@@ -44,6 +44,7 @@ static const struct platform_device_id db1200_pids[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(platform, db1200_pids);
 
 /*-------------------------  AC97 PART  ---------------------------*/
 
-- 
2.43.0



