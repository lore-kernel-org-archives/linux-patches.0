Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF65C411FA8;
	Thu, 17 Sep 2026 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668026; cv=none; b=G9WDio2aLeoEl5bJGREZfXHuih8qIMD9/0ut8A8/5bKM0O88N5eeCFYvzw61BODYZj6soo9vSlCLV5punV6ydNcW/wPgxXgh/cLW/lvgdyga5P9viWmm+hLDdwpcsjvn59IfVSTmhyioHSaOQologe/ir4O6v4ZAEkq6i+in6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668026; c=relaxed/simple;
	bh=d/hffKFcAQrJaZmEUPqjqe7JdrN4rlQvXaHRRGbF18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JSIHrEw9UVW9D6ru3XOwb4bBkhVHGhMYsLHGhMNI32UlB8vzPtfJ25Z+h4DEwMFTpb9HhhUWxNsIit3k2UuZlI4EiRiyr7jTpcYHo1A9TWCKW6++9kVk/sUEkQDD4VVcPyj/YywJIE6WHS+eyU5/Yy7QPsa6o/9PIyOJbEbQttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5kyWsAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5kyWsAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85901F000FF;
	Thu, 17 Sep 2026 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668024;
	bh=X0pmEKSeoQGTc7YUx1Ijrz3os4/K7VKbFiiYGXG6hTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5kyWsAFl3iOctvW+Uuf6O6lBy6wPToGllUPykAA8a+Bd5u8NIMq2Wq3sdDwS/F+M
	 906xB3NjIS+AaJvd48HxZJ3RjsTjpVgjGPLr2UCG6uj3QFgQQfVfrQiQQZqS+y8GQI
	 kwlJznANfwhF8qA6jWqDHbMciPfUptcGSypUpUso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis de Carlos <reskoldo73@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0256/1102] platform/x86: msi-ec: Add support for MSI Pulse GL66 12th Gen
Date: Thu, 17 Sep 2026 16:03:19 +0100
Message-ID: <20260917151546.023006966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis de Carlos <reskoldo73@gmail.com>

[ Upstream commit ab7be7ed913086e076bfd8aba79f614f415cd6dc ]

Add the firmware string '1583EMS1.109' to the ALLOWED_FW_10 array.
This enables Embedded Controller support, including battery charge
thresholds, for the MSI Pulse GL66 12UEK (MS-1583) laptop.

Signed-off-by: Luis de Carlos <reskoldo73@gmail.com>
Link: https://patch.msgid.link/20260527134750.25263-1-reskoldo73@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index f19504dbf164c..0157e233e4300 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -823,6 +823,7 @@ static struct msi_ec_conf CONF9 __initdata = {
 
 static const char * const ALLOWED_FW_10[] __initconst = {
 	"1582EMS1.107", // GF66 11UC
+	"1583EMS1.109", // Pulse GL66 12UEK
 	NULL
 };
 
-- 
2.53.0



