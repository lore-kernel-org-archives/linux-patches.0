Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35D81C07C4;
	Tue, 15 Oct 2024 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996992; cv=none; b=nwamcx4yfTKvzO9s0Yzx38xx67MwyB3+y8l7d4NTlU4B6meCN0ita8p6qheWyimZuDooxyWKmwFySOhQRKcP7CAU49a6LYE0edKmUu5egIjP9BTSLtsq5ZiXc04UtLHuKuFoDfVhCimLcCYzwDXEAddy2TWnbX1XEbErqyJIB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996992; c=relaxed/simple;
	bh=PTFWhfTkyfIU4j8KJClI0+/wELSjwsLf/gv+TIiOwx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEMjBJkZLixlnq1vi//L4wiIhhyxHg/pRwOUMbHthXRWNJgKfLpb2JT5udEdFbIvrzroo4Hfuost575ugVnY9Ymx2NCD5n3dr2J6OTw3jrpwofD1J4YQVQwhoxAEme/Tt51xJe6MaAJXQcmb4o4oj/A5GGYIV9m2QRP6LqMxnxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBs3t1ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBs3t1ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E71C4CEC6;
	Tue, 15 Oct 2024 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996992;
	bh=PTFWhfTkyfIU4j8KJClI0+/wELSjwsLf/gv+TIiOwx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBs3t1ur62emhfyLdKSpt3jj1UH4X9+ohTrwA+f4HASM9LMqU2ur1M6DoUYs1SNqB
	 AdAzt92A+GItvK04G5GO98+eX3fzdmhn69UmY6y8M2eTQDzEnM6XvRJiKoWGF2NorO
	 2x6RnUqo803BXUwmb4F1XdQwVYptAtehvlt4hnJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 057/518] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Tue, 15 Oct 2024 14:39:21 +0200
Message-ID: <20241015123919.211365627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao Xie <bigfoot@classfun.cn>

commit 7d47d22444bb7dc1b6d768904a22070ef35e1fc0 upstream.

Add the device id for the Macrosilicon MS3020 which is a
PL2303HXN based device.

Signed-off-by: Junhao Xie <bigfoot@classfun.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -118,6 +118,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
+	{ USB_DEVICE(MACROSILICON_VENDOR_ID, MACROSILICON_MS3020_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -171,3 +171,7 @@
 /* Allied Telesis VT-Kit3 */
 #define AT_VENDOR_ID		0x0caa
 #define AT_VTKIT3_PRODUCT_ID	0x3001
+
+/* Macrosilicon MS3020 */
+#define MACROSILICON_VENDOR_ID		0x345f
+#define MACROSILICON_MS3020_PRODUCT_ID	0x3020


