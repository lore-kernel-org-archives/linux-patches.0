Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD983F2101;
	Tue, 21 Jul 2026 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660099; cv=none; b=Qm8gi5nEebCuYyEnQlafLwOMp1LaLPNNEW/Yn06lXH3+GXAccOhcLRjpBeYZMTdVosNGAL317U/CG2NXtA048zWcR25dnjc4xNB8cwaR6FPaZ+GzTEMm5JRnx9S6VtCLybmCS3rH8xk3kuQfE0dReINrhPqWDnIE7TZ5C3JF/X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660099; c=relaxed/simple;
	bh=+Q3ZBC3/eLmYP0YGP+4SClTE6XHAFm4uYAGTqNqSrSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hqb9JgUfvGomah7+RlPKlwU7wTxP0YlEclq7/qIdC5EDC1SkGbjMd78PpJn8sFdmrnYr3o5Z4ADsR+opPR9VWawGS5uAbQ4PKL4ecWBQfPK7BkJ3kzjnA8D/dQ28McwdzL+I0IWpSGwJyoLM3mQH1L4K2WDUspEl/k/0vgswvc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeybD2Q9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeybD2Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A554E1F000E9;
	Tue, 21 Jul 2026 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660098;
	bh=vpXqbKDQPvdskiyNjEwCTV23/ZpaYznBina/9WdfquM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeybD2Q9lk93HXyE+xTHIuV/Q39kYimBe020AnsRW65bL42r/bW7Tl9PYZqwz4m/h
	 FkW0v37fNCJQRGxrmpHLBq8vXxFp+JFQe7WpaqmGoA6Z+ZZ8f61b633htE+K1lCzlM
	 jmIwDCg77eQ7aMRepOCqXmfhEtKq2NJ1oM/XaG7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0851/2077] x86/platform/olpc: xo15: Drop wakeup source on driver removal
Date: Tue, 21 Jul 2026 17:08:44 +0200
Message-ID: <20260721152612.862143906@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 82c51b6ec52889..276caf756a9c50 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -186,6 +186,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 static void xo15_sci_remove(struct acpi_device *device)
 {
+	device_init_wakeup(&device->dev, false);
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
-- 
2.53.0



