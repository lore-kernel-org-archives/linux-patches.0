Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996F2153FC;
	Thu, 12 Dec 2024 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016647; cv=none; b=S7sqYZOrAQcC5R9Vckk2pJ9OJNx5ojYXAC4OBCgzjmRqqWdClcsYGwXz9kpDM7TQF++1wu+M7NkHX8aPiE+gM3WBS3BWlBJRDzPkRxbEf8llyLgIsLMLgip0aLWWr5CziYHxIPFtoq2BtXIL+5ne5emp6OFOIw7ne+ZG/2gi0cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016647; c=relaxed/simple;
	bh=A0XYsUuBLyWrIx3EqjooKB7Pxr1XF4NBomJRQzQ4Q0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2EcrjPGM7VR7oTQfPPyhiRcW2dpwDAqkfwuimUie68ARiUNno1G4lzgox2iILKnSIfZ7IxF3eTNjqb9799x4L1AFUoOVuuuw4POGi2OtZAp3C2vcSGMjdBpOsIBJuZP4GAxB56HuYeEgzgMvItSYgq8mxV67+NrjXNnxtTnxWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhmGOg2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhmGOg2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68937C4CED4;
	Thu, 12 Dec 2024 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016646;
	bh=A0XYsUuBLyWrIx3EqjooKB7Pxr1XF4NBomJRQzQ4Q0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhmGOg2Je41TK27qANi2+rFb4m7oDDwlL1CasdP2qmVCiv9DtPIKAzTvnWnTrfXDt
	 pQgero5n9ZKWKIUxz7pLMt72sJ3h0n1z3dH6W5G83wMYH9E+w2Tt+oXQcn1nHRbR7P
	 Rjr8tNTbC+KCwb5YMQyM8ZennoE/Nyw82DGiPTpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Giesler <tommy.giesler@hetzner.com>,
	Sarah Maedel <sarah.maedel@hetzner-cloud.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/466] hwmon: (nct6775) Add 665-ACE/600M-CL to ASUS WMI monitoring list
Date: Thu, 12 Dec 2024 15:56:36 +0100
Message-ID: <20241212144315.743092426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Sarah Maedel <sarah.maedel@hetzner-cloud.de>

[ Upstream commit ccae49e5cf6ebda1a7fa5d2ca99500987c7420c4 ]

Boards such as
* Pro WS 665-ACE
* Pro WS 600M-CL
have got a nct6775 chip, but by default there's no use of it
because of resource conflict with WMI method.

Add affected boards to the WMI monitoring list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Co-developed-by: Tommy Giesler <tommy.giesler@hetzner.com>
Signed-off-by: Tommy Giesler <tommy.giesler@hetzner.com>
Signed-off-by: Sarah Maedel <sarah.maedel@hetzner-cloud.de>
Message-ID: <20241018074611.358619-1-sarah.maedel@hetzner-cloud.de>
[groeck: Change commit message to imperative mood]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index 096f1daa8f2bc..1218a3b449a80 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -1350,6 +1350,8 @@ static const char * const asus_msi_boards[] = {
 	"Pro H610M-CT D4",
 	"Pro H610T D4",
 	"Pro Q670M-C",
+	"Pro WS 600M-CL",
+	"Pro WS 665-ACE",
 	"Pro WS W680-ACE",
 	"Pro WS W680-ACE IPMI",
 	"Pro WS W790-ACE",
-- 
2.43.0



