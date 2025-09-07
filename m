Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB306212B2F;
	Sun,  7 Sep 2025 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276912; cv=none; b=CDjJ5nfH4capKBvXy2kLqWoTVE83YU5R1snpjBeL6aTxi2+kNvjclnPyXgkVN+87r76Vz0uBDSot7smqRomYYox6YzEBO+yIfz2/hn3G4kUM5PjKbDHcmBAhxpeuXjmj4JALYuwOhJcTRYbUxSBwT24C8YOeN4JsnuxSFE3BRXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276912; c=relaxed/simple;
	bh=Gxrr0ePIrjYHCv/+8copNZd1ZSNl0scjXJ9ZJN0qDPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv3thlP+NHTyW/Re/Whm6JLomoi9M76w47eMtTASuI+cL7WUl/+tsSaXrGuKsBd0W7J6O7GEqdGhhAmqHlrOmI0zo4wPkcXmOvAO+QYDLEz3tj6a0RKXIZI3Ntd6rjI4eJ6lOYaWrEHhsXLAjbC3DavBkM2fA03HV2YdGG3ovx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHYZB3wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHYZB3wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63711C4CEF0;
	Sun,  7 Sep 2025 20:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276911;
	bh=Gxrr0ePIrjYHCv/+8copNZd1ZSNl0scjXJ9ZJN0qDPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHYZB3wn1N4br0OhMel9HRxUEqisqxlid1YcvSMsUJfT2hh+xWxUKEwrBcqPr6UYJ
	 5u6GAsLV3zjefF7x5k6Djzzh5Iv7Gb4uG9faQsk5J+DWdRdI6UPkI3H6vHVcvhb6YV
	 lRu74Bg2xhF+qqDH1xBq2m/9TokvzZRckGik+Rzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/175] net: usb: qmi_wwan: fix Telit Cinterion FE990A name
Date: Sun,  7 Sep 2025 21:57:02 +0200
Message-ID: <20250907195615.515673071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

[ Upstream commit 5728b289abbb4e1faf7b5eb264624f08442861f4 ]

The correct name for FE990 is FE990A so use it in order to avoid
confusion with FE990B.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Link: https://patch.msgid.link/20250227112441.3653819-3-fabio.porcedda@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 61aaca8b89fb ("net: usb: qmi_wwan: add Telit Cinterion FN990A w/audio composition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 8278fd8823112..efab1127e0187 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1364,7 +1364,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990A */
-	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a0, 0)}, /* Telit FN920C04 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a4, 0)}, /* Telit FN920C04 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a9, 0)}, /* Telit FN920C04 */
-- 
2.50.1



