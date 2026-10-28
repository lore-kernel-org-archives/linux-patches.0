Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208474;
	b=SCbnyH0xde0vKE+xT6XfNqQ4cjymMRBO4prBL28Nhu/WIvUxq3YcNiiokSszhw4nbTnS
	 LtlWOua+lTzbTUQm+OT6Rg9ZA7FTbuPFZRXoXcTe+notHyVDtzx8+1dqeQSD06VFM+0rL
	 hn8yZDP3GJngjZJKVJG+57UYW23/Myd+8uJI1iVdMK0bqRHqqNRx9mK1cu1/FNty0pz4h
	 S+DeyGqOoXwqomYhcz6QjUXu79DYB6DCz4Sw3kIfq5NsysCaJUzwKh33B7WH4VVyrEATe
	 OZ87jO3/QgTGU0PyJTgM+/g1Mi93mI8hKPqwy8HuWtMH3WDUiWazm4gdyHF5/ZWoUKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8RKdSsZy6QOvztXClhW7+ygTwhSS4j35ZXg87/M7A/k=;
	b=oDvWImR4ja0QqQ7ynb8fb7clJ8rRR46I46UWVvKJNXaAmEtxd1qJdE0MK2zNqerVlLYO
	 FRqTVVLfcKHp+yE8XMHXxr1t5q291nmm4PKh6lsm+FaGjkqL0FfOeTqy+Z3g7oN3N7AiU
	 8qIok9hUjZSecRA9FyHA0vtT9fkp7+bpy4cpd98wOFZIQhtM58O189UjaVbKQttV1tNLe
	 /QxxG2rajfgL5PjeHeOeS7UXiTJi09xh4UEJY50p0yRGNkqcNU7n3tg0CfoYiVCFwC8cF
	 qm5I3Vp85OIJvffGlfrGIUHZu6mwmQwAhCcTpNq/KSBEHG1yGd1k4wLxWEfo15qoKww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yT0Xg29l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D9A606A31A;
	Wed, 28 Oct 2026 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yT0Xg29l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944201F031E0;
	Wed, 28 Oct 2026 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208474;
	bh=8RKdSsZy6QOvztXClhW7+ygTwhSS4j35ZXg87/M7A/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yT0Xg29laE7c3s7MKvFTSFnD8dqSngqXEghupYfQYfpCWOee3E3IW89bLCWBUSwfw
	 ZMWbU7udkC16vwb0x8SmoHnHPh2tn3SwIjw0McJ7dWaGFys9etXUQiNH+nmGwAdDd7
	 L2RduQwurW8goVyokeanr2DeWZeawBIyHNZtmlj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/516] HID: hid-alps: use default remove for hid device
Date: Wed, 28 Oct 2026 17:54:43 +0100
Message-ID: <20261028170006.615163237@linuxfoundation.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 989f7cc94f1174269282a4a46bb735c7f11527de ]

hid_device_remove() will call hid_hw_stop() as default .remove function
if no function is specified.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 69b9559894f1a..226b504d6c701 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -825,11 +825,6 @@ static int alps_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return 0;
 }
 
-static void alps_remove(struct hid_device *hdev)
-{
-	hid_hw_stop(hdev);
-}
-
 static const struct hid_device_id alps_id[] = {
 	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_ANY,
 		USB_VENDOR_ID_ALPS_JP, HID_DEVICE_ID_ALPS_U1_DUAL) },
@@ -847,7 +842,6 @@ static struct hid_driver alps_driver = {
 	.name = "hid-alps",
 	.id_table		= alps_id,
 	.probe			= alps_probe,
-	.remove			= alps_remove,
 	.raw_event		= alps_raw_event,
 	.input_mapping		= alps_input_mapping,
 	.input_configured	= alps_input_configured,
-- 
2.53.0



