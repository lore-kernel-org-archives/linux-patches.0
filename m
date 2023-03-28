Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585E68BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03D1C433D2;
	Tue, 28 Mar 2023 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015703;
	bh=hJGxOy3tMjtDUMTcuAGCkYtKT1wPJLC0lJFhzzorNcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTWNZvEf/LwCOqnDnCOOnnQfYbpDtY828fZoYz6fLXakufpCyOOWMLFHi4eAtSyWW
	 89IQLFy6/koLS08k3XfHnI5JWgDdnNVIjaQh6yseArVV9bbnDyOpbIhIv4z8pX/rKP
	 +HQsnvjLc+ilHWlo5dPhoDfrGo28wlLHP3lDmCfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Sau <enrico.sau@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/224] net: usb: qmi_wwan: add Telit 0x1080 composition
Date: Tue, 28 Mar 2023 16:42:19 +0200
Message-Id: <20230328142623.347171993@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Enrico Sau <enrico.sau@gmail.com>

[ Upstream commit 382e363d5bed0cec5807b35761d14e55955eee63 ]

Add the following Telit FE990 composition:

0x1080: tty, adb, rmnet, tty, tty, tty, tty

Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
Link: https://lore.kernel.org/r/20230306120528.198842-1-enrico.sau@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 554d4e2a84a4e..2cc28af52ee25 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1363,6 +1363,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-- 
2.39.2



