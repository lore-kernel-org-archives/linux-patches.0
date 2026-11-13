Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590908;
	b=4oVpvWAZMei/GLKRHwL/b58tOa2F7ztNKeh+q0FAsWcZFo2C1oOjUxNJlmIMETp7PDkQ
	 xUM+JvWwFxFWYh/lYJduThHYqAvfPCNGQ23Vy1c+ECqccUvazfasT2/TUK3gLbKmUt4th
	 8n6r/CcWWQWUWwr+9pS8uywZrK83FQeQmpYz277km+Ip3GuwdfPyOazpBtUyxqRwWbFck
	 6hk9SKOVERK1L7kXTuLK5QgSgugvHfMp0+PkWMarc+NKXzJSDuyL6HUj3p4URcxqUjw1F
	 5LvOkvtd6gkukxIhxT7GrwJuJCkBPhkQtI6SNL7NN2g/1leFGrDys9bXSB/wnhRAG/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hP7ZrGMCUPCt8HIOid3Idg9DbS5KGCm5ZUCYm5f6B+0=;
	b=y0qLfV9cq/2Wgicmk74Q03qbx10o70h+YEJM/Sy0y1k7HREFebnxCAh1MIA/+FEBprvP
	 g747l0GlfVmmpA1Lgv0tvKzr/FoXArd7CYeWZWo1y/1PZTmXUnLTGVqfSaGF6q8hr3XDH
	 C/IlXMPXHJannomkFKOaB7NxhBKFoiT+wNXAU4FapRuw1WNsQ1xsIkpB1c9OtP17h1jId
	 34l/mxjzPerJYDEJ15MJCAH1H9ANT+vZRLEXJumPUtcW1RaB9vDNoCsHf5C/9UaRDIuWV
	 jJsC8xvJ60BgClFoAX8Q6VPn/BsAdzfRMzFd7eSQXFn0gAxj74Solx0himLt64yVyNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oz07CGOP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650D606E237;
	Fri, 13 Nov 2026 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oz07CGOP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C631F000C4;
	Fri, 13 Nov 2026 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590908;
	bh=hP7ZrGMCUPCt8HIOid3Idg9DbS5KGCm5ZUCYm5f6B+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oz07CGOPlYkXQCdLuuFBaxoyzjjHsUME+dOPi1sTrjvMDpQnU3x+vUSiicVXRldrv
	 kWJBRUxTMhS6LDS9/EBj6qOOh9evIg7784D4+0Mi0PKUG8QAM4es0jj5PXNe6Kq7DF
	 kObFjxsXGgVLIEq0WgKX5yUCT9nsYqkhwEtXMs3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/670] hwmon: (nct6775) Add ASUS ROG STRIX X870E-H GAMING WIFI7
Date: Fri, 13 Nov 2026 10:44:20 -0500
Message-ID: <20261113153815.151987843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 03897f9baf3eeea509b2c749bab435072f5e637a ]

The ASUS ROG STRIX X870E-H GAMING WIFI7 has a NCT6799D compatible chip,
which is also accessed via ACPI.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20251002184958.359744-1-luzmaximilian@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index ece183a0d4e91..8016f146d90df 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1403,6 +1403,7 @@ static const char * const asus_msi_boards[] = {
 	"ROG STRIX X670E-E GAMING WIFI",
 	"ROG STRIX X670E-F GAMING WIFI",
 	"ROG STRIX X670E-I GAMING WIFI",
+	"ROG STRIX X870E-H GAMING WIFI7",
 	"ROG STRIX Z590-A GAMING WIFI",
 	"ROG STRIX Z590-A GAMING WIFI II",
 	"ROG STRIX Z590-E GAMING WIFI",
-- 
2.53.0



