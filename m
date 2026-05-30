Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C4321B191;
	Sat, 30 May 2026 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162929; cv=none; b=mNYhXnLBn3f1Ss9mmW5lg/nNm0KQj2c6ZyC/0dZX33WA3bcGvcVMXysTQz+AWuoWM9pr2gKoFeydBzilL8pMPH5MxZT/Q2V+K67CMz8pS1siGfRh8O+C+JRsOU4b5pdasvRxVjuzcJCzbzy/KARH1IV175yasDOcXuzchQpy3dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162929; c=relaxed/simple;
	bh=1odURRuwlIuYAZPYn3KloW+nkrhYgIOweGhretxU5sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcESvxQZuS9eGU48yjSk3wf3+sERXySdyiMJncGZlL1sVfT6+CMR/4A9uxokraYfeIrXVBv5FUHODXn0qs26Yvcz4zKmnj3H4L7nxc8MaJribwiS42DTyzBCf11KyMeEoKBcn8/KGQyMW7TkfXbblwI20tx7gkG3VekWo9kkbj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSeOCwxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSeOCwxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFA11F00898;
	Sat, 30 May 2026 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162928;
	bh=TlxDsMfXv8nTcYiBdIEcqezZ33xWyzVftix1FAgipNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSeOCwxkRh233jCz42mIQ50gfyMLCZTty5hvPL3tGp28aeK0GLNGr6PMYX/uRWQyw
	 tmqlQZvUDhzdYr6ZijZMULQ7gq7mvl39hOlUU+s78NfpViXHe/AZxKsuOFTWJOCHVP
	 yJr/29GQ9Lioh8ZlcvJED1ua8TtVl/e4QqWA/CdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/776] arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V
Date: Sat, 30 May 2026 17:56:58 +0200
Message-ID: <20260530160243.033711590@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 511f76bf1dce5acf8907b65a7d1bc8f7e7c0d637 ]

The minimal voltage of VDD_SOC sourced from BUCK1 is 0.81V, which
is the currently set value. However, BD71837 only guarantees accuracy
of ±0.01V, and this still doesn't factor other reasons for actual
voltage to slightly drop in, resulting in the possibility of running
out of the operational range.

Bump the voltage up to 0.85V, which should give enough headroom.

Cc: stable@vger.kernel.org
Fixes: 8f0216b006e5 ("arm64: dts: Add a device tree for the Librem 5 phone")
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi
@@ -706,7 +706,7 @@
 				regulator-ramp-delay = <1250>;
 				rohm,dvs-run-voltage = <900000>;
 				rohm,dvs-idle-voltage = <850000>;
-				rohm,dvs-suspend-voltage = <810000>;
+				rohm,dvs-suspend-voltage = <850000>;
 				regulator-always-on;
 			};
 


