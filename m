Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363B113B7A3;
	Thu, 30 Jan 2025 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247464; cv=none; b=UfnIzN8WcPgHA/N6CbpNfki5lFjhYO8YiWbS1iOBRZkRp0nHRmi/xiBCuSrZix4N0gVETtITXESEcM/QqRyCO+PZELmumXEf9ri/UnkgfpbY5fxhb6T4v5MM5JsNeLTq1c9zla/YnAIghP6SruFuSffHCfGHzB9NDEyfBsOGcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247464; c=relaxed/simple;
	bh=hDd7QE9me9OvSKy6uZwZphKZ3+W0eeIS2LUQZLyNJHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Db9v35e3An3YBKH+F4MqDbmsYvmyF8m8iKxV8vnS3Mjc1oEdyxjjFJrsTeWXRyVn0arD9803cvqObZA+KwSKdJpZCYse3T3whgGXw5PAowTptMhyt4alpkg3croCmSS+lNKkbnprAk7+sJPJ0/3xMWyH9qx5m9rztlpLxaUtQ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nad5/gLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nad5/gLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CE7C4CED2;
	Thu, 30 Jan 2025 14:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247463;
	bh=hDd7QE9me9OvSKy6uZwZphKZ3+W0eeIS2LUQZLyNJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nad5/gLDr5GW99qFgQhVBNJsJKL00eTwylaEeFTmu95des7fNf2GpfvMLp3R2et10
	 5N706LZaq3HVL55HJ9QRLhxYq/tDl5YlggAAOfW0HA90QFs6ztp/aANGFClxFMebfi
	 8YJB5M8+cORAZWxYnBat4+QZZOuW1mOtDAlVSKZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Greiner <jack@emoss.org>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 47/49] Input: xpad - add support for wooting two he (arm)
Date: Thu, 30 Jan 2025 15:02:23 +0100
Message-ID: <20250130140135.713881416@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Greiner <jack@emoss.org>

commit 222f3390c15c4452a9f7e26f5b7d9138e75d00d5 upstream.

Add Wooting Two HE (ARM) to the list of supported devices.

Signed-off-by: Jack Greiner <jack@emoss.org>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-3-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -367,6 +367,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },


