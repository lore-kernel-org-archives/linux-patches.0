Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB738837E;
	Fri, 24 Apr 2026 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037660; cv=none; b=JvxbPaeh6VPHf/yEs7culB50XCA2F+eo1iukB+8j9bMR/Pcoy7ugRBHeuYJGGW0B9wpIzeZE/yicXd6apknj/xOHh8GAwbj9hJyuZ3kvJXTsyMZgZBLss9koP9uHocTIVKz2ZGINIOAMY9QAVinEY0fxjwV6B5WJXQKivHXBbwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037660; c=relaxed/simple;
	bh=edIx9fYYziLPjZxtmhwkdNjQRB78CyeaJvAd2AIilcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imHwiBKz3jzt8JslH+crJ/oouS8Zq4tq+FnUtjOJaiQE/BUGX+gxs+Tt2/8KYIP/nokFltsVxcXi08Fl6hgAhUriSA0W1CYF+xJ9YFVkCMXBG4abopzxNWTmp6ZJCiWhukxBZ2QyIQSyeW3sxvuWHBNzbhhTpcWDRUwl/uvXNxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2LOHpfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2LOHpfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1311C19425;
	Fri, 24 Apr 2026 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037660;
	bh=edIx9fYYziLPjZxtmhwkdNjQRB78CyeaJvAd2AIilcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2LOHpfsBGLl2oAdJ5BzTH46a7Mn6B0wHj11djSE4v/NkDJOAnxEM241xEOfH3UzY
	 /afcwLlVh5+Aq7mKzIb5D0x9NE+XEGd/0TFjVZSvwtmXc9kt7nJTHoFboBWCfDVW9G
	 H1epPW7s12Buz2k0qMvGT59EzAgfZ+Iryxv3hi44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	leo vriska <leo@60228.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/166] HID: quirks: add HID_QUIRK_ALWAYS_POLL for 8BitDo Pro 3
Date: Fri, 24 Apr 2026 15:28:55 +0200
Message-ID: <20260424132537.244078824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: leo vriska <leo@60228.dev>

[ Upstream commit 532743944324a873bbaf8620fcabcd0e69e30c36 ]

According to a mailing list report [1], this controller's predecessor
has the same issue. However, it uses the xpad driver instead of HID, so
this quirk wouldn't apply.

[1]: https://lore.kernel.org/linux-input/unufo3$det$1@ciao.gmane.io/

Signed-off-by: leo vriska <leo@60228.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2057546b26823..2565a7425442a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -22,6 +22,9 @@
 #define USB_DEVICE_ID_3M2256		0x0502
 #define USB_DEVICE_ID_3M3266		0x0506
 
+#define USB_VENDOR_ID_8BITDO		0x2dc8
+#define USB_DEVICE_ID_8BITDO_PRO_3	0x6009
+
 #define USB_VENDOR_ID_A4TECH		0x09da
 #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
 #define USB_DEVICE_ID_A4TECH_X5_005D	0x000a
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 7a3e0675d9ba2..d9e33dde89899 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -25,6 +25,7 @@
  */
 
 static const struct hid_device_id hid_quirks[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_8BITDO, USB_DEVICE_ID_8BITDO_PRO_3), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_GAMEPAD), HID_QUIRK_BADPAD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR), HID_QUIRK_BADPAD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ADATA_XPG, USB_VENDOR_ID_ADATA_XPG_WL_GAMING_MOUSE), HID_QUIRK_ALWAYS_POLL },
-- 
2.53.0



