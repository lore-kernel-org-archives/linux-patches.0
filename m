Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01ED20E005;
	Sun,  7 Sep 2025 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276908; cv=none; b=QSYlxJC+hQWLO6M9HpxRa4c1s+ragwEAcYfoTejdfnw0drkc+4aEuW7gsvNDLuwWKPTz3K/uZ8pbvD4UMof0dnaTZ6Qt0spRS2Z9KAj1N4b/oFuQs8iXrg0RAKB6VvQjGkHfkZEJ/MJacTRljyvT9qE3mt4JygrvcboCSCEGu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276908; c=relaxed/simple;
	bh=a5mCSy8GJNKZphH0qLTcb35IhPb7fmWvkM1MnJp+dQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn1jKKHAIPMPk6ADpHtjeqbxh8NqHanKJSvVUrL/l4Pj+A3nfL4/yS1QCFG3khSyaoITcWdtIqqGrq6IvWQ8W5S/N9ribjugVhtArcVbV1UTqcM8wK3uRRd/Yjy1yeWwAWlz6uzkOM3TbjFzK7g15dpncu150rxMuDBP1o3WXaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvWfvgC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvWfvgC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46973C4CEF0;
	Sun,  7 Sep 2025 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276908;
	bh=a5mCSy8GJNKZphH0qLTcb35IhPb7fmWvkM1MnJp+dQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvWfvgC8WlmFVHYjbQG9M0fwcyszU90bOcQnpU8kBWTlL5KRhw6Um7mR7mxIgw9NZ
	 na4amQlfR8WSfIUkz/98RRRdqroTUJjwYgrpXGoTvNfi9tESBf38zARG8yoLxn/Xwi
	 0re2/DtkvURGvO9exyoRKffFSzrWJGEhX12P+Kk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/175] net: usb: qmi_wwan: fix Telit Cinterion FN990A name
Date: Sun,  7 Sep 2025 21:57:01 +0200
Message-ID: <20250907195615.493884925@linuxfoundation.org>
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

[ Upstream commit ad1664fb699006f552dceeba331ef1e8874309a8 ]

The correct name for FN990 is FN990A so use it in order to avoid
confusion with FN990B.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Link: https://patch.msgid.link/20250205171649.618162-5-fabio.porcedda@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 61aaca8b89fb ("net: usb: qmi_wwan: add Telit Cinterion FN990A w/audio composition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 0a0f0e18762bb..8278fd8823112 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1363,7 +1363,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1057, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
-	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a0, 0)}, /* Telit FN920C04 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x10a4, 0)}, /* Telit FN920C04 */
-- 
2.50.1



