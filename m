Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232E2FFFB6;
	Wed, 25 Feb 2026 06:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002627; cv=none; b=VJccdnO/EG2VtX7sznU+YgoKwdJSHP+FJzI7by4DoOEqVJSHLnvACN61rE9vAWiqE9DBOHrcAvEcVApkcAMDvz5ZTDERXiOGvyPztRwighGiem2HY7zT9br8ml4FNbaR75EFy2SKQkUKj07ZuPE3cJfwoqduQ+as5Xb7j+trIXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002627; c=relaxed/simple;
	bh=hIS7d0dErC/+aWpe7Azq+GW1c5eVrqCjBPodVwIC+HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDJL/m0MXiouhk1wDwfj013EVzpQMwDrqs4VgKYV1ipEBN2U+zI9G2Uh5xmFeQEEjVtQuZZVodmpvVnrT3PI0uIOBdQ88RDa/n/SEwD2V12Skrp0WQSJAgyJWTsWDCnKOpTvnc0FgwxJFDcsq2W+4PQogyZXTHezwt4GzdtA4g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQuSnrTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQuSnrTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA2C116D0;
	Wed, 25 Feb 2026 06:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002627;
	bh=hIS7d0dErC/+aWpe7Azq+GW1c5eVrqCjBPodVwIC+HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQuSnrTMwlBgzVJbeFIGK2NoW5miXG44JcpebE+kx3/e8UcfxF1fmNG56RMuNFKaW
	 uDJCXJPm27lW3Kfi0Aku0Ua2Z7wKxP0wc2oK8v4dIi3PVmp0aSEWawZCWKjhHK/REb
	 M/vpOlkovLL8tWNAebBOBM9KHNTUpSrz6Z6ibYSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/641] power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer
Date: Tue, 24 Feb 2026 17:21:54 -0800
Message-ID: <20260225012357.983964944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit c655f45480637aee326b5bd96488d35ab90db2b0 ]

On the Dell Latitude 7455, the firmware uses "LiP" with a lowercase 'i'
for the battery chemistry type, but only all-uppercase "LIP" was being
recognized. Add the CamelCase variant to the check to fix the "Unknown
battery technology" warning.

Fixes: 202ac22b8e2e ("power: supply: qcom_battmgr: Add lithium-polymer entry")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260120235831.479038-1-val@packett.cool
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index e6f01e0122e1c..ff77dba29a3ef 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -1244,7 +1244,8 @@ static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry
 	if ((!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN)) ||
 	    (!strncmp(chemistry, "OOI", BATTMGR_CHEMISTRY_LEN)))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
-	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
+	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN) ||
+	    !strncmp(chemistry, "LiP", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LIPO;
 
 	pr_err("Unknown battery technology '%s'\n", chemistry);
-- 
2.51.0



