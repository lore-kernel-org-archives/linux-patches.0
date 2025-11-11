Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED231C56F;
	Tue, 11 Nov 2025 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823918; cv=none; b=hWqFa75aOA4muEVBAk6N9V+5pPpuhEYKaM5PAtZ9jV3f6N1v4qABa5wga6Zt+fscOgqWCLsN9/JkWpK/2BpI/H4qVtTqvMkbZXtWaZU+jCBKa9S1eF2NfFK7FXno5lUaQgv1PN4TM8xahvbI7U2RCLtg1A+Q3UIAzlKic03Z2m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823918; c=relaxed/simple;
	bh=ES6z+Zfl93Det8fOe5dgVpTot1hEImua5PFQZvBRsNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oATmL+a2XxeIBW/Pv0xin/Qx7s7hU+tqYYY79ATtxxMZCw+iE4pAErJ1Aylz/y3YOfCvgxhTb8/rRHDHNPCczLQcDRHgtZIlZGja9GsS6aDFjdKd1m67b2riDTKRYR7nJgYEb0SmXEu2VQFv6pZOtYTqvfj+OEtrWV4jtAMp7JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQux/ht4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQux/ht4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AD1C4CEFB;
	Tue, 11 Nov 2025 01:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823918;
	bh=ES6z+Zfl93Det8fOe5dgVpTot1hEImua5PFQZvBRsNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQux/ht4oW8O9b/UA70Xcq0l1PuXmIQkzvwDHhyBZ5QafaSrx/xu+Fl91jRKiZfR8
	 lOxPmuZZ5gSHvQwbsPIJrFDS1HpL4D7nat+iC+wU2JdqiSjXLgPBe7cARxGET+GQqS
	 qKSg083aS9oq52zV5xVvgmkqC9YBNHvYIBo/Vha8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 397/849] mips: lantiq: danube: add model to EASY50712 dts
Date: Tue, 11 Nov 2025 09:39:27 +0900
Message-ID: <20251111004546.036124166@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit cb96fd880ef78500b34d10fa76ddd3fa070287d6 ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: / (lantiq,xway): 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index c4d7aa5753b04..ab70028dbefcf 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -4,6 +4,8 @@
 /include/ "danube.dtsi"
 
 / {
+	model = "Intel EASY50712";
+
 	chosen {
 		bootargs = "console=ttyLTQ0,115200 init=/etc/preinit";
 	};
-- 
2.51.0



