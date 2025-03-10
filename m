Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E16E22D4C3;
	Mon, 10 Mar 2025 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628421; cv=none; b=MeEF8QpKEDJpYu99PDaVb80FJhprwS8/47xaVAqbPqe2H6bp6Btihz6h3q1F6UN/jMjHK1tinG4ImQbSCSuwTmTNvpNyM4nIvuzLJsV6OaHRgV5Fx4/LpcRaMdD92Es5pieTs4PEVHexF6RR4mVCFduBxBbsX7Ah2iCWEPUUBv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628421; c=relaxed/simple;
	bh=fU+KOGC5O29dZOR4vQoVqpQejA7B4xXtPVVpLUJZPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXyV1IVfVLq0LGMjWYYXdpnmDaQRWpa8kXBpbtxakjvy6D4i6weujJl2iLwdlWR+VMnTYaWM9PPKBjZ2zSyN6hHa9uFcJSmf08nYnQNkwSkdpko3saGUg8jNUJmoN9CPF7qfmxyUZPwZVc8Io7RymLekXU0EYM/WKG+eGHITGD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5LKodKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5LKodKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866CC4CEE5;
	Mon, 10 Mar 2025 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628421;
	bh=fU+KOGC5O29dZOR4vQoVqpQejA7B4xXtPVVpLUJZPyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5LKodKD3TnsrerTMsQfMvknuPOA0W+8MzcxjUVgrkwnbbYFBr8fUYtfCuQ2bEg8k
	 YQplcJfFeSA2v04rcMwf7Sb5Hman+rls2UmXQ+tZdwb/bp0Kc2QYV1eys1ZEsMxes7
	 g6/O6if/sJNEW6FeW63935izseJshtXIT38p5U7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yang <804284660@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 021/109] platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
Date: Mon, 10 Mar 2025 18:06:05 +0100
Message-ID: <20250310170428.394267614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10113,6 +10113,7 @@ static const struct tpacpi_quirk battery
 	 * Individual addressing is broken on models that expose the
 	 * primary battery as BAT1.
 	 */
+	TPACPI_Q_LNV('G', '8', true),       /* ThinkPad X131e */
 	TPACPI_Q_LNV('8', 'F', true),       /* Thinkpad X120e */
 	TPACPI_Q_LNV('J', '7', true),       /* B5400 */
 	TPACPI_Q_LNV('J', 'I', true),       /* Thinkpad 11e */


