Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62049347FE1;
	Tue, 16 Dec 2025 11:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885384; cv=none; b=BCczcEETMMKayOHRETglegDUs2nj47vZwg4e6PhSUEQfsviiDLqXnReEKYZOQ7ElUp7bZ+aAXQlst/YOJeK4uWxKT+YL5Qnw4EpkpUakB/VLXREEmgJqETjrFEhNDevblczoY/bjFSIgyKHXfcMo7jVwSACv/ethsc0rXrypkDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885384; c=relaxed/simple;
	bh=HqJfbsLykCj7mLX/APkzuMAL40Z2F04NYVkvle4ltOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9BqxcdpEuTueOT+TsULfIVMg9hGTC9ltJdNRButO/TmUUyupv4jjOe+GCrCsxKoiDLpoDtEORD6Tz+duhpWfEk4tFZ+SItZfMPY/xIJ+6/e7cIY1H++6hGDCvWFKLOv7alM64Hykkycbp+5H3F2j0EYaMy6VfaZN4gytaXOoBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXLfOmVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXLfOmVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FFEC4CEF1;
	Tue, 16 Dec 2025 11:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885384;
	bh=HqJfbsLykCj7mLX/APkzuMAL40Z2F04NYVkvle4ltOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXLfOmVMeCFHsiBYpBasbcDE0KFImDxZqIVKRBl+NqaG7iCG+fKoNPgokSGQYqL0g
	 Dn0iVNSr5hphfYQaQD7W1CpFDwa2vJEBfdkZtn4Qo9aDA27oTh5deE8+XijcQwDFjl
	 g3Ghtg33wYUtJtSNWhkNqmDYpho2vbGgYZE5EiP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Stuyk <fstuyk@runbox.com>,
	Sebastian Reichel <sre@kernel.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 123/507] media: ov02c10: Fix default vertical flip
Date: Tue, 16 Dec 2025 12:09:24 +0100
Message-ID: <20251216111349.988566063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sre@kernel.org>

[ Upstream commit d5ebe3f7d13d4cee3ff7e718de23564915aaf163 ]

The driver right now defaults to setting the vertical flip bit. This
conflicts with proper handling of the rotation property defined in
ACPI or device tree, so drop the VFLIP bit. It should be handled via
V4L2_CID_VFLIP instead.

Reported-by: Frederic Stuyk <fstuyk@runbox.com>
Closes: https://lore.kernel.org/all/b6df9ae7-ea9f-4e5a-8065-5b130f534f37@runbox.com/
Fixes: 44f89010dae0 ("media: i2c: Add Omnivision OV02C10 sensor driver")
Signed-off-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov02c10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov02c10.c b/drivers/media/i2c/ov02c10.c
index 089a4fd9627cf..3a02fce0a9bc0 100644
--- a/drivers/media/i2c/ov02c10.c
+++ b/drivers/media/i2c/ov02c10.c
@@ -175,7 +175,7 @@ static const struct reg_sequence sensor_1928x1092_30fps_setting[] = {
 	{0x3816, 0x01},
 	{0x3817, 0x01},
 
-	{0x3820, 0xb0},
+	{0x3820, 0xa0},
 	{0x3821, 0x00},
 	{0x3822, 0x80},
 	{0x3823, 0x08},
-- 
2.51.0



