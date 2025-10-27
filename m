Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCDB329C6A;
	Mon, 27 Oct 2025 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593301; cv=none; b=V2nbYiXQ4MvNdFmeU+KpOLgRhWd0leePYse51FL4C3Ok5kfBJgqT7ui7qQhih4bWbSq+L0/RfGWXoTy+j4cC13OrE3D1lAhFLhHF8/JJt6UPyBK240kUVUzKwGppU9dRZTllpIx22XfhW96uhxcE8F+xx4bAnhs+xs0Ki9lXFM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593301; c=relaxed/simple;
	bh=xY/Z9tkp/KHScMdmNlCWMEWj4on+Bl2KdVEUgNS2G5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4eqUGq/OytWM9Y9+TQI0mme6iAayASEKw2P3HVuPr86A5zduqOkcFQPvOFJjmkHRoFHL4KAeLTGRYb/hp1zjXpT7kGNye8J7zEIyxSDgNOzfBDkLOdpFsH3BoZd1j0j9pNDLPKn7IKVRfqk7QBMYYsMSqgF/kI1C0USadWrqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EudRLQUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EudRLQUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4067C19424;
	Mon, 27 Oct 2025 19:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593301;
	bh=xY/Z9tkp/KHScMdmNlCWMEWj4on+Bl2KdVEUgNS2G5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EudRLQUc3adg6lxp3PzBQW10aCThI5wLCLfExl1hoBbg23aUgke/BGvBPYN5rGAjX
	 gFo01d0fmlRU/z3gBeGNV3zUCpKhkOuEtdj43ahZwhmF8/LGhuhLUcSZ8Xe+3p3Utc
	 ZsGSDkNb//uDz565J4qnSJVoN9i1VmlGu4tYLZ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexis Czezar Torreno <alexisczezar.torreno@analog.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.17 090/184] hwmon: (pmbus/max34440) Update adpm12160 coeff due to latest FW
Date: Mon, 27 Oct 2025 19:36:12 +0100
Message-ID: <20251027183517.318986654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>

commit 41de7440e6a00b8e70a068c50e3fba2f56302e8a upstream.

adpm12160 is a dc-dc power module. The firmware was updated and the
coeeficients in the pmbus_driver_info needs to be updated. Since the
part has not yet released with older FW, this permanent change to
reflect the latest should be ok.

Signed-off-by: Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
Link: https://lore.kernel.org/r/20251001-hwmon-next-v1-1-f8ca6a648203@analog.com
Fixes: 629cf8f6c23a ("hwmon: (pmbus/max34440) Add support for ADPM12160")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/max34440.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -336,18 +336,18 @@ static struct pmbus_driver_info max34440
 		.format[PSC_CURRENT_IN] = direct,
 		.format[PSC_CURRENT_OUT] = direct,
 		.format[PSC_TEMPERATURE] = direct,
-		.m[PSC_VOLTAGE_IN] = 1,
+		.m[PSC_VOLTAGE_IN] = 125,
 		.b[PSC_VOLTAGE_IN] = 0,
 		.R[PSC_VOLTAGE_IN] = 0,
-		.m[PSC_VOLTAGE_OUT] = 1,
+		.m[PSC_VOLTAGE_OUT] = 125,
 		.b[PSC_VOLTAGE_OUT] = 0,
 		.R[PSC_VOLTAGE_OUT] = 0,
-		.m[PSC_CURRENT_IN] = 1,
+		.m[PSC_CURRENT_IN] = 250,
 		.b[PSC_CURRENT_IN] = 0,
-		.R[PSC_CURRENT_IN] = 2,
-		.m[PSC_CURRENT_OUT] = 1,
+		.R[PSC_CURRENT_IN] = -1,
+		.m[PSC_CURRENT_OUT] = 250,
 		.b[PSC_CURRENT_OUT] = 0,
-		.R[PSC_CURRENT_OUT] = 2,
+		.R[PSC_CURRENT_OUT] = -1,
 		.m[PSC_TEMPERATURE] = 1,
 		.b[PSC_TEMPERATURE] = 0,
 		.R[PSC_TEMPERATURE] = 2,


