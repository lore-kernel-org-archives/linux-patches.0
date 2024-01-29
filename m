Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C98A15A49D;
	Mon, 29 Jan 2024 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548060; cv=none; b=haWTZvKZPqJbZ2Wunf+gboVC6soI/mafioW4XO8hpjluGpttIv5bHSRKCfwoxC50SjEab8sgkrPK8qLIDQpGqTEkvDgZamEr2yYUB7zNgMKx/Ps1S0RI4J+K4IMbAFpw9RmDXFhF95lbdQewQEjZy7Ie8QkA9+34udDc/ktfcis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548060; c=relaxed/simple;
	bh=QerjX+8U+TQ+031BP+KUla1r0fMTJSFcD5Nx2imwnNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REmOAnpigCEiUC8zFdwFaIRFJQmMKCIWjjDnYIwx6mnikt+AHntJfZbI8Vsc7KyYAdSCWnStS5FDtGfrxJP1GlEnVQdEGrIf320OAXp15qx80NSwqnrKClwd2Q1zvZmCvuSkgyOCNK8CYEgW+tPA3NwwnKlZmWfXq7CH5M7pcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smodkWWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smodkWWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C91C43390;
	Mon, 29 Jan 2024 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548059;
	bh=QerjX+8U+TQ+031BP+KUla1r0fMTJSFcD5Nx2imwnNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smodkWWN1NpypAHDvwY0b621vWX69Y18K6vPIUcC2nzBWpZ9hCO5dND3k32kDBmP7
	 Rwna6V/Qaj4IfQ3sO9P3iim72B9N3mrtlWSfjeg/oHtkiC2F1Ka4itIg3WVVDyBz5D
	 A0NYv6hAEl1PUHd5pobIldi6FUBejSNe/4KZT2sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.7 065/346] ARM: dts: imx6q-apalis: add can power-up delay on ixora board
Date: Mon, 29 Jan 2024 09:01:36 -0800
Message-ID: <20240129170018.301662023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

commit b76bbf835d8945080b22b52fc1e6f41cde06865d upstream.

Newer variants of Ixora boards require a power-up delay when powering up
the CAN transceiver of up to 1ms.

Cc: stable@vger.kernel.org
Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.2.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.2.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-apalis-ixora-v1.2.dts
@@ -76,6 +76,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_enable_can1_power>;
 		regulator-name = "can1_supply";
+		startup-delay-us = <1000>;
 	};
 
 	reg_can2_supply: regulator-can2-supply {
@@ -85,6 +86,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_enable_can2_power>;
 		regulator-name = "can2_supply";
+		startup-delay-us = <1000>;
 	};
 };
 


