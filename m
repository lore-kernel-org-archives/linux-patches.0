Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5424D6F06C;
	Mon, 29 Jan 2024 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548459; cv=none; b=KqI0cS6SzJA7hEOU0uKtCPqy1z8BYKebRC3NmTspY82xiRRnsmuGbNmGO2yVTFw7x4nfV485fwGvz/Mh9ecB2vBCZ6/2+VveSx2kZb21y9m+DebXlF80/dU0tpq9CAqRYXa1Gw4imUP53yF5fS3XIiCR5U/RNyxpw2XGyRP4/aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548459; c=relaxed/simple;
	bh=bETKP+miETJp7o9GuqmoY/wZnE6fdMW97skATo0GuG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt05uSB6cj7KWjpEml4QqUDuY33/WlLiSCGV52fftqpSD6BPNLLzqGaxel+C3IxrMCWbhXBCKsOlt4KTKB69MFX3Ize4COK8sfhzOK+draXZCCUe0z4pYEvMaSj65mNbHS7UujPtz3zbC9HaBMWxZvm/R4e1SkV+6Vx6e3xabWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsQ/loSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsQ/loSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE4BC433F1;
	Mon, 29 Jan 2024 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548459;
	bh=bETKP+miETJp7o9GuqmoY/wZnE6fdMW97skATo0GuG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsQ/loSK8JujqhrAS/2OMiRRUVmuuMC2K8C5rj4QomAIc/D9WqZegXQXlF+HkKt/a
	 G8cnzeRflSxWAzHOQQYhwGjdErD3hIBz0qIIH9DeutVN2r1oWyq84a8UERw5KWYV1D
	 b12dpaimRHdkzYBabFwsT6RYajX483L0JoshWI3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 072/331] ARM: dts: imx6q-apalis: add can power-up delay on ixora board
Date: Mon, 29 Jan 2024 09:02:16 -0800
Message-ID: <20240129170017.030619314@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
 


