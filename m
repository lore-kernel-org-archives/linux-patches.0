Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181C226D0B;
	Mon, 10 Mar 2025 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627967; cv=none; b=YGo648T2X68g8mLyjeNPW34zRoJDBZ9+GPNJ3yAY8T54z1AI1RLbKH3YFkPyM3WB2DpOtfAx8T6pzE+n/40Sf2ZfcTVaOpy/FTeqRYh9d2KA0HsiTC6c6UmW4UqjyXd+jJRUCE6NmM7BDgPqmt8v3kuYZpyHnV6dLQYDTRW2MEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627967; c=relaxed/simple;
	bh=Axfo/L64th7j0VT7l4jJBEE8uC5q4gH2OkQ4vS6j83Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KqEVclW42xxmyHam/8QBXGsJ0DEyywzgGguSYojq4v+HfZuFEYbl8qnPFmAgXn9IuWPRPtU+Zhste58VEodWNbQoL++/Cciq9Wv8KpF9r5agl2z5aVo+iRv1ZYjY8p3CJvzATFx47cndA5Xf1vYwFjUvdOOMOOl/iN6cz1xiPkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raKyyzsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raKyyzsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA11C4CEED;
	Mon, 10 Mar 2025 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627967;
	bh=Axfo/L64th7j0VT7l4jJBEE8uC5q4gH2OkQ4vS6j83Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raKyyzszK5Cx8GyMHyWbqSkjaA22PaX4vcwD+Vw3m/Zyfrq52QgbFD86H6T5Y+vTY
	 tpB7y/tR7EZgPyhnAe3K0MfvQGU/kxITIAaWlJGWhBt4avF6TFj2Wco2KdRhhw3rdf
	 alLMDOiZGYD2nWaMQarJ/OCm0d10DIgmYXfWRKeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yang <804284660@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 042/145] platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
Date: Mon, 10 Mar 2025 18:05:36 +0100
Message-ID: <20250310170436.434297030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mingcong Bai <jeffbai@aosc.io>

commit d0d10eaedcb53740883d7e5d53c5e15c879b48fb upstream.

Based on the dmesg messages from the original reporter:

[    4.964073] ACPI: \_SB_.PCI0.LPCB.EC__.HKEY: BCTG evaluated but flagged as error
[    4.964083] thinkpad_acpi: Error probing battery 2

Lenovo ThinkPad X131e also needs this battery quirk.

Reported-by: Fan Yang <804284660@qq.com>
Tested-by: Fan Yang <804284660@qq.com>
Co-developed-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250221164825.77315-1-jeffbai@aosc.io
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -9911,6 +9911,7 @@ static const struct tpacpi_quirk battery
 	 * Individual addressing is broken on models that expose the
 	 * primary battery as BAT1.
 	 */
+	TPACPI_Q_LNV('G', '8', true),       /* ThinkPad X131e */
 	TPACPI_Q_LNV('8', 'F', true),       /* Thinkpad X120e */
 	TPACPI_Q_LNV('J', '7', true),       /* B5400 */
 	TPACPI_Q_LNV('J', 'I', true),       /* Thinkpad 11e */


