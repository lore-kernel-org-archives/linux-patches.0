Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150B1D0DC0;
	Wed,  2 Oct 2024 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877916; cv=none; b=jQS0Z+++HKhVRttRCEA0mPf+3n9WRiTSCWy2cGbKX9TdNThtqOSFJjbxzZ1QxnD2OnyISzdCLQF9RP+1tT4OdNv+yjtDc+cVY68u+sRUepoj0J2Yont+QcuVn/SD3HQOxhTudysdYr4wPIpekdyTkegRBNg71a0m0LAa9rFxlrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877916; c=relaxed/simple;
	bh=oN9W2561/zzq92LlsMnyFumnH1J31Ye9c2pq56RyzEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbw9+AdxE/DkDiG1lci4KykBWLM9IHjmj9Na4x+pStA9/fOfQIgFFRnkwI7VoApX2MWhjyDcIXbT3S6ubbyRFRV9C2Ge5k8kPVMD0BMJEjVP/DbNdv0K2rVp07dckvP0ODFyWwa+a0+Ez4oWyWA2Bt4jfqb7KyTbDp8av/OefMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaAOOwF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaAOOwF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E95DC4CEC2;
	Wed,  2 Oct 2024 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877916;
	bh=oN9W2561/zzq92LlsMnyFumnH1J31Ye9c2pq56RyzEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaAOOwF4eWADPNqNBsPqK7g2oGq5PmnYNGVWuQlqtXiZIwTbQDrVLQY6dNtruORO4
	 kMkQnN5EYixiME57NEUxtLrJ8yQio4TNNF0Abz9nRfX+Aa7KHCNop1UH+5Yh7oe6Qy
	 BbyXPhglIANh2M0R9+pfc80m7UDPC54thqqZ8elA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 207/634] ipmi: docs: dont advertise deprecated sysfs entries
Date: Wed,  2 Oct 2024 14:55:07 +0200
Message-ID: <20241002125819.276855570@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



