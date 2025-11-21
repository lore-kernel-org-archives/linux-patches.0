Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE41ADC97;
	Fri, 21 Nov 2025 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732690; cv=none; b=E/38mPARHUzkMCtMenkdOLLOWApPvr+wgLPrOsO2O3gPZteDiqB21eFXN1TQakh7xUCMQGgDtWcAh8KZbpib6WyAiw+88xD6INsapGR6cYc+E9QXoYJqQs3pCrt9C6lkotjTHd1ZuYseH66S3EhSSCSO4a86tuZKWQmlFHptIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732690; c=relaxed/simple;
	bh=2NsGFUXfpukMl9XKfiEAvNSaud7WR4JOCMweKTaNTX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPFw7GngVYCi8IoK64h08jNgShugsNO3gR5ZfZDCre9RpdRq93c9pv8k/SCV0iJaKsTolTzbk+XxPjB+fmoZY5jRonjvcbUiAwHKLBnhepXbJQs3nkV2gmHOc5OxSbhIAMLfWbggqUloly8lSBHUQcaPcB5SL1XRDfT3WWlFQ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiumhUB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiumhUB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B66BC4CEF1;
	Fri, 21 Nov 2025 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732689;
	bh=2NsGFUXfpukMl9XKfiEAvNSaud7WR4JOCMweKTaNTX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiumhUB82USd0nyrSKI67N8gQk2AL3ju5venmgMlQLol1E4C6q8Q8D1yT2W8WnxYy
	 MtUkpEL0Uu06PKW1DpoXme2o1XJ7UwC3fJ06XzfWJVkVc/3Wr3dJSf6W5v5G/u1qTn
	 GOpt9oVFxOiR6jji4pTJ2Z1l406FpMuuAuUBtkB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/529] mips: lantiq: danube: rename stp node on EASY50712 reference board
Date: Fri, 21 Nov 2025 14:07:54 +0100
Message-ID: <20251121130237.245087372@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



