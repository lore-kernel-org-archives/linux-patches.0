Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98632185A8;
	Thu, 12 Dec 2024 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018177; cv=none; b=tyETZCtoazj3DyuBKKnkmgaccJ4KX0bv+YyOZ0qMCUvuBhHLU1ULlfXf9xDN2Dx6GVHcwrfE4zLPw5pJNBjFqdqz1GURB+UN+JLMzKMvX4s98i5Hmo4KnWHG4i91GiNL34arb4a82uTRr3bh2Dewjr9pj6e5LpAgkhAQJ326sv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018177; c=relaxed/simple;
	bh=9adRds/7pEcKq8eJgr5Jnlqy0pHttk3HtY7D03Aqz5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXJ8Q2W5/ZV43awIe6Wzmyy/BPvgHExsKUuHd92J95t0hGEiuk8wEYidRrmTFhUIUekPunpohcmmZqyktWLuNVJGHvuLqe1eo3CS0Mt4f3uthIYqzH4APpdx23VcwNeh6qzzG10xoAV7HwXE/lI54+jRPYN3Rkzk3pTF4r6eYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkOfRp48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkOfRp48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ACDC4CECE;
	Thu, 12 Dec 2024 15:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018176;
	bh=9adRds/7pEcKq8eJgr5Jnlqy0pHttk3HtY7D03Aqz5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkOfRp48v59sog9/+VTHIUl94S/sYjhBS/2yXa2rlqdjOOuxeUIUTQHA0tGhCUirW
	 cRADVRVOZ5NvbLz7Sa0gaQzwg5V54WyHYz5OiHpsdHN6MbzMQ34QzkwgYABgoEHrvp
	 YxLYtPhCdZnzq1IxBiH3rL7CELYm2+2OPQg6rR7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Giesler <tommy.giesler@hetzner.com>,
	Sarah Maedel <sarah.maedel@hetzner-cloud.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/356] hwmon: (nct6775) Add 665-ACE/600M-CL to ASUS WMI monitoring list
Date: Thu, 12 Dec 2024 15:58:31 +0100
Message-ID: <20241212144252.214327831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index 706a662dd077d..7e0ac3fcbc050 100644
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



