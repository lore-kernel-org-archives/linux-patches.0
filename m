Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212467;
	b=O7qbQ2vdhiYYquE7hXhCRSBz4S3mUXTkCnmdE6ROCkZ1B5ffFcdEh2FAckcD+kOHvWR/
	 h69mOpfenbtL8Mk6yz7C1lC9z/VFcEtoCxar2KC96iVsn/8coOF/WiEpG6gonfHs2buqx
	 QwwCqp1XNodVXrHhvEQrw9dULY1f3tjOcassNE8nAVZeuD5VjoOI6thUmEhrQ+U6PIwuO
	 qC+ayE3/aha0ziX/gzYrrxohjWjjzz9+yByKXWHzYvV3H/aWW34oFqIJXZ0VfanzXwHje
	 U6VL60kJdIYszHmL2FIdHAcplX6pTNB/Lmh1lKmwoB0n6awzcL5oZCGwfj5mphrnsDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DT7ZcX5uMDbmckTyfNcT7iqtr3DVEK8FfZ3PVxxfLco=;
	b=OQ1KnJS/V1f3HOHnV1uJjxguQz0On945MWVOSr9BmlUTlAzFPLXOZJgeToG2H0vyPYz2
	 S58F0j3kepKvUcsBS0afRRqRH6gxSsK3CUggbp9nZwPfjbUBJKaA0rXxu4ev9uOfYUwBX
	 07JFSknUqhysZ/0F4N3laxGaP/uHI8VUkae7mll09dUhUHKnQ/vRt2Gz5Ae9AZcBNXLrk
	 Mg+xz132120WpWFXRwSUwot2QBt0V2PlZxF+iAt4ylYP807cqqwfr6XL22XeK1C9mLlYb
	 X5s47Mn5E2IvbWNblyL+zL5GPKNHI1QMD3uS6N1i/l1nexsGvlBh8nZIj6zYcfSKqng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sfIkJ/dz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB8C606A31A;
	Wed, 28 Oct 2026 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sfIkJ/dz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84581F01825;
	Wed, 28 Oct 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212467;
	bh=DT7ZcX5uMDbmckTyfNcT7iqtr3DVEK8FfZ3PVxxfLco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfIkJ/dzP6Gj3OS6cFnaWRDRGOTJij0AZhBJprtpRaqGWHisbrh49ud/k4u6lRw21
	 EJzMEdDwhmQj08ruL9tTlnVO3Dap8+IWVQpTiCPR54pJEn66sBO0Mu1OE92DysZFo3
	 FTHHikp1shU966/ikEA6TJMRV6cvkOBWHuQfyw8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0165/1887] HID: alps: unregister DualPoint Stick input device on remove
Date: Wed, 28 Oct 2026 17:37:41 +0100
Message-ID: <20261028170502.989138919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



