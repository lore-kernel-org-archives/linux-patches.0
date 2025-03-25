Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C5425B673;
	Tue, 25 Mar 2025 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905964; cv=none; b=s1FqdEfNfRg/1FPWGq4QvxgE0wSFFtEh88OuEA4RF/Z2OaS4/kFJP3Bd2jI3XUG2UxeM+u36i6Q8bjSRCSd5KCjFyzm45L9Rs89l0VBwh5EoGy7oBPZpUQRMcUxgcG4RVbtJTib1Navkd4N28PYIInwScKLQ1vxGqPzYqfVAHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905964; c=relaxed/simple;
	bh=bC7Ox/L0LE+j74ANvzttkByEOlXjeHhA9cQkMcWOO3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKN5+3njYEY55tKWY6SUfotM+Ev5SozEFZz2Rz+M007a43SGBQ/DNTLD1AcZypowdlDO1DULC7697wo1N1upu1bDykGjlrjfqSvRwDK/3L8yNm/fcXpdsEoPWYCSVIcI9uwuT5WMTLclQauB0vqHRVGPk6ldAnS3SerIM/iJ12s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOPdIys0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOPdIys0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED39FC4CEE4;
	Tue, 25 Mar 2025 12:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905964;
	bh=bC7Ox/L0LE+j74ANvzttkByEOlXjeHhA9cQkMcWOO3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOPdIys0l4nuxf1qYGCir8/6CkyZ1jpp6RSIfkGet7AAB1yz5E71ExWZ5bWps+EWv
	 xZuI8LfMvILxb+cLt9eIWKXzBpPBq1XMQUOjfa4oOU3q1tFHE3h93UHsm6Xnh/QYeq
	 F9chL2ts6TjZT6TA821vWQyRpQvrVucwags1IGqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Brautaset <tbrautaset@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/119] ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC3200
Date: Tue, 25 Mar 2025 08:21:18 -0400
Message-ID: <20250325122149.587312579@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chester A. Unal <chester.a.unal@arinc9.com>

[ Upstream commit 24d4c56dd68906bf55ff8fc2e2d36760f97dce5f ]

After using the device for a while, Tom reports that he initially described
the switch port labels incorrectly. Apparently, ASUS's own firmware also
describes them incorrectly. Correct them to what is seen on the chassis.

Reported-by: Tom Brautaset <tbrautaset@gmail.com>
Fixes: b116239094d8 ("ARM: dts: BCM5301X: Add DT for ASUS RT-AC3200")
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://lore.kernel.org/r/20250304-for-broadcom-fix-rt-ac3200-switch-ports-v1-1-7e249a19a13e@arinc9.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts b/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
index 53cb0c58f6d05..3da2daee0c849 100644
--- a/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
+++ b/arch/arm/boot/dts/broadcom/bcm4709-asus-rt-ac3200.dts
@@ -124,19 +124,19 @@ port@0 {
 		};
 
 		port@1 {
-			label = "lan1";
+			label = "lan4";
 		};
 
 		port@2 {
-			label = "lan2";
+			label = "lan3";
 		};
 
 		port@3 {
-			label = "lan3";
+			label = "lan2";
 		};
 
 		port@4 {
-			label = "lan4";
+			label = "lan1";
 		};
 	};
 };
-- 
2.39.5



