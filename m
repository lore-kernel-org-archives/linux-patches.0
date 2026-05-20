Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CFA3D7D66;
	Wed, 20 May 2026 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298689; cv=none; b=a7lrCcckopGIkiOjDTfcilcnifARxNZ2kcWMTegt/6SS8WAL8Tx8/CYRR6qBMReZ0BgIPB5yWYFHQIf1Ip8lG6I+DSeCCZT5NCw2smackVDnmKN9rO+CqIBraJvM2yEDoYRS36qgWBk6fE5TwAOsO5phqU9MgoSwCYRjDZ9FsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298689; c=relaxed/simple;
	bh=yPF8wTYXTNQ8FHUJBN+/qRIvUzqP70i0ZwXSxZuu2iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXg8zUwGYFoGvTCGbLgSCblMmXGcfiP6HzMkeHnyHry6zohoegWAzEWDshgnU58IkzLsDc5VnlNUBgu0a75RQ8nKJctylWozXaFDOR4EyhsAtbgXqsYupkdabbz00tNvVEKbLYIqbO6Fr6Nht9g6ivPFxC1ypLqFDyQ7Naqtbcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6PQY3je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6PQY3je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5CB1F000E9;
	Wed, 20 May 2026 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298688;
	bh=YT2McsT36JaUdDLcPEvAOSP+prfsQFRFPmX/3TRRTMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6PQY3je46ziFNw6L1UAPCdhr0OCSOdNMmmdxQz17JSQa0OO4mvFWAGqwKv5WnIdi
	 TsnMr9Ueu+ERqW9ccOYa68IBbFYOBSIf9gPoA+pJXRLS16FXe8bx3s4GmFO12UkQxH
	 /A1A34xxbPRhJ6qvC9gdLQuKC+roJWcwUrAQ4DWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Chun Lin <eleanor.lin@realtek.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 506/957] pinctrl: realtek: Fix function signature for config argument
Date: Wed, 20 May 2026 18:16:29 +0200
Message-ID: <20260520162145.504751217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Yu-Chun Lin <eleanor.lin@realtek.com>

[ Upstream commit 1f5451844786ed203605528dca9e5d84ed378160 ]

The argument originates from pinconf_to_config_argument(), which returns a
u32. Therefore, the arg parameter should be an unsigned int instead of enum
pin_config_param.

Fixes: e99ce78030db ("pinctrl: realtek: Add common pinctrl driver for Realtek DHC RTD SoCs")
Signed-off-by: Yu-Chun Lin <eleanor.lin@realtek.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/realtek/pinctrl-rtd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/realtek/pinctrl-rtd.c b/drivers/pinctrl/realtek/pinctrl-rtd.c
index 2440604863327..4c876d1f6ad59 100644
--- a/drivers/pinctrl/realtek/pinctrl-rtd.c
+++ b/drivers/pinctrl/realtek/pinctrl-rtd.c
@@ -279,7 +279,7 @@ static const struct rtd_pin_sconfig_desc *rtd_pinctrl_find_sconfig(struct rtd_pi
 static int rtd_pconf_parse_conf(struct rtd_pinctrl *data,
 				unsigned int pinnr,
 				enum pin_config_param param,
-				enum pin_config_param arg)
+				unsigned int arg)
 {
 	const struct rtd_pin_config_desc *config_desc;
 	const struct rtd_pin_sconfig_desc *sconfig_desc;
-- 
2.53.0



