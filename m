Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B1183CB8;
	Mon, 12 Aug 2024 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479487; cv=none; b=ckYmCVQXFrIanTT2Qkp0YiWs0r+d37iHj98/F2jKjlMG1oWQLErYpSNfTiKghEQ2lTq+LthBiWCsBbTLEy898Z+dx2G8mkEwx8yF1Or5Yr/kBRoTyHXhJKHyd2F7+42qX4o2DrQ2I7j9wmaJKaHDPqRd3Kap7zG884kBNWABXrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479487; c=relaxed/simple;
	bh=k0onxOSHx6Xjfwz6FaRpPi5zKX1AJuLQ+YjarfB2YpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdJ917uq48qXgdYMN2HEmJayCKgZDbSCePRxvVJxm1WvPqobQPOnKG5HTDNz5KcEj5DKBCNjaooXw8WSgo6ODB+M60GiZ8frZsSydlwWITC5on1xNSPSfbUvIenaJgH8a3Jm6INpC1nKyrrnkU1oJPjln1lyJ+9zk17iDAAMqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp7mxjt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp7mxjt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1154C32782;
	Mon, 12 Aug 2024 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479487;
	bh=k0onxOSHx6Xjfwz6FaRpPi5zKX1AJuLQ+YjarfB2YpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pp7mxjt6DybhCIc1GQJjK6KWvRA4/DUMPVyxslRpjiobRBgc1lb9kWievq8IV+HaU
	 SzTek1wZ44izRfOddA+ILwG6OifOLRfKuVB+k9bnO8ZDbbwpgHko6MmSXysyA3pB6b
	 mNSP/l4EA84JGgQ3faZKj5Z0lXFv+v+ug7jGqVzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/189] ALSA: usb-audio: Re-add ScratchAmp quirk entries
Date: Mon, 12 Aug 2024 18:02:39 +0200
Message-ID: <20240812160136.106332371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



