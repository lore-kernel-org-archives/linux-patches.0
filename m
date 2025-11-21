Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABFA3A291;
	Fri, 21 Nov 2025 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732410; cv=none; b=FLQ5rVS2XM1rumJANhmDAgne3qoIwhQFcemsWWOdeI5h0kq8w0N9q68XmcDUZ0YmboqWUBpVf8JemEwwMxV5Jqs/8LP/BHWhZubVb0CD3MMuS+fH2Uy311soIJTQksVTIOQSsWRa6I5Wq+dCGieu0jMXWmOLVVDB+LsEzfTW1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732410; c=relaxed/simple;
	bh=AJ+YoTvWB0pmS6putKCvXD7LVhE11y78EV+v115/los=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaemB/fOQNyD/1ehp+78wju4EuHf7O+pl+HFg1te+I0Onim2YV/jls4/2qJMgkhn6Ierrvqec0u7jgWrDF9Gc93Wi290oXfOcQT4ikEEGpcs1vsa3dyBU8EFsQsP/bYhQpyOtYZmIdcEU54Z/l3boqE6eV00TkCa22KDkukJaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNHIStP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNHIStP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB67C4CEF1;
	Fri, 21 Nov 2025 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732410;
	bh=AJ+YoTvWB0pmS6putKCvXD7LVhE11y78EV+v115/los=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNHIStP3oYdlXxX9ZFq1Qdy6L1ZXb+o+F1Dd0B7bIEmj4yshpK8++gmv64HxPw4ND
	 7g9fOexApHYnualyhVUbgrX1MGEBBh2/prwJ8mTEOojGA1pbYS9wgIw14E0VDURIdL
	 4U1k5F+Gj85jms/UuI5GqArc2t4USSwcMxIjh5SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/529] mfd: stmpe-i2c: Add missing MODULE_LICENSE
Date: Fri, 21 Nov 2025 14:06:51 +0100
Message-ID: <20251121130235.010629275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 00ea54f058cd4cb082302fe598cfe148e0aadf94 ]

This driver is licensed GPL-2.0-only, so add the corresponding module flag.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725071153.338912-3-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index fe018bedab983..7e2ca39758825 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -137,3 +137,4 @@ module_exit(stmpe_exit);
 
 MODULE_DESCRIPTION("STMPE MFD I2C Interface Driver");
 MODULE_AUTHOR("Rabin Vincent <rabin.vincent@stericsson.com>");
+MODULE_LICENSE("GPL");
-- 
2.51.0



