Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0881E32FA3D;
	Fri,  9 Jan 2026 11:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959630; cv=none; b=eTWlYBiu/vrOJNBjh1zKdIHIBdYZs2oCKzJVkpE6g7pjczRVU1IOC4p3IjccrVzgKSzi+y0haUicp1ZKN5aJ4PCYCgkMXycz2ahqAEyTumreTKSLGYwd3P8pTiJUrbsrq+UtpY/18diOBlamb5FDpWN6ZioX4I43By2jmo5BTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959630; c=relaxed/simple;
	bh=qM4PX+6Eq3D4Q9HHhxEfH7Y02e7OEK52WTZfDyGW4d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxDnpQvDgrck75tG/dytfgNW5jaoJllIcPh9qVkSM5pZCAzkXoX4/gpJBTfVEAjwxcIWc4F1qugN+vALHl3S3fFYgrUuNT1kt4qdxFET7WmDP0wKAb/AhjlzLAB/FtrCpyaZWpis0LBU29fKk6V5xsBYVKdEwK+CT6PTVDI4+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXtS/gFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXtS/gFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8661EC4CEF1;
	Fri,  9 Jan 2026 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959629;
	bh=qM4PX+6Eq3D4Q9HHhxEfH7Y02e7OEK52WTZfDyGW4d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXtS/gFJx/LzwZqfSnx3+OfPaMm7d/vOuOrgFoCr8vF5GbKxvVliQmNSQ91ds+JMM
	 mHeelqBoAc9J4yCxUfJX4veeUkY0CAU7YW1fUqo5v09KjSQ5y2JXnJBJtCMBsXgqP1
	 wGwy5eQZMkxsm/pYeUZX9i0HH1tNueVrcXnVTlVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yegor Yefremov <yegorslists@googlemail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/737] ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels
Date: Fri,  9 Jan 2026 12:34:19 +0100
Message-ID: <20260109112138.518439311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yegor Yefremov <yegorslists@googlemail.com>

[ Upstream commit d0c4b1723c419a18cb434903c7754954ecb51d35 ]

Fixes: 8e9d75fd2ec2 ("ARM: dts: am335x-netcom: add GPIO names for NetCom Plus 2-port devices")

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20251007103851.3765678-1-yegorslists@googlemail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
index 76751a324ad75..441d4696b94d9 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
@@ -222,10 +222,10 @@ &gpio3 {
 		"ModeA1",
 		"ModeA2",
 		"ModeA3",
-		"NC",
-		"NC",
-		"NC",
-		"NC",
+		"ModeB0",
+		"ModeB1",
+		"ModeB2",
+		"ModeB3",
 		"NC",
 		"NC",
 		"NC",
-- 
2.51.0



