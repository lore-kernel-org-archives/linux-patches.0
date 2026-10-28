Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210780;
	b=t4F8re9cBaI5H8QQb7HdjWbYVTWRcoWcR+JF0iXiL7VKAuF76UKQ0dZgy4hwyTgPaf25
	 7oNMgTuOn/TE6OFrF5F3neCzkNtdBWv7c9bFbzH2/vxgdGUKeOR/9Viww2Ht4QOp6kmhT
	 EncDCi0ALlf2lIqB1laDvDC8r2avHaW9ZNnC52dAjlDLIcSt7hR8eAJ95kLRZFKCGQ0j7
	 4VVpaywFXRv1/k0VWQrpJd5nZ6BHyxpdQbanzRKf+nD+7MApyAzcqqdMfqSVPZ5V4ZhHb
	 a5tJRh/xv/6/6fZeL2LgF31XYAKbIkvEcqo+I6fQI2T43sfPGM0T/KlfEAJUKONHeWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sovBnqw+tEwkt+DMueIb7JJ4J6w36EeNrI65tIP0dk=;
	b=3Qj/hU3XT0hqFk8n3KTk3TMxAYbxxmUB6RYRySi0Ebm6/wJiioKlgUcFV44B+vuT8imS
	 1ir7UJxoMIfsA4tKYRxH8nN3SwQmjdsTkRkCZSxYNT5GvQx2Z3XEwz07vKgTUvOaYlfbk
	 dwLaNpFG3WbEF7QY9HmRBsGWk2PQecKIOWYAGf5z/1/+qgniZrA0KMx+acDe/LBSx9B9P
	 Z1cPDW1T3uEkRwOY67yaLHeh8KFa3Bnpu/xQeQSnZjnRAeoWorrcS5SLYO29WQLN/TbmA
	 ujAXEVfKHkoGeZA4m7+5HXq2ZL9yZhRBKktPrwxvGpxRKL81mHnBsVXGKFKG2mZVW2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sn2M928m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D809606A321;
	Wed, 28 Oct 2026 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sn2M928m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02D81F01828;
	Wed, 28 Oct 2026 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210780;
	bh=7sovBnqw+tEwkt+DMueIb7JJ4J6w36EeNrI65tIP0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sn2M928mSuJ42l0IgH36H+K0YwOkQX8GS/79CEzBBYD3wc48ZY5gU7FDHyGMUkhrw
	 VXnenMQHTjzMq4LpRWqNT7dA6j/VfZlE4p087NXoJZd9FB+rew+f4kFGwYpGEU4VL1
	 ivtlmUstaEmMgUMLS6xFIyhDNApd+ggpoRQNEUws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/571] HID: alps: unregister DualPoint Stick input device on remove
Date: Wed, 28 Oct 2026 17:54:36 +0100
Message-ID: <20261028170011.079898148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit aa9dde93e05a837645fdfd577eea71f0733f0694 ]

alps_input_configured() allocates a second input device ("DualPoint
Stick") with input_allocate_device() and registers it, but the
alps_driver struct has no .remove handler and input2 is not tracked in
hdev->inputs.  The default remove path (hid_hw_stop -> hidinput_disconnect)
only iterates hdev->inputs, so input2 is never unregistered and leaks
on every device removal.

Add a .remove handler that stops the device first (preventing URB
callbacks from touching input2 during teardown) and then unregisters
input2.

Fixes: 2562756dde55 ("HID: add Alps I2C HID Touchpad-Stick support")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 35df84426196c..25da180175007 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -825,6 +825,24 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return 0;
 }
 
+static void alps_remove(struct hid_device *hdev)
+{
+	struct alps_dev *data = hid_get_drvdata(hdev);
+
+	/*
+	 * input2 ("DualPoint Stick") is allocated separately and is not
+	 * tracked in hdev->inputs, so the default remove path
+	 * (hid_hw_stop -> hidinput_disconnect) does not unregister it.
+	 *
+	 * Stop the device first so that no URB callback can touch input2
+	 * while it is being unregistered, then drop it explicitly.
+	 */
+	hid_hw_stop(hdev);
+
+	if (data->input2)
+		input_unregister_device(data->input2);
+}
+
 static const struct hid_device_id alps_id[] = {
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_DUAL) },
@@ -847,6 +865,7 @@ static struct hid_driver alps_driver = {
 	.input_configured	= alps_input_configured,
 	.resume			= pm_ptr(alps_post_resume),
 	.reset_resume		= pm_ptr(alps_post_reset),
+	.remove			= alps_remove,
 };
 
 module_hid_driver(alps_driver);
-- 
2.53.0



