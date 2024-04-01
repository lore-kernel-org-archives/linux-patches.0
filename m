Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1ED47A6A;
	Mon,  1 Apr 2024 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988115; cv=none; b=BGInLAA64vCytpfA1fg8pvEoG1WFzZXkFDGoyu/rek3zrNk26G/K3wUy+Z3xZzWmGQK9/qnh2b8OGK+Gab+VVBD5LFBJ4oy+oIzOXTsM7sQJLv+X0kdyjS/TTwEQZ/z8ExSkgGjagpOe9BNuuBgimSMSRtzHhcomD+ZAIJoExHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988115; c=relaxed/simple;
	bh=xO7LL+7CVDxzIMZvB3FwUZ0peC7JSANtlvsRs8or1c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBFUs66BbrWDip041D+3ohPPXUbseov9bMoo21Xa69MA9g83WK2JkhuY3UXDMQ4315OE+mgrwLEaRCjRJnVO+foNFlQ9wtlSrmKOgGxCRdYqQ2FdlDwx4Sd79Bwe+qHzFO8OWENc8qtV/CGZz86/cKJqsub4vSsF0PzOZYKHKDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itoWY/Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itoWY/Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B1AC433F1;
	Mon,  1 Apr 2024 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988115;
	bh=xO7LL+7CVDxzIMZvB3FwUZ0peC7JSANtlvsRs8or1c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itoWY/OcyE8t6HAA3bJknbHSY9OpTJyvquXhVdPiEhlNzg6DiXKi68iOitLJfJU00
	 G4wF3UUBpFXeVXJzaW1llSmHNaFfjMHoNHFtQIvBXTHZwNft6AvzxVXgwa1Y8/WMWn
	 FuCr9DQEUXZAFjim2xFdgKldwImOcGpmQOAt0/Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Prashant Malani <pmalani@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jameson Thies <jthies@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 089/432] usb: typec: ucsi: Clean up UCSI_CABLE_PROP macros
Date: Mon,  1 Apr 2024 17:41:16 +0200
Message-ID: <20240401152555.779898642@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jameson Thies <jthies@google.com>

[ Upstream commit 4d0a5a9915793377c0fe1a8d78de6bcd92cea963 ]

Clean up UCSI_CABLE_PROP macros by fixing a bitmask shifting error for
plug type and updating the modal support macro for consistent naming.

Fixes: 3cf657f07918 ("usb: typec: ucsi: Remove all bit-fields")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jameson Thies <jthies@google.com>
Link: https://lore.kernel.org/r/20240305025804.1290919-2-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 474315a72c770..13ec976b1c747 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -221,12 +221,12 @@ struct ucsi_cable_property {
 #define UCSI_CABLE_PROP_FLAG_VBUS_IN_CABLE	BIT(0)
 #define UCSI_CABLE_PROP_FLAG_ACTIVE_CABLE	BIT(1)
 #define UCSI_CABLE_PROP_FLAG_DIRECTIONALITY	BIT(2)
-#define UCSI_CABLE_PROP_FLAG_PLUG_TYPE(_f_)	((_f_) & GENMASK(3, 0))
+#define UCSI_CABLE_PROP_FLAG_PLUG_TYPE(_f_)	(((_f_) & GENMASK(4, 3)) >> 3)
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_A	0
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_B	1
 #define   UCSI_CABLE_PROPERTY_PLUG_TYPE_C	2
 #define   UCSI_CABLE_PROPERTY_PLUG_OTHER	3
-#define UCSI_CABLE_PROP_MODE_SUPPORT		BIT(5)
+#define UCSI_CABLE_PROP_FLAG_MODE_SUPPORT	BIT(5)
 	u8 latency;
 } __packed;
 
-- 
2.43.0



