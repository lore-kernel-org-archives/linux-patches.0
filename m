Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12F71B6D08;
	Mon, 29 Dec 2025 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025639; cv=none; b=n85Gsxi8jGo+8f0GvaNq78ed5htzjx6we1C43t2EkGjRzAwKlHYZRi0FVJQQsoYx0jFA1mc/DEksNu1P0onVbXN8k+vrKkMGQr4GqRY2j0AyWACpDhsWl4+fRSj/a2VVIzNK7+54aVZ0u36BMbR7rhj0GNumd78L6SGrSpW4wa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025639; c=relaxed/simple;
	bh=SvmcRK0lcy5WJ3PsCuLjhfrIPIHQRm52CCgsHBnKCcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abY8XAyyiLGinUk4YprQWmJWwH/ngzxEiig6okLY09MZIY2KwJ5ANyv1yFqq2sgdE7csnq7UMffnBbBP3koTALiWuWQnWRDD8SB+yhjQmmqp/ntM8zIFtZMN/nrMklJ474IxupT+l+tRn5ONPo/r1dNdG9bR9HL/LMUyDWVI5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfAY3Y6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfAY3Y6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38042C4CEF7;
	Mon, 29 Dec 2025 16:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025639;
	bh=SvmcRK0lcy5WJ3PsCuLjhfrIPIHQRm52CCgsHBnKCcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfAY3Y6EIzm03Z60WzdEqvorceFDsyRjSKJHtZgdPVnaOjwUJXN74Ihtx5UZL1dYS
	 +t07ovh9xDufY403X+OjxY1c7VoOl6i/UI0IYBiNhGR/6Yagxic94uWFlityfZS76f
	 xQOoB6Tbc0nlWRxHTHacX1KzCg0zbLkGIFygkiR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 285/430] usb: typec: ucsi: huawei-gaokin: add DRM dependency
Date: Mon, 29 Dec 2025 17:11:27 +0100
Message-ID: <20251229160734.835163388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit d14cd998e67ba8f1cca52a260a1ce1a60954fd8b upstream.

Selecting DRM_AUX_HPD_BRIDGE is not possible from a built-in driver when
CONFIG_DRM=m:

WARNING: unmet direct dependencies detected for DRM_AUX_HPD_BRIDGE
  Depends on [m]: HAS_IOMEM [=y] && DRM [=m] && DRM_BRIDGE [=y] && OF [=y]
  Selected by [y]:
  - UCSI_HUAWEI_GAOKUN [=y] && USB_SUPPORT [=y] && TYPEC [=y] && TYPEC_UCSI [=y] && EC_HUAWEI_GAOKUN [=y] && DRM_BRIDGE [=y] && OF [=y]

Add the same dependency we have in similar drivers to work around this.

Fixes: 00327d7f2c8c ("usb: typec: ucsi: add Huawei Matebook E Go ucsi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20251204101111.1035975-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/Kconfig
+++ b/drivers/usb/typec/ucsi/Kconfig
@@ -96,6 +96,7 @@ config UCSI_LENOVO_YOGA_C630
 config UCSI_HUAWEI_GAOKUN
 	tristate "UCSI Interface Driver for Huawei Matebook E Go"
 	depends on EC_HUAWEI_GAOKUN
+	depends on DRM || !DRM
 	select DRM_AUX_HPD_BRIDGE if DRM_BRIDGE && OF
 	help
 	  This driver enables UCSI support on the Huawei Matebook E Go tablet,


