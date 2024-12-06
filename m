Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD26D13A863;
	Fri,  6 Dec 2024 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498135; cv=none; b=G2pEqY0BMelGEVasCYs9Xss3ubWS4iw4W0BC7YITRRSeSK9lTGFjl7UlqB/+ApaSkdBlUHgLImWmJH1Cr5QYQ0kKuh8lLm9mgJRmnASb5oelMAp4fmgQoaZ16Gt01eJiBZ9WYdbghQ2ZWZzf/hjuYvzdLx1cDnnlb5OWuWDT6Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498135; c=relaxed/simple;
	bh=/wSven7TUQhQ3IMCZlYS69/y4hoUo9YFCuFwpoEHXGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEJhe3CRFTYatDzi4xWp2qkMTzENvwHqF3pJPbTElBrFaMvb8L2YsSpvBcgX8k3OxWDvafyvNzJfo6nDbzRaZIprPf1UTKuA65KDZN0TCdTIhahkApriswjs0L4HrqhNEh1srpgueU3zanuBXmNTfYfwDibzqCFXpVdSQ+NbGGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDjACqO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDjACqO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6658C4CED1;
	Fri,  6 Dec 2024 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498135;
	bh=/wSven7TUQhQ3IMCZlYS69/y4hoUo9YFCuFwpoEHXGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDjACqO5jLijmC1P9frpfr89PAczim+aPJ1wMG76beZRIy3sElF7/Z1TAw0Q9aiPz
	 RZpBdhKSOsMqUr2wXPz4U13HhH4vRkfGAOKJ6iddX00MGlDBrK8gzIoRYlApucUctr
	 ZTKw4ORuEGOuatyhs52lJ4Kkn5A+68AqVUYzuLr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.6 497/676] ARM: dts: omap36xx: declare 1GHz OPP as turbo again
Date: Fri,  6 Dec 2024 15:35:16 +0100
Message-ID: <20241206143712.772070300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

commit 96a64e9730c2c76cfa5c510583a0fbf40d62886b upstream.

Operating stable without reduced chip life at 1Ghz needs several
technologies working: The technologies involve
- SmartReflex
- DVFS

As this cannot directly specified in the OPP table as dependecies in the
devicetree yet, use the turbo flag again to mark this OPP as something
special to have some kind of opt-in.

So revert commit
5f1bf7ae8481 ("ARM: dts: omap36xx: Remove turbo mode for 1GHz variants")

Practical reasoning:
At least the GTA04A5 (DM3730) has become unstable with that OPP enabled.
Furthermore nothing enforces the availability of said technologies,
even in the kernel configuration, so allow users to rather opt-in.

Cc: Stable@vger.kernel.org
Fixes: 5f1bf7ae8481 ("ARM: dts: omap36xx: Remove turbo mode for 1GHz variants")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20241018214727.275162-1-andreas@kemnade.info
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/omap36xx.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/ti/omap/omap36xx.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap36xx.dtsi
@@ -72,6 +72,7 @@
 					 <1375000 1375000 1375000>;
 			/* only on am/dm37x with speed-binned bit set */
 			opp-supported-hw = <0xffffffff 2>;
+			turbo-mode;
 		};
 	};
 


