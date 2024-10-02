Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7E31D0174;
	Wed,  2 Oct 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875824; cv=none; b=bRbTKa9jWgOrjx5RSWjKpnLjEd1cTlVPKVvySlusqx9BZR96xheolV55AXt5ZiFddRr8ue4BeCTBmB1b7aBCTpr4DGoo02yp+4AsB8QCoMpfcN3RAAcKXQmkMWZ3EteskCUzDo5c/RlOi/4aBqK34hmEYUzMdS/E7v8h7MncfE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875824; c=relaxed/simple;
	bh=gIqUNGeZRrWZqMVUr/6i9ZU+nRNDXbJvMZ8RMC1cJtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlJfYTyqQ56EYwXyk3Wb6KFOlXM0ax55yEngBfgcFWW9GxQv6wsTXXgnyuPtrRCin6+iIt94nxT/oGzS4MGaSbSy8Pl/04KfxB4ZsECHIA0+ykX2BQHv7yl//wsEMdkQemHKk+FpInrKzhdmC/NMMOI//OZpKQVqfPyXz30wcK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r23RUMm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r23RUMm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC931C4CEC5;
	Wed,  2 Oct 2024 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875824;
	bh=gIqUNGeZRrWZqMVUr/6i9ZU+nRNDXbJvMZ8RMC1cJtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r23RUMm03lBKKzbw7zieWeb/qCRCFzeWFWrkBg8rpHQ/oam2gHS/PqCZV2GgEUEib
	 c1GJ3KMN7qT3cht9Z6BvTj8ozJQH0nAQtCAmRTlS4NnIYLvTbpJW7psLzCaUnm3ME5
	 F02Y/wwQHz+nYG5BKLdIQY7Tz6j6g+pDpnB27aik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 234/695] ipmi: docs: dont advertise deprecated sysfs entries
Date: Wed,  2 Oct 2024 14:53:52 +0200
Message-ID: <20241002125831.790478088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 64dce81f8c373c681e62d5ffe0397c45a35d48a2 ]

"i2c-adapter" class entries are deprecated since 2009. Switch to the
proper location.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Closes: https://lore.kernel.org/r/80c4a898-5867-4162-ac85-bdf7c7c68746@gmail.com
Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Message-Id: <20240901090211.3797-2-wsa+renesas@sang-engineering.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/ipmi.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/ipmi.rst b/Documentation/driver-api/ipmi.rst
index e224e47b6b094..dfa021eacd63c 100644
--- a/Documentation/driver-api/ipmi.rst
+++ b/Documentation/driver-api/ipmi.rst
@@ -540,7 +540,7 @@ at module load time (for a module) with::
 	alerts_broken
 
 The addresses are normal I2C addresses.  The adapter is the string
-name of the adapter, as shown in /sys/class/i2c-adapter/i2c-<n>/name.
+name of the adapter, as shown in /sys/bus/i2c/devices/i2c-<n>/name.
 It is *NOT* i2c-<n> itself.  Also, the comparison is done ignoring
 spaces, so if the name is "This is an I2C chip" you can say
 adapter_name=ThisisanI2cchip.  This is because it's hard to pass in
-- 
2.43.0



