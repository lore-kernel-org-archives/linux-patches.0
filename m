Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7671AB6E2;
	Mon, 14 Oct 2024 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917879; cv=none; b=p3WbVyjOZrXQvtUjcxh8U3NGJg2DzzIHRxkFpq1R7vwkF3UlG8uRw+UlRLb0PscAM3yxJqsOUs98V/bjQSLGVruDcKp9NWTjYAMb17apbra+VtmXgYqD8VjNCXKiXzLB/Sb0Q01sWOkMjwGb36Y4Uat+jXZRHcltX6Hf6MpOzrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917879; c=relaxed/simple;
	bh=SPClmLHxCwPa9amvX5h4jpUsXWuZPSSnqQJADLJsg9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQRxRp2I/IMI4BPPfSXGuvyNn18boiAyGfud1e5iuSczraXaKPAkFKHUSgou3k8y94+Kz3cF9uPqymdOIihAijYcTXVbTx/ulYWRGQVOiYU5ibeIiS+RtnUCZXmdCQEXow8cRqoV7uHWsgxXDae2vlGRGo+1tWLzihv6Z1TNXUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh6BIuAb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh6BIuAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E2EC4CEC7;
	Mon, 14 Oct 2024 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917879;
	bh=SPClmLHxCwPa9amvX5h4jpUsXWuZPSSnqQJADLJsg9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jh6BIuAbmKZRzdPAbDaQLuu++IvlQZdCZJdO1mcyN3rPUkxd6efu0vdZvOUOmoy0a
	 D7vLy+jT2ATDvpwXoIB5+dXzstVsfqUHFpcswPvpLiADHDyrIOz272JQXDnPmzD+GJ
	 Fj/XIktzMNotkvMUI5ZdN/WyFNi7uCJmgn4NTLNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/798] ipmi: docs: dont advertise deprecated sysfs entries
Date: Mon, 14 Oct 2024 16:11:23 +0200
Message-ID: <20241014141222.989745884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



