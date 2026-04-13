Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A783016EE;
	Mon, 13 Apr 2026 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097247; cv=none; b=p5cCvSFJmt0gakcQjnEygheLVZNMOx15Y3RZ2Kf9fEItiNltsOa+oSMREIr4iFz0Hlxi6yeDRWVFD2BI5sbhOKt+TwYvbhmB+w6piyogmrSe0KqK/maTO8JG9hEWRTvTUwuLzXREtyJKOrdfCzVfAN5cokZ4UkO5/syc8sss+hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097247; c=relaxed/simple;
	bh=syjddK9CAcXZakdTiGwQGNrZqO/84MO4dKPxVGnYx3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRo/fjE7eAY8er56IwLEFLVroHBuW01nkt503q2ey99WyxroPDMf9JpXeyAkpBxGn8lTq4NVYMmKKdEJhLVBOR6tMusKFhtY4l0pO/Vl1UAPbkszEeAT6l7wqglLvPP1DoiwsarxoG7KzdvWSvC9aXgNhhSyesJonc722a+6A4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut5W7htA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut5W7htA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB62C2BCAF;
	Mon, 13 Apr 2026 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097247;
	bh=syjddK9CAcXZakdTiGwQGNrZqO/84MO4dKPxVGnYx3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut5W7htAXq1i4YqPVzGM5vurRB62HZD/9SwG1Ec9MFwOGroYgz/xcls3wOVRmv/cj
	 UdG1awvWqhRpW08R4BgxynEJhcPKmW4kX6G+myxob62NpAncC0uwn7TKOpZFJda3TF
	 7fLLsn/1xo4P12prEbqxnS/YJZiM7/ljLW4qO0lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Teh <jonathan.teh@outlook.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/570] platform/x86: thinkpad_acpi: Fix errors reading battery thresholds
Date: Mon, 13 Apr 2026 17:53:14 +0200
Message-ID: <20260413155832.801415132@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Jonathan Teh <jonathan.teh@outlook.com>

[ Upstream commit 53e977b1d50c46f2c4ec3865cd13a822f58ad3cd ]

Check whether the battery supports the relevant charge threshold before
reading the value to silence these errors:

thinkpad_acpi: acpi_evalf(BCTG, dd, ...) failed: AE_NOT_FOUND
ACPI: \_SB_.PCI0.LPC_.EC__.HKEY: BCTG: evaluate failed
thinkpad_acpi: acpi_evalf(BCSG, dd, ...) failed: AE_NOT_FOUND
ACPI: \_SB_.PCI0.LPC_.EC__.HKEY: BCSG: evaluate failed

when reading the charge thresholds via sysfs on platforms that do not
support them such as the ThinkPad T400.

Fixes: 2801b9683f74 ("thinkpad_acpi: Add support for battery thresholds")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=202619
Signed-off-by: Jonathan Teh <jonathan.teh@outlook.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/MI0P293MB01967B206E1CA6F337EBFB12926CA@MI0P293MB0196.ITAP293.PROD.OUTLOOK.COM
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 89a8e074c16d0..43a4851d2de61 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9460,14 +9460,16 @@ static int tpacpi_battery_get(int what, int battery, int *ret)
 {
 	switch (what) {
 	case THRESHOLD_START:
-		if ACPI_FAILURE(tpacpi_battery_acpi_eval(GET_START, ret, battery))
+		if (!battery_info.batteries[battery].start_support ||
+		    ACPI_FAILURE(tpacpi_battery_acpi_eval(GET_START, ret, battery)))
 			return -ENODEV;
 
 		/* The value is in the low 8 bits of the response */
 		*ret = *ret & 0xFF;
 		return 0;
 	case THRESHOLD_STOP:
-		if ACPI_FAILURE(tpacpi_battery_acpi_eval(GET_STOP, ret, battery))
+		if (!battery_info.batteries[battery].stop_support ||
+		    ACPI_FAILURE(tpacpi_battery_acpi_eval(GET_STOP, ret, battery)))
 			return -ENODEV;
 		/* Value is in lower 8 bits */
 		*ret = *ret & 0xFF;
-- 
2.51.0



