Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D501E7C1A;
	Wed,  6 Nov 2024 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897921; cv=none; b=ACEBKQ4gvZsmp8F9363Ct7XnuIqNzn1YPT9ySu/qkGRd4DuXYagNsrLDG1Wd6w92ke4NvomEhrcaRBsud7uMUAtoo+9juwRNO17aDIhZiS0nQF2Yavlhynqyeh7Q2AnKw9hn3iN3RdwtjJrM4q7owg5byTvhA3Qk3ck0RhymFiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897921; c=relaxed/simple;
	bh=HmEOgn/y4LNZ2eNudhID1LOQTeKNCfpM9DTv+5BwDek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTEVJJKQe4NvLSomKW1Pp5ybIn5y7SaygHqaZmmXqPMqJcFTPpPn1WzvUqqWUB2E7/I2s84i/Ou2leM6AIg4HAJ26wSrLZ6iJBIinPLqCqYLf5VPn7lmYwXkmkOOtIlN+IX4UnBDHeWaL2NiNvXg5MFiMV30xRtFfpj8IS6vSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOn8EXRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOn8EXRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4C0C4CECD;
	Wed,  6 Nov 2024 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897921;
	bh=HmEOgn/y4LNZ2eNudhID1LOQTeKNCfpM9DTv+5BwDek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOn8EXRdstyvDKn4AvzWmpVX+uq/HQJEAXGR5Z7APAxjvi95AhwDw7g/DIHWqIyU5
	 uQcNyqqfyLQR0QJ7CD1WBUKO+Bofp49gLvSuiIxVvg7yoy0QKytoqAvk4Rtd7ml4pb
	 4GnstVyyrDRm0OVgGfKKQbVUsbe58G/FADCQNYus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/462] hwmon: (ntc_thermistor) fix module autoloading
Date: Wed,  6 Nov 2024 12:59:16 +0100
Message-ID: <20241106120333.070413193@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit b6964d66a07a9003868e428a956949e17ab44d7e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Fixes: 9e8269de100d ("hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Message-ID: <20240815083021.756134-1-liuyuntao12@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ntc_thermistor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index 3aad62a0e6619..7e20beb8b11f3 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -58,6 +58,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_NCP21WB473]      = { "ncp21wb473",      TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



