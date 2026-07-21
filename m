Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968FC3770B;
	Tue, 21 Jul 2026 20:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666244; cv=none; b=uyfF/lctmvXUkTaQwHh0qvzaORQpP4Dz+wAEdtJPXidlIOUnkukuD2ma5JtdbnpDg6B3rc06lfG1Qomm8YJlgaRhBGStD1muTImnFnyN/uAErLA1VLTX07d+EuL+p5PrUcvcH4UabvyhFpn5065R9sTXunRl/bW4k7EFi0Miuf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666244; c=relaxed/simple;
	bh=EraYHdI8oHal0TWMGFuzhMU60N6FKkKDr6IS1OaossA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTHQiP6wWSgDp6UXy53kvzwR100r8viADhPqav4MBm0f9jetsoIJ3A6RsXKGmwjW+Dx6kuJuQGxyfZLou3r6mvF9/EVUYihUFC6VyvBjuL3uT/ZZDNf/0E5qR1BeLs879FooWVMAFtbyBuVhSAyfotYkib9pB81zNe20w247gUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtBDf0AB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtBDf0AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33FB1F000E9;
	Tue, 21 Jul 2026 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666243;
	bh=CVshL7VAwq4PyI5CZWShAh1tCk4lib5V0O4xcu1jjMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtBDf0ABeI+sSQmF8qwy+O3kgOOjfuYaUH+PkZohbiMse+wobHxpV+u5junS+B0/J
	 TKyt/ZP/HpK/p2J7VrSwG9HXNFaNi+t5NWXh7PS0DAcvuA8Xo37WdX238dIOU2loYe
	 gdXD1uRow3MtksFKblPgKS9SVTtAMO1gtYBQQ5Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0610/1266] x86/platform/olpc: xo15: Drop wakeup source on driver removal
Date: Tue, 21 Jul 2026 17:17:27 +0200
Message-ID: <20260721152455.514111902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



