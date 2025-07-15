Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ADF2E973B;
	Tue, 15 Jul 2025 13:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587898; cv=none; b=Xy49FYOR/2Lrfn2w6ec/5iHCvuJGDB37u7JIvmDG4ThVG+xfvr/WyxVC8L0ngj9oMbAtmAZXiaLflo16eOV10zRqaPv3ypMqnpWi6IA+YP0gVhGQgWFcBIXEqztdvuK3hy5SKfnCRkjlbbLM9TtOdfQimmZJnZAXLGOyq18nik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587898; c=relaxed/simple;
	bh=OvDTiN3voCXujY/1+Sie3+ii/YXcBfy5ZXgxzpXob/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llye1OiE5/u1McfQN13D0McQKciWkcYzQRL9T7PcoVCD3Fk3aC31gUZ1BVG7QtANvHA4eVmzap7GRyIs8G8mwSN88pJFVfCIEMiAPdmN8SSyYg3vzhwQrHRPQdBXZRmHMDNwUFjmH+4WqwYAmvDnl1YuW9XBzY2dAXNqsospo4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BmI+6Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BmI+6Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B45C4CEE3;
	Tue, 15 Jul 2025 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587898;
	bh=OvDTiN3voCXujY/1+Sie3+ii/YXcBfy5ZXgxzpXob/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BmI+6IldDKpfa2fhutpKi/YlOeTQbgRNaDiNXPQmkWQVzpGoQmLYasKP19CmjpAq
	 DFe7u5u4FQADQa5j0xKSoZdkmWKKKTXUW9a6Rrs8vZQE+5LyKeU3MoTABKtqVZ7HbJ
	 o/RqwIDW2URawnagsO7OrbX3SOIooPwR/diGARow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/208] Input: xpad - add VID for Turtle Beach controllers
Date: Tue, 15 Jul 2025 15:14:53 +0200
Message-ID: <20250715130818.325824178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 1999a6b12a3b5c8953fc9ec74863ebc75a1b851d ]

This adds support for the Turtle Beach REACT-R and Recon Xbox controllers

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20230225012147.276489-4-vi@endrift.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index fb714004641b7..21a4bf8b1f58e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -452,6 +452,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
 	XPAD_XBOXONE_VENDOR(0x0f0d),		/* Hori Controllers */
 	XPAD_XBOX360_VENDOR(0x1038),		/* SteelSeries Controllers */
+	XPAD_XBOXONE_VENDOR(0x10f5),		/* Turtle Beach Controllers */
 	XPAD_XBOX360_VENDOR(0x11c9),		/* Nacon GC100XF */
 	XPAD_XBOX360_VENDOR(0x11ff),		/* PXN V900 */
 	XPAD_XBOX360_VENDOR(0x1209),		/* Ardwiino Controllers */
-- 
2.39.5



