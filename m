Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208480;
	b=YPKXqAowzheXCiesEBaPHcl1L1JhwaA9l3Gr1SzGavBbrcYFtsFqmFoOlRCpbZCUD4Hv
	 6saw/CNVhMlBLEyQkRkgw+QCT245Uj0dtEgudnjYHTM9LZhDBPw495gdFinPdG52Bucjk
	 xt2PWjBts4ej2qm0nMaxNJ1mJ2W+Fv/maLSDeDznUx13fmtAMjp4WWASw/J34RlPsBqf6
	 LQ/VEeKSL3sk+PnxNfbx4ffPQHs0IKvT9/ryv0Yw6SCxwOxovRa4bRk7n1Fav1YMcsW+N
	 zNoZu1kFR9M9w8IWrfzkhTLxcGq3KCfTiZ7+ru2cvFTiFSjAYgND19KcUuNbxyYojvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K84J1bvGj4xJDEc9Z4qQu5Ol57qG+rPXqMT7qROWcnw=;
	b=IIhCs68KLVMnfNGS/j5maYN48CqmDVbCpbBo6meig1AkMdWQ1UGO496Yz9W9gBSvE8Ng
	 0xcLSWIQljREHQsPCtVsVOT6ZWmNNb2E7SDfSwzeJ3au8b8sLvuR3+vHir/jzPUHxC8GL
	 +9XJKxC1N8OcgD8uQVHRNcT2LoC0h4oICjZmkFpoR1QsxdrDi7UOyWXooEnBSbwY917+u
	 nNPGyhGjfxfWbyoVnq6XWesWv08iUamZSRGZcdLOjZDiZXJ4VWdJgy4EcQ/sSTFhqu8BA
	 /TTqW2NeCXiO5VoGeOVahZwOib7uqnhCt1MRJjGbJ00ImAYVNRNMYi12zYjaCCr0vdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooKlZuWJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790E606A31A;
	Wed, 28 Oct 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooKlZuWJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454E81F01825;
	Wed, 28 Oct 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208479;
	bh=K84J1bvGj4xJDEc9Z4qQu5Ol57qG+rPXqMT7qROWcnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooKlZuWJg3DQJsJDFQuG5x2lvA22Gims90UvZhDnUuTfWV5u3lhijHwZCyVuR83S0
	 ole5uatlvYzwVouLhTCWdgwNFi1x5BG+Y2otij0eokr9HcpBqkDQns3DnsMyBcc1Zl
	 05VyN4BNuCjRMZ4WjDbiClu2l6SrhnBDHOfvHw4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/516] HID: alps: unregister DualPoint Stick input device on remove
Date: Wed, 28 Oct 2026 17:54:45 +0100
Message-ID: <20261028170006.662344680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 754e30f455014..ba16522fd6e25 100644
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



