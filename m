Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BED21C1AD4;
	Wed, 19 Feb 2025 09:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956809; cv=none; b=QNmSB6E2PLnI16BDAREEcGbF4QRoqRAIH9yvGoQZYqx67LFG5906qGVNcI796hg05IsJE1esQ/5Wfxg/l1ggbKIVEOu7c0VdF6h3TeaV9G0WPoQfiQAuhecdYLRuHMgpk1gCb6vYpiUG7kNSPZexriei188ccfk0rrjD1oTBPC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956809; c=relaxed/simple;
	bh=kVtUGUmfQRPU1F5tX2lqK9n8gHO7UxwNnZ8RGXSv1YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SfHoYNXqYlHITS6zoS5KN/9Fmw3E7iOOWDMI1s4GfbzIvrKWAd7P+tyjicVe8RDC9FPtDSYyBUILF0DhtrJ8pCBN4G49ML52OAAZyzAqbBORevn027LdsehHiatvkBFckDb4KWHhYV8mi3dz4jDKvUe0z0uQI/dpIMY2MNyWOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOZ/sT7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOZ/sT7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883CDC4CED1;
	Wed, 19 Feb 2025 09:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956808;
	bh=kVtUGUmfQRPU1F5tX2lqK9n8gHO7UxwNnZ8RGXSv1YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOZ/sT7y/ey53nH003lNYSSumOp1tmgOCijtfsYqclwp0H+xcvMO0+5UFXWznIHrd
	 MP/UtL39kqIKJC9I2rF2EK5qBxjobgZ4abZey4x2nTsi6Q1mTTtlh/USMZKWG9gtv+
	 70vWRvyMzIAy8D28NnMvi4AGvn9RPkCTaGM6b7LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Illia Ostapyshyn <illia@yshyn.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/578] Input: allocate keycode for phone linking
Date: Wed, 19 Feb 2025 09:25:11 +0100
Message-ID: <20250219082705.091671653@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Illia Ostapyshyn <illia@yshyn.com>

[ Upstream commit 1bebc7869c99d466f819dd2cffaef0edf7d7a035 ]

The F11 key on the new Lenovo Thinkpad T14 Gen 5, T16 Gen 3, and P14s
Gen 5 laptops includes a symbol showing a smartphone and a laptop
chained together.  According to the user manual, it starts the Microsoft
Phone Link software used to connect to Android/iOS devices and relay
messages/calls or sync data.

As there are no suitable keycodes for this action, introduce a new one.

Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://lore.kernel.org/r/20241114173930.44983-2-illia@yshyn.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/input-event-codes.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index 1ce8a91349e9f..f410c22e080d3 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -519,6 +519,7 @@
 #define KEY_NOTIFICATION_CENTER	0x1bc	/* Show/hide the notification center */
 #define KEY_PICKUP_PHONE	0x1bd	/* Answer incoming call */
 #define KEY_HANGUP_PHONE	0x1be	/* Decline incoming call */
+#define KEY_LINK_PHONE		0x1bf   /* AL Phone Syncing */
 
 #define KEY_DEL_EOL		0x1c0
 #define KEY_DEL_EOS		0x1c1
-- 
2.39.5



