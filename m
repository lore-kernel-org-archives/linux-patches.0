Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807E3DDB03;
	Tue, 21 Jul 2026 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673783; cv=none; b=KiAON5Fa7f0VEZ7Fnr3wqYHlYmVSK8s5fncruEGHSIBoUlT/ojImbJn4um9YMmtSMgEHuMgnBcIpIoMmiQFWD15EmgwjY10C1GtVDzIictihpu0C1uz+N5iP+uo02NgGEjHRA9gKQsU8ao/fbh9WqOTlnuc0lphdLNes2FY294Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673783; c=relaxed/simple;
	bh=cjvyE80GrOUu1aMXuohMFKo2fvi/H4kGRyj9bMRPG+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2u+z/DFTWRzGJAR8MimTYeKHFlp+iPxdhehAv2yk2cVi7qWWUdg+bwvYxk4X9EX2okd+ErbbkqSgGEV1cysccqZtlrjMObL4hgiRRXwzhD+1F7qefXGr9GVYp8ILDU2uqe/KwX5CQuUwaHZE4IbMkzX/Tzx1Gn1P+kI4PLqPnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWWxorWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWWxorWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3849B1F000E9;
	Tue, 21 Jul 2026 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673782;
	bh=pML2Z1L8ugRlcLtTeaWX7x+1lhw8aPM8V9RY+pdc9Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWWxorWqFJHj4sPtDitiq6z+5r9O0ejoFl8mt9p4/LXhcoE1Bje50yVnciXJaSJ5a
	 vFLbJcWly3V0iVecveSjlPOaA9Xjz/ym32NybBtu+606IsgXtBT2B9dyf+jzDD1Py0
	 BS2bqbmSXFybpg7u4J9TV7JR8lbh1grYuenq88ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/699] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:20:52 +0200
Message-ID: <20260721152402.306386982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d31f2737b13dca..8b05aad21970cf 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -150,7 +150,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



