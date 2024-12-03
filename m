Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B45823CE;
	Tue,  3 Dec 2024 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241846; cv=none; b=GkS6B76NrBGOMAoTfWy7EuTZSwTr+38HAPX+P4NonjWNnrTKMQpabJCaIyQ2SUwHLJGejmiyx2+nZp/T8i0Kty/oejSD11GSsAUxpfzlibAnf8xmFLvkMzbIyE4GJPCKJqXVShSxpzp4KwgMCWNh3QIfTwsf7BwHQPKBEHHNVVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241846; c=relaxed/simple;
	bh=k8P9bUTBc8tgfjCxL9LTxjBccqcuQY2iNmiRExnpijM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfjHVkWNC+GOrABpvN9wFtPXmmSHwqgWW1g03bZdG93jtfBxjGVdtPneFLp7VrDSqjtDEpO+E1YNB5aQg9fs6WUW2yYKG8MUk8ErfKS+riSyiyO13iHPOGAz9bL0h7mYmraGienz7ATUdGlwuh5wt/Do26tL98H0maL2diMC0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXRZCMu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXRZCMu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053DEC4CECF;
	Tue,  3 Dec 2024 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241846;
	bh=k8P9bUTBc8tgfjCxL9LTxjBccqcuQY2iNmiRExnpijM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXRZCMu6HeVLWTGY8W6kOO0fx/87LGxovv+++V4r7Is2jyEUPycwRf7IToEbCGSXC
	 wT/c5L6pfgCZXD14RYBw3zHhEj0Iq5I6D6w9sNWtwPzT4ASyNElEWDsfG+RIxtLXIk
	 ZY9Jmj2pngWsqQQZVrSW8/OB/gFaex/pQ5bdMZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arne Schwabe <arne@rfc2549.org>,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 534/826] hwmon: (aquacomputer_d5next) Fix length of speed_input array
Date: Tue,  3 Dec 2024 15:44:21 +0100
Message-ID: <20241203144804.586198089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit 998b5a78a9ce1cc4378e7281e4ea310e37596170 ]

Commit 120584c728a6 ("hwmon: (aquacomputer_d5next) Add support for Octo
flow sensor") added support for reading Octo flow sensor, but didn't
update the priv->speed_input array length. Since Octo has 8 fans, with
the addition of the flow sensor the proper length for speed_input is 9.

Reported by Arne Schwabe on Github [1], who received a UBSAN warning.

Fixes: 120584c728a6 ("hwmon: (aquacomputer_d5next) Add support for Octo flow sensor")
Closes: https://github.com/aleksamagicka/aquacomputer_d5next-hwmon/issues/100 [1]
Reported-by: Arne Schwabe <arne@rfc2549.org>
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Message-ID: <20241124152725.7205-1-savicaleksa83@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 34cac27e4ddec..0dcb8a3a691d6 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -597,7 +597,7 @@ struct aqc_data {
 
 	/* Sensor values */
 	s32 temp_input[20];	/* Max 4 physical and 16 virtual or 8 physical and 12 virtual */
-	s32 speed_input[8];
+	s32 speed_input[9];
 	u32 speed_input_min[1];
 	u32 speed_input_target[1];
 	u32 speed_input_max[1];
-- 
2.43.0



