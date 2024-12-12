Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76062135B0;
	Thu, 12 Dec 2024 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018738; cv=none; b=Oyw0pKdMp+BlCw+5MGWpBqfwsZtDon1i9EnNvjvmh3IpbnMzg4ZKt18/BiDimH1Oq8CWZzK/HJ5aGiTDsc/zyqAH8/QNq1Or640lhVPbwAg1RXoItNC/kD4S96y2Z6T6tDB9sbqnKsy2ycIO5UM20lVlH8MI/t7w+Y9wjBZE4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018738; c=relaxed/simple;
	bh=3MsG6oe5a8t2Wa0+4dmPDMX8AypKfrVzUNRMagMpCWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js57jCVS3mv2kQ+kEGkjTGSSQ5cg9NOn2dX664HJl1gJ3vycb7ytDgWAA9ubLk8WzyPOzgwwHy0zimTqdq1i1bJvi6D/CU0LOFPxjMbouVxjJKwCwUKlRqa0LgvlzIinTwT/S9axmm9MfsOcZFQa6BrFIYBCBdt1fX5ouCmzo/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cChfCdCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cChfCdCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23310C4CECE;
	Thu, 12 Dec 2024 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018738;
	bh=3MsG6oe5a8t2Wa0+4dmPDMX8AypKfrVzUNRMagMpCWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cChfCdCHjlmlI5WjQw1GoFNt4YCVt/2IVt3bAsKqeLkyGJPZK6jSol9LIkLzTLk9A
	 nvvNKlICnOLSbl30VqpG+l1U7UujeXwZTPsS4MfQBHwteGLBI+fqrAn/VFzb7jUkzO
	 JEvrj6kkRzFb1MVUTro/FNvO1/TI+QbqKoY25dBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Petri <mp@mpetri.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/772] ASoC: amd: yc: Support dmic on another model of Lenovo Thinkpad E14 Gen 6
Date: Thu, 12 Dec 2024 15:49:24 +0100
Message-ID: <20241212144350.738547992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Petri <mp@mpetri.org>

[ Upstream commit 8c21e40e1e481f7fef6e570089e317068b972c45 ]

Another model of Thinkpad E14 Gen 6 (21M4)
needs a quirk entry for the dmic to be detected.

Signed-off-by: Markus Petri <mp@mpetri.org>
Link: https://patch.msgid.link/20241107094020.1050935-1-mp@localhost
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c18549759eab1..f46158b840a51 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21M3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



