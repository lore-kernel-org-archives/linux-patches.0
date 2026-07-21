Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FA3432BEE;
	Tue, 21 Jul 2026 19:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662486; cv=none; b=lpdnWMK72Cx1ZAdzgmhKmash+Q0bbiXQaZ10g6aTzgok2d/JXZ7rdXJ53HJsrQcZ3ngLJK8MRd0CiK7TryV9xTG3ibuVyD146LwrpgWqzZkzgHrZhcn2OqtPKbc/mBWbC9LYJ47c32a7viQOVT5OfFCtIXL7+OMe0Irm/p0OqkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662486; c=relaxed/simple;
	bh=LEJbQowXv7STIGXA7UkLapAEUPhY1t8JnBlWgw0lVXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oC3m8ahQs2c2EltLkxpAgfeDF7E+Q7QS7P6lsMlrfoq8bLt5muqUyzw4Sw8vkiOm3NJIyV8In9gFRdHbS0c0St0q1kDmMJcstNds3MCulaGLtSwyp2ArP6WYi8OUKVzE5yw/n8jBalZDe54gXQ4xyNayJWfz4lXYWHas1+LecSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+0zpfnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+0zpfnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487721F000E9;
	Tue, 21 Jul 2026 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662485;
	bh=sOCuvGvRLPgqSP72uTAB7r6ycmL5RiZifWHThHk7A/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+0zpfnM6xepOcXawI6gZQNWuSM6wOVJPuusvvrZSADBJHNHHpj0Rg655B77LM5ny
	 FAZt7lzzhbojnI65hKU3PoWDMmLiEBt0zAkaapLL3JDWh4TgFqL7zmoOjH3Xew4uxJ
	 GixoDdGNFel8vdzVmU6u2hbOIrGrwVh/ZH9tsMZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0420/1276] x86/platform/olpc: xo15: Drop wakeup source on driver removal
Date: Tue, 21 Jul 2026 17:14:23 +0200
Message-ID: <20260721152455.501629308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit cc966553e6ff0849978b5754531b768b0ff54985 ]

Prevent leaking a wakeup source object after removing the driver by
adding appropriate cleanup code to its remove callback function.

Fixes: a0f30f592d2d ("x86, olpc: Add XO-1.5 SCI driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2069931.usQuhbGJ8B@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 68244a3422d1d6..683935da493d27 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -185,6 +185,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 static void xo15_sci_remove(struct acpi_device *device)
 {
+	device_init_wakeup(&device->dev, false);
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
-- 
2.53.0



