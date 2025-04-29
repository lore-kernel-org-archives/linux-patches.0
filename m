Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2793FFD;
	Tue, 29 Apr 2025 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949657; cv=none; b=WiU30bnDGbq87auARtiFGGA7H+5lDJ37vk9kY+aFIa5pNdgYsln4tzyhsPfcdhKoOm0YNi8Hon7ZrPtqvZk24ecUAt5cmubdn6dapMCyI3Iz6QHf0ci0h/fRihGUOWapbBmFBXOC1hTDmbfpcIZYU8IVppMIK3bWmtGI/8KjlZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949657; c=relaxed/simple;
	bh=7T+xVb1gajI87nkH/DmLiVpss/dx1iozbLocXgO2XjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f63lBfDYw89IxA7DULHi1y0okhY4Yu04J26GQb3axVK5TlpK+lKhAKPwV9lhXVV28fTNn2sDXWInhNl2xpc4gUiea8teBUZf5Nl2pp6x0/qkbGNoOblAOjfM7GVQi5Wfo0mVOAh2fdRz/NUN63QS9rRgS9MgIj/bq6xqMNCUR1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq9IqAMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq9IqAMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57854C4CEE3;
	Tue, 29 Apr 2025 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949657;
	bh=7T+xVb1gajI87nkH/DmLiVpss/dx1iozbLocXgO2XjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq9IqAMsunp7JaiHrcbMCmNRrlq5ZYrTNqp9aBil3jR8RXzhwS0Y798qPQ7aKbFH7
	 95Rqjyio2TU0/OMxqQXvUqrDWUXKAs2/PztHRTNQw0Mi8U6fRTzaW8BqtLHR+3O+zr
	 mrXZv3AORwJAGJSO3YCrz+te261AhuygdIt1vs7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/167] net: dsa: mv88e6xxx: fix internal PHYs for 6320 family
Date: Tue, 29 Apr 2025 18:42:03 +0200
Message-ID: <20250429161052.367901782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 52fdc41c3278c981066a461d03d5477ebfcf270c ]

Fix internal PHYs definition for the 6320 family, which has only 2
internal PHYs (on ports 3 and 4).

Fixes: bc3931557d1d ("net: dsa: mv88e6xxx: Add number of internal PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 6.6.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-7-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c1a322d6432c0..52dd00f2a83ca 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6212,7 +6212,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.port_base_addr = 0x10,
@@ -6237,7 +6238,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.port_base_addr = 0x10,
-- 
2.39.5



