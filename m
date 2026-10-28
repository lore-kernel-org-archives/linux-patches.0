Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210879;
	b=fPy6I3z1KhdMzRkKsGEAAXicg+7XHVmmjmtjUyG90ddLwt0N88XTaftuW5gPGOkcCpIQ
	 aQoXOT0hqtD6eRQf0RRru7E1eIP7JifSVa4tTTJX8b/0X6Z/RaTwcKDTI1cH5TFNNDGSG
	 XgtK3lI6XWDrpo1eNzNUopvfLJDND8m7GeDuJWpTIcNTM3IOiJnXPYZaaeMqSzYZ+mBHP
	 vDh8MZR+KGEtmRmOfo6GfaGEW88jWLU+h8+DNkbE0NHWHdt6CkY4yde1k78iAk57KIzV0
	 vaui4Z3Hr77BPrMLmJ+Q27QrAm0fK0XDfvHHT8kNZqx6+MPxByoQzV5iO+o8pMQTteQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6wYdO5VbYliCBmIsW0tXcpEH0sp874XVC7pPtF0HJEE=;
	b=TPq2meMJgrOycXN6HIcdvmVyVU4OakZQht2PKWX0SZtugFgg93bTRTMCEwCVt1AlkF4x
	 8Tp0eBZIwAAMzqTA85Vpo/MY30MQN90CRXuIDo1kgt+AcoBaTi1XepzxAHYByKO5dGsoe
	 +njPm43r8Idkobc4XQLqbgyKtbshC9pCF22WmD9UO8vZop4lt4prpVz1qoZAJZnG4bxDT
	 1Z539G0agRCGPoKlZ0umXKb1beCWeOSAdD3fmEMMGYBHUG05U+loXt9Ayc5C9cqEOo7Z2
	 F/veQzBywfoc45ovg/uSCfyVUEUS9Lrhvn242y885E09NifXcTQmD8eV2eoU1ZXdlfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwPHBCgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110D606A31C;
	Wed, 28 Oct 2026 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwPHBCgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15B51F01825;
	Wed, 28 Oct 2026 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210879;
	bh=6wYdO5VbYliCBmIsW0tXcpEH0sp874XVC7pPtF0HJEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwPHBCgVGbZOeeeR8lkMSXf3PO0GVWdxERjIuoaouYhUVUjQI2VY5SW052PUMZzU9
	 uC68Rn640uwu4ijew34vQ2kxiWzduHeo2H1+r/FWQT4btUthaM0qRKJvFFedK09wOP
	 TEBWNv+s2MtkX7zLvapUmsAoHdeCCdfzxzKJHgQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/571] HID: hid-alps: use default remove for hid device
Date: Wed, 28 Oct 2026 17:54:34 +0100
Message-ID: <20261028170011.032958047@linuxfoundation.org>
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
index 72c21014de845..8aed5e17e5819 100644
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



