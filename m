Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275A8470138;
	Tue, 21 Jul 2026 19:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662458; cv=none; b=gO2fIflkQhGsXiFNtOR83vcf3AIixLZDIjrsnV2V4jPPj5SM6KCdEWiD6mLJQtgIecxBqFfdCG9AqNnW9WIKSEPQpTyE7bSXjpUHZ15QjtPJQVYdWUec2sxsoXwKXonw2hu5FutyO8pnHqNR6/SvHvBU2HDpctnTpKw6MpLUOfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662458; c=relaxed/simple;
	bh=fU2xKwPvYbaQwklKMoMh4ztgOk4hH3M3ey/9o1wDnJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kimaHBDbNgqkNDtqhtSZS1mJMINlJkN8bMmG+qsLVIraXHwnjmc314pCtl55ywbg56ozGD6xAybU9f+SSEFi1qtIL/WU1+NRyQzksnVQllqBLwWG+2dikkfFl97v9Ee7KhpP0MDeD5dzbcgvEwWqqwcxDi8EN+Phn5HFVWJNTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVSF8Edg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVSF8Edg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5A51F00A3A;
	Tue, 21 Jul 2026 19:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662457;
	bh=HUpwvzDPZZGgm1GTusBZEDliyQVDqLwaRWqWlqRXujA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVSF8EdgRNs5pQZune+lqmolC83bS1WbxEcKjnzFSXphz7RnG8DXu/B6rzQ3wO7mB
	 PEP0LL381ExDNI1HeTu33ybfk3o6pxD3KnLYpnHqq9qE3HW7ggWFcbyd9iK2XN3GEu
	 jkrA87Liccy5Wwtjo+tVbr9A9w+nCDJkFyuQYxfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0451/1276] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:14:54 +0200
Message-ID: <20260721152456.196362310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 858ac2ab46bd97..c4ea7f25525617 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -164,7 +164,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



