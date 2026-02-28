Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C9733F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300915; cv=none; b=aTeNLsbixi1xpMFh17F/k4KDK6En3W8ltrzBqBCGYi1MGlYRgijjpuar+WAyVlZyoLu4FG+9GaEH9qX9mhqJSKiu3a0rDxKS5BCkWTyIll/LLssK82z7L4wFtHQ96IbrIfqbrovdJWlvo4Y48tADZWudvNstG+SRbv4Jj0gbSQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300915; c=relaxed/simple;
	bh=HfdzIhtm/P1ivjYx+JiI04y9xYn3VxaKtR7qwfHK22Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cp5+M3DHPECpK/N2sHm4dKrM5SoYvmHIMyXobKKxTYgBVcYwWiXs+VYhQvUWgtsXeek1FYYjyMeIrVyHtDAi6Fj6cr77v8Qkl62B9hM0G0fY38ZtYHPoK5kv4oqMboT9myUDSxjfwOWdHTTcN0vP8wVPwiO1132WJqwGWR93LW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JP1QxjOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JP1QxjOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC54C19424;
	Sat, 28 Feb 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300915;
	bh=HfdzIhtm/P1ivjYx+JiI04y9xYn3VxaKtR7qwfHK22Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP1QxjOLrVz5E/Q79CbCgWvHpKdxbdJ1cHzj4kPpnLSS8V1OwpcDUQ8m29cz4+x3Q
	 8xnVNxJ9jNVAqwYT2OIIcbmbmIryZOF9NZh0aM7HnuwGEpSftIurAEXGw4ceK4eLur
	 w4YC6212We2mFJv108oqI84meBzBK9DkQr8Wf2q7k3HnQptgoJj83YzbNBZJvXy+6t
	 i3QiK0w39wQOykR7oPMGNvX6y9KbYBuzN07OJTwp9WxnY6Zpnn8+4VW/jgwez1VHb5
	 0gLvqM4iA8fXvAru0kng3vflHMkZoe35RUSzHhJhEPQd6thipv51l+rz7snRTJ6J1M
	 7XO/3EiUBjHvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/752] i3c: mipi-i3c-hci: Stop reading Extended Capabilities if capability ID is 0
Date: Sat, 28 Feb 2026 12:35:42 -0500
Message-ID: <20260228174750.1542406-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 0818e4aa8fdeeed5973e0a8faeddc9da599fc897 ]

Extended Capability ID value 0 is special.  It signifies the end of the
list.  Stop reading Extended Capabilities if capability ID is 0.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260106164416.67074-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/ext_caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/ext_caps.c b/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
index 7714f00ea9cc0..533a495e14c86 100644
--- a/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
+++ b/drivers/i3c/master/mipi-i3c-hci/ext_caps.c
@@ -272,7 +272,7 @@ int i3c_hci_parse_ext_caps(struct i3c_hci *hci)
 		cap_length = FIELD_GET(CAP_HEADER_LENGTH, cap_header);
 		dev_dbg(&hci->master.dev, "id=0x%02x length=%d",
 			cap_id, cap_length);
-		if (!cap_length)
+		if (!cap_id || !cap_length)
 			break;
 		if (curr_cap + cap_length * 4 >= end) {
 			dev_err(&hci->master.dev,
-- 
2.51.0

