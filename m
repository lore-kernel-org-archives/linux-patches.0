Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC97471264;
	Tue, 21 Jul 2026 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657074; cv=none; b=nCzN417KOpyVwGKGGY7DRVeBCca2MKEJxUPUKm0B8Sjtrbc+EC4XwS2IKMwupbHCjrgX+vV6qCieaZg9O1SIRMUw+IUt1MAa02ws9YsGRqDpNvEDzUMnyiUe3ajiVsPowgU3e6cC4vB/3RwyakOrlu3wFsOCWk5GevNXyOa4sTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657074; c=relaxed/simple;
	bh=zFNMjRS+W/k1WzfW3m/5dY2lNcZcwVp+SU0i/8lPJ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byiUsX40QSNO/NaKs/KfGzHwRLzT0M38rJgsLmDHw+1qBEu1QLuGgCm4VyYJzeFvfj/YlKcBECXS9gd5bDOw0Hu4HGQD+Hvrccny+V6s11JqKO17oH+219iRl74KOEKInhjO3knYqZeTA5NnLhVyqVUtcizAX1oPWe3KLIA+f2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9BQdqwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9BQdqwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBFB1F000E9;
	Tue, 21 Jul 2026 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657073;
	bh=uYdr/xXgyFSFUv8xFEJvCHg8FV+u8B40S0EoJALWNBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9BQdqwqFaS6bGlGPks8C7iwQpl/qv6kQVttZS3uPKM80dp3DAspgzWx17eG/sb7G
	 ZOQZat3s/F5YuzFLIKxOOwj2dlYXgnk3S0As6gfoHirt8OgsuBCCTcIpdxGtzDWc90
	 HDyVxaa71e3sUFvtL6nUEWLLOsKxd2NPdztKzv1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0627/1611] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:12:23 +0200
Message-ID: <20260721152529.491574158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2eb67d0caebb2b..4ba652ae547653 100644
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



