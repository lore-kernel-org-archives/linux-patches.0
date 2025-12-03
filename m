Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E8135FF45;
	Wed,  3 Dec 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779290; cv=none; b=sx7oQcu4bhjWjpM5xQ2Zr9ZhNS+FVB2kjIYVVSRWxSw9Ht1oX56ll5VrR0dE7Dpk2RXPAWmSYxC1qx9vWeY9M2uxkO5pDcOG0pc27sTeOV+gbsuDegTizm1fgdc6XtQU79iYfgxmDSEL0xjufNGwxSHtYM6Vy7UMAj7NsDzWSQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779290; c=relaxed/simple;
	bh=Eu7Vc3c1NyAvpUvG9xJ9RDi6AFUIuaECLCLJ6K6YStc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW3vPar9ChUTk/C4kNXu7zKTT6+g1Ilt2BbEuU/gsbxane4K0jD2RjbD3sg+bWyJ3PF3IC5hBE7LzuG16JICH9OS+yCB9O2gNbj+moYJCJTcbnkxwn0KgYWZ7hwfqkHeWiD/v2DpEoTeSfa1N9sGo/K1a6dyFk9nKQCc1V7vkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3FJiKfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3FJiKfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777BFC4CEF5;
	Wed,  3 Dec 2025 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779289;
	bh=Eu7Vc3c1NyAvpUvG9xJ9RDi6AFUIuaECLCLJ6K6YStc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3FJiKfK4iwWQpXfN9Q0/TOqd7dMfNHMisZUd2myazf8hseYklc0S3xF+j263ROkH
	 961QvAh6h0B5JxzhSh9aYTV38tj9+1I0iIymFM2fTiAzOCnt8xUSmkezQAaQQRWOTa
	 e6/ytdirD33L5cxXWQq5yhcELf8rj7mZc5+2CcSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/568] mips: lantiq: danube: rename stp node on EASY50712 reference board
Date: Wed,  3 Dec 2025 16:23:02 +0100
Message-ID: <20251203152447.322047368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 2b9706ce84be9cb26be03e1ad2e43ec8bc3986be ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: stp@e100bb0 (lantiq,gpio-stp-xway): $nodename:0: 'stp@e100bb0' does not match '^gpio@[0-9a-f]+$'
	from schema $id: http://devicetree.org/schemas/gpio/gpio-stp-xway.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index ab70028dbefcf..c9f7886f57b8c 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -96,7 +96,7 @@
 			lantiq,tx-burst-length = <4>;
 		};
 
-		stp0: stp@e100bb0 {
+		stp0: gpio@e100bb0 {
 			#gpio-cells = <2>;
 			compatible = "lantiq,gpio-stp-xway";
 			gpio-controller;
-- 
2.51.0



