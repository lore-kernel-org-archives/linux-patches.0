Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25091243367;
	Tue, 20 May 2025 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750274; cv=none; b=VdxKmLLol+KZs5jBYIsIK8ECBVd01VP4A9fucEf3EGMMueRfX2TYWIMo6Cgagfb3yAqCoDI1OxWWVRmVf5IyUhwQCS7o6x0hGBQtoFOEI4JAWGGlIqnoq+FT16yvpHM0YvFndhTTnjuypZgrTMccyPwASZP7EyZlYTarbUIKjzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750274; c=relaxed/simple;
	bh=vtMkNj/Fj9lmumaRcDCVz5C+bPzfUPHBfo89OOxoYRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SaUyqwviF8Lh3pNWmgm7e/LZekmxoMCT053qte/MxQP7Uwvoaj28HVr8cDKAA5/Bx7npdNxawsPJEa7mHa9s3/L7sHILUxlXcmbXjStDHz3vtEmfB0vc0DJaW27m8BZXtpuvcI6LGVQ8iAMsHETCdskxZH2PKmjyB1S9IAEE0dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVFJRbpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVFJRbpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF64C4CEE9;
	Tue, 20 May 2025 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750274;
	bh=vtMkNj/Fj9lmumaRcDCVz5C+bPzfUPHBfo89OOxoYRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVFJRbpf+/G9rpueIiwCGI7ou1jtFpHfphbTj31lZDyqoIFa4NXnEgC2nlIzDUBeq
	 igTiVI0/hp5Rj/oa0cbyWNc+FPqx6YZmVaQoZHc1J3V1bW0Hr/0+I3zhTVw0fbEtP9
	 ZQZl0MO+Uf2YT+3rn4w87UobDFY2ASmzdDwsCDM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuel Strobel <emanuel.strobel@yahoo.com>,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 098/143] arm64: dts: amlogic: dreambox: fix missing clkc_audio node
Date: Tue, 20 May 2025 15:50:53 +0200
Message-ID: <20250520125813.908512874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


