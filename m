Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BB61411C5;
	Thu, 13 Jun 2024 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282978; cv=none; b=NO0GXfBx6FEWzLzeSsF4wRLUjbVwauprsYIqq4bvCNtkfTOn73soFiyEIKdLQ+ViyO64zf2vaf9nnk9ioiTozmTb2cEQ2/nMOR1N33nZJLP3aFzuax9GlYQGiYi3zLNUGEdCeY6qppyXKEn1PkDkkywJoaNLKjMibMoIVP6r93E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282978; c=relaxed/simple;
	bh=J3gUgx+4FOHI7ID1St26qem7HSw0hmbru8TnJx542qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND++OaMvxVUL/V16L3ODn6oSWa3WMhganySBLn3PTK+QWK6aVgcuUA3zr0mWGTClsdEwFe5HImUDrZJbrwpeWcpRLP3UtmGBcob4862SFb4zZbwXXKeCKySrbvZfwMfENAeRn9YBfWFkYNXheOScNQrGI/WvCa7TSxFQanjJULI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MejG78/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MejG78/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B9CC2BBFC;
	Thu, 13 Jun 2024 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282978;
	bh=J3gUgx+4FOHI7ID1St26qem7HSw0hmbru8TnJx542qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MejG78/XQgiyepH4tb4LBPemg98xoixSNqFUhh3rSgpgs5E5y8BQCihEkKDKlfHpv
	 Uty3ce8EZOuZzriiHdSYbga4WC6iwbgAxpTu0hQ0GYRDZOQTfYZ9ShFrVENoqOMc8g
	 XhKIXo4WZZZoY9a6L/EF/S90vGZ7ShATfVo1//wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 26/85] arm64: dts: qcom: qcs404: fix bluetooth device address
Date: Thu, 13 Jun 2024 13:35:24 +0200
Message-ID: <20240613113215.150487700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit f5f390a77f18eaeb2c93211a1b7c5e66b5acd423 upstream.

The 'local-bd-address' property is used to pass a unique Bluetooth
device address from the boot firmware to the kernel and should otherwise
be left unset so that the OS can prevent the controller from being used
until a valid address has been provided through some other means (e.g.
using btmgmt).

Fixes: 60f77ae7d1c1 ("arm64: dts: qcom: qcs404-evb: Enable uart3 and add Bluetooth")
Cc: stable@vger.kernel.org	# 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20240501075201.4732-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -60,7 +60,7 @@
 		vddrf-supply = <&vreg_l1_1p3>;
 		vddch0-supply = <&vdd_ch0_3p3>;
 
-		local-bd-address = [ 02 00 00 00 5a ad ];
+		local-bd-address = [ 00 00 00 00 00 00 ];
 
 		max-speed = <3200000>;
 	};


