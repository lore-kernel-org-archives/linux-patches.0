Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600E117555;
	Sat, 30 May 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165153; cv=none; b=eTY5DJCOSJVG1u5pu304GzoCOP8m+CkU7mhgnR5XMVcAX7Bt1P87RVizc/1qi78pVCi6uJ+9D33WhG44p+AGRu5bD/ww8sXelRz7zgXRxRuqHfQ7tRZQchVFE71OjVv27qokx6LJRRoJmAoI6lukrAjmXi3LGslodji2BgD5Moc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165153; c=relaxed/simple;
	bh=ZFDs/TdEcWcnnc6MiMNW7adTwvSdWYG2iK7L7gldvUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eG1WXIqN07orET2VzTVNR6EXwYs/zFri810uWH/BAt/C0WIOr8+cSd54DuesgsoQ3qUyjcFDCU4K+HPM+0N4GrbCrpadM0OItxzeO3cW+YYBysTv4p0TrQsusIGz90aGHRMPlNWy3u1QFd1UrC+xDG6UtpxLaRQnJnVLhz001oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2aySFu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2aySFu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A385F1F00893;
	Sat, 30 May 2026 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165152;
	bh=pO8PF2sk4I+cm+jT11jkYm9igA08Fm6iOTyC55jbxYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2aySFu7aRJmba+TrhdtlVrmjgTl4g6pRAUUaBN4o1WYNoG3p8hTU4O2mv5O3THZE
	 SEPJVnjnLtzCvr9Peg+mhlAp3owVPtOh4F10b9df14yeuyHe5+z541vnGt+piCiG+O
	 bVH7F7gPBQ4JYRMQE63DHKreXxzNxa+wixyI5tN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 765/776] platform/x86: hp_accel: Check ACPI_COMPANION() against NULL
Date: Sat, 30 May 2026 18:07:59 +0200
Message-ID: <20260530160259.501268958@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit abfbe5ee8ae89f1f5449790423d5dd3e423545bd ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
platform/x86 hp_accel driver.

Fixes: 8ebcb6c94c71 ("platform/x86: hp_accel: Convert to be a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2425918.ElGaqSPkdT@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp_accel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp/hp_accel.c b/drivers/platform/x86/hp/hp_accel.c
index 62a1d93464750..eb5e533bf0866 100644
--- a/drivers/platform/x86/hp/hp_accel.c
+++ b/drivers/platform/x86/hp/hp_accel.c
@@ -300,6 +300,9 @@ static int lis3lv02d_probe(struct platform_device *device)
 	int ret;
 
 	lis3_dev.bus_priv = ACPI_COMPANION(&device->dev);
+	if (!lis3_dev.bus_priv)
+		return -ENODEV;
+
 	lis3_dev.init = lis3lv02d_acpi_init;
 	lis3_dev.read = lis3lv02d_acpi_read;
 	lis3_dev.write = lis3lv02d_acpi_write;
-- 
2.53.0



