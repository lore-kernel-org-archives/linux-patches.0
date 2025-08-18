Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD2271A6D;
	Mon, 18 Aug 2025 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526017; cv=none; b=uZTiSkGQdiwpR/sLx9Kauh9We3sWUptZVdF+2wf32CGAAuXoxRPTv0igbywtzmuNhnRt5THAhS3lbt5L1QvhBEg4s9PwWLADFXanaSVUk5o5yY/3TVFXV6NjJQ8fRnXZJ9rFyiVe4Rb9dsyQayXl+d3iS+BoZbotsQAgQhTlDnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526017; c=relaxed/simple;
	bh=Oc+YRWlrBPxYILG7Lgka80pTZS1q9T/hdyCu5bFGJdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lylltcdk4cKPsZVGNVNR/2SXELSuKBO8rAkFRwLx4rY1QzwmHauvRs25Nb1Hiz167fsSumN6Y/AKslICD2Ij+0a4i8LPZYyTt1PrDpI55MDGrIPz1w3taOdf9eC+JB5Av+gki/mEVvFXtdZN836SfQ/uFoblzkR77AKNvLJrpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgGPumj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgGPumj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A33C4CEEB;
	Mon, 18 Aug 2025 14:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526017;
	bh=Oc+YRWlrBPxYILG7Lgka80pTZS1q9T/hdyCu5bFGJdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgGPumj5/Tc/m1I/QdgPcGynOjAN3kesFWHqqH37d7HO26SJwCZB4XB61XqsMzQKs
	 646rkKysggoqgsHfB6z9JdpB154hDE3tv2FXAW1k+MqeXgoGfJ1ibfmfD0ZjP0WW8s
	 znOV2gw8n648bJ2J9jnh8cTH6VEmcoVzTfFvnxVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"fangzhong.zhou" <myth5@myth5.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 434/570] i2c: Force DLL0945 touchpad i2c freq to 100khz
Date: Mon, 18 Aug 2025 14:47:01 +0200
Message-ID: <20250818124522.548502914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



