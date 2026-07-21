Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A846AA8F;
	Tue, 21 Jul 2026 15:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648435; cv=none; b=AA85JmH7/Hpar1eqPkkQ1FIDAB8tOThS+eKz0CGrcHiRnBLpwAGox8i4Ksehd1pwOKCv+N69QJi0Nppkek2RIVq6uTT1xccx0NH9wM3TUUgILuhPOT7efJXs3hsPSjCNVxQ4JPLpnkR2aU7+BlPgCscoW6enkkxjh2TYaz9a8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648435; c=relaxed/simple;
	bh=jvd8hDJlVYB36Tkm17q7jccuE3lTnIWYTO8hns8YKAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2CQKKuf7fbpuNYRob6g/GvbPChWMEqKy4U4zmU4oiJjptat96mNkCcMezcdLX4YK8scpkEiUHFoeJpVO5FUR+NWm/92MfCMyNMSdm0or5gj8bL5SWVwUBsrgt+FGCQSjMaIMvnM2ifDFiBA6kqxRWIFi7TncKQDvHX+mvVfXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjBiN4Xw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjBiN4Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718931F000E9;
	Tue, 21 Jul 2026 15:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648434;
	bh=wemoyxs1fdHV8ig6xfHvfu678nMCnnTmCR0n4Wjcrbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjBiN4Xwjorb8fQyqNqLLUT4cljEJpWEawITNnKAnoQM3TGqZE1w18kD1TXGO/nlg
	 dOSGeOE7e9upntsnX3GVUP2VEk4j8O7ENNQRzAsHHMFqX/BKE/NxA7+QL2qtBRNEFw
	 +K6CPZxmd0Evyys+bdEefGXiki0iputv4reIeARA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0198/2077] platform/chrome: chromeos_privacy_screen: Check ACPI_COMPANION()
Date: Tue, 21 Jul 2026 16:57:51 +0200
Message-ID: <20260721152557.351444182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 8a4a217f617b1ac2f8c095f33efd67d947ddb2cf ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
chromeos_privacy_screen driver.

Fixes: d3c2872ae323 ("platform/chrome: Convert ChromeOS privacy-screen driver to platform")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/3357444.5fSG56mABF@rafael.j.wysocki
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/chromeos_privacy_screen.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_privacy_screen.c b/drivers/platform/chrome/chromeos_privacy_screen.c
index abc5d189a38944..407b04207de2fd 100644
--- a/drivers/platform/chrome/chromeos_privacy_screen.c
+++ b/drivers/platform/chrome/chromeos_privacy_screen.c
@@ -104,6 +104,9 @@ static const struct drm_privacy_screen_ops chromeos_privacy_screen_ops = {
 
 static int chromeos_privacy_screen_probe(struct platform_device *pdev)
 {
+	if (!ACPI_COMPANION(&pdev->dev))
+		return -ENODEV;
+
 	struct drm_privacy_screen *drm_privacy_screen =
 		drm_privacy_screen_register(&pdev->dev,
 					    &chromeos_privacy_screen_ops,
-- 
2.53.0



