Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7F23F12E0;
	Sat, 12 Sep 2026 07:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198077; cv=none; b=ACgtC5hnMqrhVOJPxq4vrtq9her3ye5ePH7D1/nqVpkV5EMqf4Ub8cKm5NWq27jr9TeSG9FeodVdAQomvXuZ9dk3Mchoh+EcgFb90Jhf4sPM1D64EXCJvZwtq2woXYNoWjnexb4ZuGkwXz8S6mXHax+7srtgIWO4Le2QaE+b9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198077; c=relaxed/simple;
	bh=56nQexfyAFkw8NvwdaTYfaSeUDTDrWPHrLYBBBIIuA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amRgMTOM+4FwRR2O5gjJwjhjXLzJlqjZLVCFRkPH5FbUe8p/TxWEG0DDV2bSgKVMYmLKfv/7/oUhoNKfEGr+BnZ/SZtFwfbAt3Ida0R4fxXBjW1ZwKBOoTdI7bFzGZmA1vfmgzW1Vaxkuh8EUXie//ayrNl+W9ZD135DDD7tErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6BArqoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6BArqoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA38C1F000FF;
	Sat, 12 Sep 2026 07:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198075;
	bh=ltM9JKK8MKZA2Gv6V9ycY3Wo1uO7eyeD1R4Jv1jaivk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6BArqoJuCYetjOZOVbxzKd5V/o+qZbUtZYwQJMJpZSsq2+ABqkPEoKI625UayMba
	 1RW6KNeCqGLBLiyT/fd/RH078c2Ufp7KzNI2lEjADXg52zmWwdpQiJmbfCe0JoMV5l
	 vSAVAwSPWarrmmHnyG4NRnwOBVnL5UuOAyjwVFUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0305/1815] platform/x86: dell-wmi-base: Fix handling of ultra performance key
Date: Sat, 12 Sep 2026 08:34:15 +0200
Message-ID: <20260912065656.107418743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit adfd6846bea13667ff28f8aaf00c32fbd69825ab ]

The commit message of commit 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
states that the ultra performance key contains additional data
after the type and code fields. The event data passed to
dell_wmi_process_key() is already parsed, so "buffer" already
starts after those two fields.

Use the correct index for accessing the first data field to avoid
a potential buffer overread.

Fixes: 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-4-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index fd6a508cd902c..38a6b3ae2f75c 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -456,7 +456,7 @@ static int dell_wmi_process_key(struct wmi_device *wdev, int type, int code, __l
 			key++;
 		used = 1;
 	} else if (type == 0x0012 && code == 0x000d && remaining > 0) {
-		value = (le16_to_cpu(buffer[2]) == 2);
+		value = (le16_to_cpu(buffer[0]) == 2);
 		used = 1;
 	}
 
-- 
2.53.0



