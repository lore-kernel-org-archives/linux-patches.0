Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885A93B6379;
	Tue, 21 Jul 2026 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669296; cv=none; b=P0NLmOhEjsyTzlDvwAqreiekLjnDF7t323AT1Qz/iNdyaNabaRK7VDz6CxNhtUYTVuPWj150i677tx5Cp++yLwgcbd2thTrOGm3eKb/kkEQHnNDqi0b0bG6YrCQQ5mt6gY0VLGPQni+DbkZnbT6x3ZVHbk2kAPb/zyiQAf86K68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669296; c=relaxed/simple;
	bh=/M+vpq9K3cyZU9UsEjpuztkpIX7VFssFmW+3VQcjYCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojIC00mw9hqN367RaxG0FGYGhASiREbLfBxdpT8Lk8PKTIrKx/WqwrAJdzlt+PBedhH0y1l6DB4GM/bSiLzATCFj322vAxuAxKmGRRhSZ5SPbq9V1yf81i0QiL6s2vQCX8ThdUdVIvWkvX76aEPJ6QbGndNMG1Q/zrotEHZF74E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6LgCW5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6LgCW5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8671F00A3F;
	Tue, 21 Jul 2026 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669282;
	bh=NFgpn9Y3G2vwLdKu9+HP7qTZK2piKqfpr3AFX3dPlHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6LgCW5VRMSPv7e+Y61qQMu1PEE6TFFO+0TFam4/8BMUpWyKdwGRGM+geGknnVraX
	 0GI+BQMKhSWkywBOOaYwCrpGBTPenPYkTmXtYxAQF3CXrXbZg/OT3uTcDtHAGEq4a5
	 fiLrCZmvi12R9HlV4T3QcOsAE1/D82tTJp33a8Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0496/1067] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152435.709789203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89b0374bb9a851..eae0b0b46439d8 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -159,7 +159,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



