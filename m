Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9DA18732A;
	Mon, 12 Aug 2024 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478951; cv=none; b=U02Wf4zKDIi0odKdLtAr3rxJqmdbYcCJo99pW54RdJrdHvYMQ94/9gg1Iv4A3ZLgDXyMdlRaEQMEB/NPEHzfJhcJporMhqGBFAXrtWV4xXhGg9xaAA3CehRkKKGlp6F7OS80Kx5j0R5AIcRyn0TwwvCFC3NOmwtSgp6q4cdYcCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478951; c=relaxed/simple;
	bh=o2LxxZGq7k/+PaYV98lEqh9Y1ymPqqZ/qAiKsR0Qsaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwOlN0kfvVw5cxnyTDWhE8OhuJh+NC1L3WlVGwwkjv+LwF/E6peOdiMsSA+0Y3MHSYEHIUWOQ2dItfTZJMbXYFVwa7M4FDjhqhtu0KVEKahtzxwiufDZGYnbmCgLNPMjqFJCU5ctWc1hgOyIbriqx3Ap8bXe+7ZciGCWZvNY4zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VizPWdff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VizPWdff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC93C32782;
	Mon, 12 Aug 2024 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478951;
	bh=o2LxxZGq7k/+PaYV98lEqh9Y1ymPqqZ/qAiKsR0Qsaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VizPWdffGdi+QOWnP8YLcl9AQ8kvmwccO2x2TOLU6k+fUmle8YRwIJeSJldcFsrtM
	 hJGU8wNEEzjdcbEwWRSO6lWfWM4/DfnPYf06V9J3vR+Mn6EAPsinqjUsA6kXSVxxiZ
	 GNIMyolabtJBl7q34y+QOxMNkY4TmKt+t/96wX4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/150] ALSA: usb-audio: Re-add ScratchAmp quirk entries
Date: Mon, 12 Aug 2024 18:02:46 +0200
Message-ID: <20240812160128.450453040@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 03898691d42e0170e7d00f07cbe21ce0e9f3a8fa ]

At the code refactoring of USB-audio quirk handling, I assumed that
the quirk entries of Stanton ScratchAmp devices were only about the
device name, and moved them completely into the rename table.
But it seems that the device requires the quirk entry so that it's
probed by the driver itself.

This re-adds back the quirk entries of ScratchAmp, but in a
minimalistic manner.

Fixes: 5436f59bc5bc ("ALSA: usb-audio: Move device rename and profile quirks to an internal table")
Link: https://patch.msgid.link/20240808081803.22300-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 5d72dc8441cbb..af1b8cf5a9883 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2594,6 +2594,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Stanton ScratchAmp */
+{ USB_DEVICE(0x103d, 0x0100) },
+{ USB_DEVICE(0x103d, 0x0101) },
+
 /* Novation EMS devices */
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x0001),
-- 
2.43.0



