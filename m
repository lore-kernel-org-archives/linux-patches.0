Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80F1B3927;
	Mon, 10 Mar 2025 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627365; cv=none; b=SXAKwdLE5LcQ7fpL1CprQWjj5MksbRN4Za/qcRf3K/mHcfsBliciCzMjgenjDhu3MaK/sGuhgQqtRsSxonMff1zERsF1vnwepSCUlaB2yqi9ubSzlyRDR1sA34PQQza7AMls7T4xFwfwSYDpiuKs99k7LnsCveDVaiEPGKxbHcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627365; c=relaxed/simple;
	bh=CW8irCflxJrT+Yxhx0AslNDwiuec+rP4f79aISKi7ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IUzDmAkbq9cqEc3n6zJxdMOMJ5O5bj8T4EGT5S2VWww0YmIymFdUVOsAiuc57KIliqV7EIb5vU1OF4wodcPsbIBStFxwfmHzk8nNfAwA+evbH58KsFWTQyeczRIOL9Hwc/TM5975DC1xYe+sCD7y1CiHS1T0Jlt2dfW7dsCndQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osJqaJdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osJqaJdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316DEC4CEE5;
	Mon, 10 Mar 2025 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627364;
	bh=CW8irCflxJrT+Yxhx0AslNDwiuec+rP4f79aISKi7ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osJqaJdDVKPIDkUOoM67+8FA7hqv1gWBbOd1Kw3JFvmQtJQJ3/Jtej7jkqjz9DZVW
	 ADoIPYoBhmht2Esjcz+X2gi4+SZlTfzW4Z+92HMOes3odVDt+jlKu0pbhl9YPqNuLq
	 oAZQQm4bCLS5OfMdaliwFdaNGf1SlERsuycNALqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yang <804284660@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 104/269] platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
Date: Mon, 10 Mar 2025 18:04:17 +0100
Message-ID: <20250310170501.858112032@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9958,6 +9958,7 @@ static const struct tpacpi_quirk battery
 	 * Individual addressing is broken on models that expose the
 	 * primary battery as BAT1.
 	 */
+	TPACPI_Q_LNV('G', '8', true),       /* ThinkPad X131e */
 	TPACPI_Q_LNV('8', 'F', true),       /* Thinkpad X120e */
 	TPACPI_Q_LNV('J', '7', true),       /* B5400 */
 	TPACPI_Q_LNV('J', 'I', true),       /* Thinkpad 11e */


