Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF113B47E5;
	Tue, 21 Jul 2026 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666303; cv=none; b=lWw1Me3HkF3+OcWn+zvE/oVNLtSFcSeSHObB2uJcRxA59JtZS9bjtQKI4ZdkBL6az9hCnP9WS3+OZBbnt5QTpNHuVEpBfFaZwsPqSQh8YQ3CJ3fSaIY5jVHRY9LoO0IXZdnmxErwpyPt8lEqAXrq33vT5IYhvGajfR8HXIh0sf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666303; c=relaxed/simple;
	bh=Yh/6SxbX6B8eP91rSOwovrvh2CenmDHuMi+TEoBJ3Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMGFMtyvC69lB7YslWZFzyGVaR216D5Kj+RhvSRhVDK+Z/XqQTVIthp82fp2l180WNzxi9d08jrpPAhipWfSOjD53/xUwy2jtEV5cqxuqcoZmh4ecx1FgO94T7hyDREwnGF2yOpnSr0buaPm9arNKDrYAEjYl8u736R0DrD1XVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKN7WyIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKN7WyIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFC71F00A3A;
	Tue, 21 Jul 2026 20:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666301;
	bh=YnP9ety5CTMyqWHWee8QXyfqxrFT+zgjHS2OKl8ZNbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKN7WyIQf+dHDE8iPPpWj7mU1dMzYhacKhwAMmrbYUSxLTA4ybWHalXiwWN4AnSOs
	 oUSBuJLrc/XzyQGieeL2/dfn4IQAYOiFmE1PXCz2/BxmHRtRtcqkpB1HsNFZsekBTU
	 xBpqFlbhxwTw8/qvQWMsxnuGW+VyHvdBYsrPQB1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0630/1266] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:17:47 +0200
Message-ID: <20260721152455.955884570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f22a5db8a7d38152556f230d6d68e59dbc27971b ]

The @dev member described in the kernel-doc does not exist in the
struct. Remove the stale entry.

Fixes: 0610430e3dea ("HID: logitech-hidpp: add input_device ptr to struct hidpp_device")
Assisted-by: opencode:big-pickle

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 113307157a27bd..eba52b95ad1bde 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -163,7 +163,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



