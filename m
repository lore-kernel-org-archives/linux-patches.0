Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3622D794;
	Tue, 20 May 2025 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750696; cv=none; b=bBREZn1R20cEXirMICS2HwoFqDlhWytzhoQ0bgnQocsX1ejmc0Q0/GzxOfPNne95PexgDc8SygXDmfttQo3XtFQLYlgFhT9ZVoSn71au+KtZQvnex2g2itQz12ZFlGU38TlyVYPmwFppqsve1D+STXY+IcHQqGwifgFZBBxmi0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750696; c=relaxed/simple;
	bh=W5KzE1JBc2kYp0JLfjyfcjS2H5+gmIa9925Whicv0zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5d41+hoq/D28KHS+wdeY60AhejuOx0IdSF6e9QwFKSyDPU0E4SspxHW1FWMx1dWU3YqSwdB4a9s61MHE3tDbA5W0abAYAixNoCbsMsOsLk9XAkwLkRwX3ujGITnRBxi+FMqU824zN1+a4nqSUz2dE59Ja62iELDEkjIccW9WDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVBzlp5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVBzlp5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD619C4CEE9;
	Tue, 20 May 2025 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750696;
	bh=W5KzE1JBc2kYp0JLfjyfcjS2H5+gmIa9925Whicv0zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVBzlp5fJ+mhbNSQUNnSSkFM/7ng/pHVMqz4V8S8snBbcISy0aGkAwYUEJMqPHbSU
	 5gysj4mo4fIfagJ76eVsVhT6wrfl6XyU6+Vb7obpvgX9qdT7BtVYIdth/evSsYCW8m
	 kenbBqbNYgxQMYyVO250Hb4KmVg30Ev2JBSdmP2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuel Strobel <emanuel.strobel@yahoo.com>,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.14 092/145] arm64: dts: amlogic: dreambox: fix missing clkc_audio node
Date: Tue, 20 May 2025 15:51:02 +0200
Message-ID: <20250520125814.170308947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hewitt <christianshewitt@gmail.com>

commit 0f67578587bb9e5a8eecfcdf6b8a501b5bd90526 upstream.

Add the clkc_audio node to fix audio support on Dreambox One/Two.

Fixes: 83a6f4c62cb1 ("arm64: dts: meson: add initial support for Dreambox One/Two")
CC: stable@vger.kernel.org
Suggested-by: Emanuel Strobel <emanuel.strobel@yahoo.com>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250503084443.3704866-1-christianshewitt@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-dreambox.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/amlogic/meson-g12b-dreambox.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-dreambox.dtsi
@@ -116,6 +116,10 @@
 	status = "okay";
 };
 
+&clkc_audio {
+	status = "okay";
+};
+
 &frddr_a {
 	status = "okay";
 };


