Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFA42BE058;
	Tue, 26 Aug 2025 13:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214722; cv=none; b=i2qnUv8JKtRySWNePvgYpzrn0WYI70y+frplxp5JGwX8bEw4s+k1/E3n2OgAgRZ8zB74FvJ7koXJC7kKRbJtHUQFXV+1x0nLPlpaFXmgm2AhP4ZIB4sOIMuWH4kcCPrbyN+pCVV2iXLkprXeTm1YaVjRmpvd6bN03TsWB6IxRH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214722; c=relaxed/simple;
	bh=v6PRzoqXYUgWsJkr8aNIIB/CIm617VCTsVftjch/LVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY5xh07ULUqDVOV6jvmICJuJpii/rf/NzPbsSmjbh10dZjrCoN4tr3oo5ZGfoII7ehrjmsX40fJYJqZ2xcpexJ4Ba+89LaQUCyYH+Ee0PKmJE6YwhApeTDmlUmKy3LPM6ElO//CTimaIkfbcsVtKUwg2G1zU/DTgH3I57AgW/94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjBzQShN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjBzQShN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE33C4CEF1;
	Tue, 26 Aug 2025 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214722;
	bh=v6PRzoqXYUgWsJkr8aNIIB/CIm617VCTsVftjch/LVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjBzQShN/ptb9qdY2qRW958M7nlKYy0fP54+Z+LF36bzngf0ysBGYI1cMNuH6RhqU
	 edru5/c5QvWISz5fBE38IYzA2S3CP6RcCIC3dQr8UMvsHmAwQ4z46J14zqDswVA6Kt
	 X5icdKwZKtbAA0ggHEh0G3pneF6tCfJynUqi4mpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/482] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Tue, 26 Aug 2025 13:07:50 +0200
Message-ID: <20250826110936.136113540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangzhong.zhou <myth5@myth5.com>

[ Upstream commit 0b7c9528facdb5a73ad78fea86d2e95a6c48dbc4 ]

This patch fixes an issue where the touchpad cursor movement becomes
slow on the Dell Precision 5560. Force the touchpad freq to 100khz
as a workaround.

Tested on Dell Precision 5560 with 6.14 to 6.14.6. Cursor movement
is now smooth and responsive.

Signed-off-by: fangzhong.zhou <myth5@myth5.com>
[wsa: kept sorting and removed unnecessary parts from commit msg]
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index d2499f302b50..f43067f6797e 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -370,6 +370,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 * the device works without issues on Windows at what is expected to be
 	 * a 400KHz frequency. The root cause of the issue is not known.
 	 */
+	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
 	{}
 };
-- 
2.39.5



