Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223252C237E;
	Wed, 28 Jan 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614539; cv=none; b=OfNbghkNS6BvSjDv7cYa6qaFkOTeF+ciDPyquKWbJd3NSuspwKIGXjmvf/KzlQdt9JhhiwrLXGm3buMerww0IgzjZ5lVIkxIamQIfW6w+4RISo9fpHkdIy2OqfSRAM2aS9uizt9pRjR3PlvxupXEim2SCkCRDU6g411qS5hDEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614539; c=relaxed/simple;
	bh=mywVjv45IOp68QdK00Z6ptSw4HaOR6QijjbVmZpdK2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ9rRhKx+Nch4xn4iyqn5TU6btjEpdZOwIsDVvtSDxtLReTNwNJxRhxz8xv24MGMOPYlcJW4n1Y1bETxLginBUPPfZXyWE3yxjVD5fL9fY+49YPYUeRbZC5GIh7imfvIEFetDKpaBYwsAZjJaVPneOjNbQoJ/i95IEPbgDuXW6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbuwETpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbuwETpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F6CC4CEF1;
	Wed, 28 Jan 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614538;
	bh=mywVjv45IOp68QdK00Z6ptSw4HaOR6QijjbVmZpdK2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbuwETpX3F0ofcfMN0DJHkxd8fBXwLlzPfHVNQEY5WSawnJ6NM4TNTsSA2Td8r3Sm
	 HiFjxr9OISuEFTWQCBL7+cShlXp/85mIXMZnBW7DI8ttbIvmlHAUzqSWEiV3hCrGsd
	 BA0vU0ahlfh6jRPQ6YfJKqH1m4dYGb0y4rk1Hf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 140/254] Input: i8042 - add quirks for MECHREVO Wujie 15X Pro
Date: Wed, 28 Jan 2026 16:21:56 +0100
Message-ID: <20260128145349.854315803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gongqi <550230171hxy@gmail.com>

commit 19a5d9ba6208e9006a2a9d5962aea4d6e427d8ab upstream.

The MECHREVO Wujie 15X Pro requires several i8042 quirks to function
correctly. Specifically, NOMUX, RESET_ALWAYS, NOLOOP, and NOPNP are
needed to ensure the keyboard and touchpad work reliably.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-3-550230171hxy@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1176,6 +1176,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


