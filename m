Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA61C07C4;
	Tue, 15 Oct 2024 13:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997260; cv=none; b=fnFotfOd+b09oEdS9TaC9OyBjFupKUtI21H75puLMbtzFRDClsKwQO8x6fS6do1Q4g1yzwNp/Pvc3PscUgmrXz4Rf9uO4EIKMeyODheNPR4RR9aW9x+1L8WYsuCfhg7AIRSpO92CLme/OFVLr+LK8Se78Mb07EYfvdpb32NWiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997260; c=relaxed/simple;
	bh=Aio2EwzxBSbBTj9LRqGIMY1CvIzAjNOAQxTgN/8gfSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYRCh44vx0Npc8fFfvOxeTDhXFReIafqx7XbG3xWWWvwH1PKF7kNmlvkGmJ6q+TOpOe6Ajvm3EXHshOTc5iTCcnpWZ6HWROfT6ZbndH5mKR4orq1tsA+RlKb8qRXnVB3FZoQYlg0s9G+XdR6C22TT8BZAHqXHM4Nzf+wjbJMniQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBtLhaCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBtLhaCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D84C4CECF;
	Tue, 15 Oct 2024 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997260;
	bh=Aio2EwzxBSbBTj9LRqGIMY1CvIzAjNOAQxTgN/8gfSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBtLhaCA2L6OOCGZ+zWBH9hTjfvyniG/RpS2xtVGSpj3gvZfzr01WUHimybYhRD5G
	 v97eKnhKv/G2zgsPB+Smn/3rfpARdSB0+dCc6Zr3/Y95LNrw5ExK7/bN0BUMPtwIzI
	 kwJoH8q8GPYiIH+GqowgsWZU9JxJubO1Yhc6S9Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/518] ipmi: docs: dont advertise deprecated sysfs entries
Date: Tue, 15 Oct 2024 14:40:34 +0200
Message-ID: <20241015123922.013614241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc281f10ce4b7..0bfeeeeb17c85 100644
--- a/Documentation/driver-api/ipmi.rst
+++ b/Documentation/driver-api/ipmi.rst
@@ -519,7 +519,7 @@ at module load time (for a module) with::
 	alerts_broken
 
 The addresses are normal I2C addresses.  The adapter is the string
-name of the adapter, as shown in /sys/class/i2c-adapter/i2c-<n>/name.
+name of the adapter, as shown in /sys/bus/i2c/devices/i2c-<n>/name.
 It is *NOT* i2c-<n> itself.  Also, the comparison is done ignoring
 spaces, so if the name is "This is an I2C chip" you can say
 adapter_name=ThisisanI2cchip.  This is because it's hard to pass in
-- 
2.43.0



