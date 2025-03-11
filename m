Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B931CAA8F;
	Tue, 11 Mar 2025 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707451; cv=none; b=rzu8WV9eQbJKSqtpMXtHY4CSpuh/UBxG2VMyI/IRfxwwjBZkgtZymLUTQ4nysOXZxh4lNpcD0jNeE7n40VvjXPzg1Xy7nf19Bi3ozKIJ8QmJpNUj/iS5VhpBrVx+vC7PIRIvIFMMeibNzwZoXPVgCxUx5oOIlto2c3KXMH7+BHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707451; c=relaxed/simple;
	bh=WFz7Eikx0XGqzns1Pu4lWCwH/uf8xEvu1hK6W4ErnRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiPTxOiTBUE+i3TTq8QtXLZVIsKmIxVkAIlAkXbs3XCekaXAEvZjT6ckfI4UhZZhUuyclHwkKh5KhZ4yZfqJ5Xh0QJWkGJiYx8iDWOAqmECwQIl6Dmkd6ODa7rA2gQ8u0UnaWv7U8P36yHCbO9dm5JfG53Iq5oKys1AY1ufSnTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB0RNU6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB0RNU6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48127C4CEE9;
	Tue, 11 Mar 2025 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707451;
	bh=WFz7Eikx0XGqzns1Pu4lWCwH/uf8xEvu1hK6W4ErnRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB0RNU6F+9ker5GNgBgcxONtqU8u5dEAnDlieSprF0aokWQTIiojbvIrDH8iqsZEt
	 8VEnW3PHYCX4h/zWs0G2cY1xMSQhgLDVkXKwPO9DjGmj2nfFw1FQPa0WTQbhQrz2R3
	 ZjWg7YRbuB2qPflr/wPsYqOGamgoO1MHcVsWUUuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yang <804284660@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mingcong Bai <jeffbai@aosc.io>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 394/462] platform/x86: thinkpad_acpi: Add battery quirk for ThinkPad X131e
Date: Tue, 11 Mar 2025 16:01:00 +0100
Message-ID: <20250311145813.902166519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9718,6 +9718,7 @@ static const struct tpacpi_quirk battery
 	 * Individual addressing is broken on models that expose the
 	 * primary battery as BAT1.
 	 */
+	TPACPI_Q_LNV('G', '8', true),       /* ThinkPad X131e */
 	TPACPI_Q_LNV('8', 'F', true),       /* Thinkpad X120e */
 	TPACPI_Q_LNV('J', '7', true),       /* B5400 */
 	TPACPI_Q_LNV('J', 'I', true),       /* Thinkpad 11e */


