Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B28374EA;
	Mon, 10 Mar 2025 18:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630801; cv=none; b=B2WvgTRdaOIp0rwQlg70MzVpUHtjIl9jj761wIOMlS7bM77R1eJK+Zh9PeSS9QrmfAv/V42seJtzbo3Jl7TyqnjP0iQBx4+PMD1Y4KiMY+k9gNVuv3dwJB8jqKOmA8SrDpVg3Jlx0nL8xYeMbQ0xxJ3NrUlsm4mUVTOP0CsCYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630801; c=relaxed/simple;
	bh=jpdpz44es24qwxAO7fbqpejqdFzkjwpwPNEfliwDMm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4SCesvSReYaY1pUcN/br2WVcy59x6mmHfZDf+VrFQXuakh1LqsVB/VpbguH2l7d649TYiZniM7BwkKkszX1NKkW+hdE4cDUQIGg0kOaOUQ7CbCvJH/3WQvUO8bjbqzoWv93bPc1pnscqjtVk+AlML4uANB/D34bfl6uX5p4AXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onXPpVGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onXPpVGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E74C4CEE5;
	Mon, 10 Mar 2025 18:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630801;
	bh=jpdpz44es24qwxAO7fbqpejqdFzkjwpwPNEfliwDMm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onXPpVGuVag9RzjJm6LG8/ZaseWggHCA5hqoUpoGt98sos/pTk8q6yOyqfuF7pM10
	 oMCVZoj09RU4O2kO/xvBkpoe4WEYDdpPGJH1S4KJuLcSDYdsrWWLQ/B+KpZJTztwkR
	 T5Q0wABZRl2X26f2WAh5blNJ5BfHpuDG5YUDBBQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yang <804284660@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 540/620] platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
Date: Mon, 10 Mar 2025 18:06:26 +0100
Message-ID: <20250310170606.864066405@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9766,6 +9766,7 @@ static const struct tpacpi_quirk battery
 	 * Individual addressing is broken on models that expose the
 	 * primary battery as BAT1.
 	 */
+	TPACPI_Q_LNV('G', '8', true),       /* ThinkPad X131e */
 	TPACPI_Q_LNV('8', 'F', true),       /* Thinkpad X120e */
 	TPACPI_Q_LNV('J', '7', true),       /* B5400 */
 	TPACPI_Q_LNV('J', 'I', true),       /* Thinkpad 11e */


