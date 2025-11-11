Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E466A34A76A;
	Tue, 11 Nov 2025 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823778; cv=none; b=qvFtrZijxPW0NbzSjWm6XTHVEGHkeVoU5fSUMqBX+VtfdCcWJQnCL89GNAQi5aVYAlSkVMkulnFYEoZ9ZwhzvUTBUxP3/WBTpkt1/mU9D/mVLX0z7niGYymHFlySXvZ33+6gPl9EpkbBrgbUyv1F6QZ+G9Y2re7h4f8enmVYOUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823778; c=relaxed/simple;
	bh=aRNkAIjKLK4By5reu3uuGrQx9ol+oSHbvEpz0O/w+4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdncYG9U/US7rm5y/lcXfuhXeZupoxjm4lEboBWA/neVLrdzq/cHraaHVZhqHHObEEnudD9mlzyX4DPZpivL21rGL7mfoW4UHVxjMayLO/dDBj/wfGZkQGTNfQlYxj9R8uabHwY58hyDgBEFOwcZe8wOHvKdSrxiXNG4oW+EvCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQP9kOzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQP9kOzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069BAC4CEF5;
	Tue, 11 Nov 2025 01:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823777;
	bh=aRNkAIjKLK4By5reu3uuGrQx9ol+oSHbvEpz0O/w+4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQP9kOzxiDPlza6aAwrbFGLMDZZ980R6adbBvBK0593gs1GdhTfZb0aHGPF+qlWVZ
	 v90reyLU664/C90dnT13EQ0FMUbAQlnCT21Uyu7tutfvkQmNHBNTStldZlhKwMC6oX
	 SA5iQH06h3Wc4sPzwDyJzwDBkRfO7YNz/ExOIHe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/565] mips: lantiq: danube: rename stp node on EASY50712 reference board
Date: Tue, 11 Nov 2025 09:42:09 +0900
Message-ID: <20251111004533.026660724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



