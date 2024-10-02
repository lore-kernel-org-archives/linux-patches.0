Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322E1D0786;
	Wed,  2 Oct 2024 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879647; cv=none; b=rUCgoKwO7qa8t5zuGjfeQyjKHQU2zLZHdUOYS1tpncsG/10rHlIJUE95h8asfggnRgfY/eaFFYC5Vk8hB+7z1FR+3V/OGRjaKTXdO6K+LVY2AMdx95nkz+OAG7An6UMBcKjtOEptLK700a4Z9eIb6seFhEgS23kBUIhLvvLsGA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879647; c=relaxed/simple;
	bh=XdkBqKcKJM0k9ZEP7KHLMI3eW0SMkiIh4rVbb0ENc24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6D9VuF6El/m4HtZTovpFg9xPao2G5sjomByUNMCO/t7txFE2pC9k8+7Nk7X4fEhiL9GQZwysxRHNz9BE4+dzOqs8zA3IJpDvEEFsnhi/38kdKF7PCnxws8floRp7uk85+hCcQ+VjRVaUGFSC8ugJrGIdhd65mZo92ioThCZ0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCfWwS2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCfWwS2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D5C4CEC2;
	Wed,  2 Oct 2024 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879647;
	bh=XdkBqKcKJM0k9ZEP7KHLMI3eW0SMkiIh4rVbb0ENc24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCfWwS2bi32s3wLTdXBY8qwGvw7CuO9tAdHCsmOxP/9fzarRnmnUChaMGcLsO4XUf
	 /JzLb6F5UFwyxScytIRIXVU4aRVspVPeUPx48V92ZC3VETTT61PeO7pvzQmHxdlzqS
	 gzf3EG7LiGMDoiamL2PSywseGLmtz1/YwISLKQ3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/538] ipmi: docs: dont advertise deprecated sysfs entries
Date: Wed,  2 Oct 2024 14:56:42 +0200
Message-ID: <20241002125758.688156932@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



