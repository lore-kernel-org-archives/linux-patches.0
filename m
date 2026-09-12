Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A434752E;
	Sat, 12 Sep 2026 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210676; cv=none; b=dutSdvYE/POh77EmGInaiaGqRjujakiOj76WKDELuaXGqc6BW8AJQ/C9E9RLTfNUEw2bYdklqeBVg9C1I+NFI2hfc/0s9FlqNDrqXIfRTMs9KT6sQs3VCS0oDFFZju443aSQO5ZdN6dZ8S495dR9liL8Li4JSAFnNN15jH3ne2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210676; c=relaxed/simple;
	bh=zXy8LxbsjWXmFdsB7N6ZJOMAxON1/5mWJcWKKpvxsWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAqqnfUsVbG8lpGEmmELf1s7lJhZG6sUIJ1r/rDZPoUDmr2MR7ULhLqdXmmuK3Q0iCtMTq3IQ97ciiNxr0ePVt6dkpd0kRG590zzQqLdzJ8OioKCDM92iLG0K/U1VwO6djk0AfyWfi3W9/WHTXaBmdZholsTeORntStkJANWjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCa2Ix/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCa2Ix/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827DD1F000FF;
	Sat, 12 Sep 2026 10:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210675;
	bh=QQnUOLOZ8LcABkP/hZrWbigy3M2BkK2W0XNMoCihy2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCa2Ix/jIsPKXvqxkPSWMln3fdDLY/8da6tTElOIsdJvCaPOocmti4Cj3o7TdX2yg
	 bBVxkZNSgO2CLW7j9Iw6x4eudH8kZ6Ep8/WgrqUW6ZiCNEhAp7G4pUU/TQJxVtCYdD
	 gtwrlYF1b5ouNW8ny3TTi/bRR6ArSzrDOd99aSyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1075/1518] hwmon: (cros_ec) Split up supported features in the documentation
Date: Sat, 12 Sep 2026 08:54:04 +0200
Message-ID: <20260912065647.766853439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 18ccf48656e010838075fd00caa6d93d3f95d106 ]

The wall of text of supported features is hard to read and messy to
extend. Split it into a definition list with an explanations for each
supported feature.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260118-cros_ec-hwmon-pwm-v2-1-77eb1709b031@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 26db27364088 ("hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/cros_ec_hwmon.rst | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/cros_ec_hwmon.rst b/Documentation/hwmon/cros_ec_hwmon.rst
index 6db812708325f..b7dc88d22fdae 100644
--- a/Documentation/hwmon/cros_ec_hwmon.rst
+++ b/Documentation/hwmon/cros_ec_hwmon.rst
@@ -23,9 +23,20 @@ ChromeOS embedded controller used in Chromebooks and other devices.
 
 The channel labels exposed via hwmon are retrieved from the EC itself.
 
-Fan and temperature readings are supported. PWM fan control is also supported if
-the EC also supports setting fan PWM values and fan mode. Note that EC will
-switch fan control mode back to auto when suspended. This driver will restore
-the fan state to what they were before suspended when resumed.
-If a fan is controllable, this driver will register that fan as a cooling device
-in the thermal framework as well.
+Supported features
+------------------
+
+Fan readings
+    Always supported.
+
+Temperature readings
+    Always supported.
+
+PWM fan control
+    If the EC also supports setting fan PWM values and fan mode.
+
+    Note that EC will switch fan control mode back to auto when suspended.
+    This driver will restore the fan state to what they were before suspended when resumed.
+
+    If a fan is controllable, this driver will register that fan as a cooling device
+    in the thermal framework as well.
-- 
2.53.0



