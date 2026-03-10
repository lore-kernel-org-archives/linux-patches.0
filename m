Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C061C38E107;
	Tue, 10 Mar 2026 11:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142122; cv=none; b=lQb3MVURcwJhngkSypyp9VUvfsFJKnBB9UCc7kALCSPLABDaNUESxqHeH5z6FI+QODICjsAMMuN6BV46nv7gdWZOuEY46dD2OP+z6wBfpTSmLjFKuR4hJsFkNapEqnLU7WHGj7cFdjGvRxE5g3Ld9NDO1CqzZ9PwP6D743mhEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142122; c=relaxed/simple;
	bh=bSRrA3o7dfOb3EBvuUmFh2auWEWtrZPMkDjyJq7Lv1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUoqF13vylwSznV3bUmJVIvztDm43d5l1wnreozlYKVtTtUla6E2aRRsGZYNKblzHITQrRtSZnWzZTThZtiO6mN7r5UPGe+7Fa3yYRJgHT5UYaahVVFzDxGsxUpjaMa2rYV/P87XdJUSn/Ptw8XsQTumW6Cc1VTj0+GNBVScmwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tasHj9/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tasHj9/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC5C2BCB0;
	Tue, 10 Mar 2026 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142122;
	bh=bSRrA3o7dfOb3EBvuUmFh2auWEWtrZPMkDjyJq7Lv1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tasHj9/vauv4VdY8ApfE2na9eyQ9iypQl2Pv6ifq2NRxSX9JFXYoP8/UCI3dRc+C7
	 FbicqXNr4Pg+iqCJd9wczCvWxeekPAXvsujJUprtHrIqBd1rugRy4gTZAELVLxBoKH
	 succ5GHtYDATtjBqzjwpwUu/qDwS6IjSiIp16vnPyZGUuVWXywB0Vp9TUjTtf5nfCw
	 RLErZ26n56x6YoFDBeyPVdQ8tj4GBejKowmssDLav4Mffs0mhb/kzrf2iTkdFaD17l
	 47FDtgtvvFiIGkK6E4LJmct570q7vgy86KCBVYX4BVVwwxAVbnICEZ3GxC2fg9buCa
	 8nywi+1zrU7uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Teh <jonathan.teh@outlook.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/314] platform/x86: thinkpad_acpi: Fix errors reading battery thresholds
Date: Tue, 10 Mar 2026 07:17:50 -0400
Message-ID: <fa3dfbf6ef2fcf250a8269047140657b864c8f44.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 drivers/platform/x86/lenovo/thinkpad_acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/lenovo/thinkpad_acpi.c b/drivers/platform/x86/lenovo/thinkpad_acpi.c
index cc19fe520ea96..075543cd0e77e 100644
--- a/drivers/platform/x86/lenovo/thinkpad_acpi.c
+++ b/drivers/platform/x86/lenovo/thinkpad_acpi.c
@@ -9525,14 +9525,16 @@ static int tpacpi_battery_get(int what, int battery, int *ret)
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

