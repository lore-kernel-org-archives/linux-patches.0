Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9AF255248;
	Thu, 17 Apr 2025 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913049; cv=none; b=MGl8knhU8qj4wxScvPnPYZNq/Z9yBQ2RzG8h3oRxtFqFfoQsy3zGX38cEyW2XquheAlfcYOzW51yRBtF+CYbpyYoq9ZZ2rlvCvEtOQU4qBj4aj8UY7or2DWdU+pczpMhDWS7fuwHT7RfEAPBFrjCmpTR36gOhkw8Ahm+KIPXXas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913049; c=relaxed/simple;
	bh=LmvZktLXw8mz0r9t6gb3jnNJZnYDO7vHh2rP9DkhjIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDLb6aSG+2tGQeoV+M13jgYMptfi4EwOep+5wtPQqjV+xsqG9A6+/oLXqz+Myy0X3Qfp0bzwyCkN0B82fAAuF1dnqdQQ8utjiks2P3doawvVLhpnQkOp8mPd/O9am/Ab35bcyBLlAPJGsrQU4NANZD4QbC8nck1Hb+s73kstTHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdL8MrMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdL8MrMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3610AC4CEE4;
	Thu, 17 Apr 2025 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913049;
	bh=LmvZktLXw8mz0r9t6gb3jnNJZnYDO7vHh2rP9DkhjIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdL8MrMUxWPc03eK8WD2Gp/PnfjN1GIf84YRHBtuRHMa8ewsjzD2oi3O85SdXYFLA
	 1XOUYGGj2QbqiCO416esRG+Nm78SmuiKjDKxt6YvYmXwvWm4bF0EW7WkDqWnjvyC9N
	 ddPANdUOdbhpdTvCPtaxbxIVVc11MmC6OKMWkASk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 211/449] HID: pidff: Remove redundant call to pidff_find_special_keys
Date: Thu, 17 Apr 2025 19:48:19 +0200
Message-ID: <20250417175126.469926272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 1bd55e79cbc0ea2d6a65f51e06c891806359c2f2 ]

Probably left out as a mistake after Anssi created the helper macro

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index d5734cbf745d1..6f6c47bd57eaa 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1159,10 +1159,6 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 		return -1;
 	}
 
-	pidff_find_special_keys(pidff->control_id, pidff->device_control,
-				pidff_device_control,
-				sizeof(pidff_device_control));
-
 	PIDFF_FIND_SPECIAL_KEYS(control_id, device_control, device_control);
 
 	if (!PIDFF_FIND_SPECIAL_KEYS(type_id, create_new_effect_type,
-- 
2.39.5



