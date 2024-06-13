Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C471411DA;
	Thu, 13 Jun 2024 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282684; cv=none; b=D6H6H6GN7pK3GpJP+Z0y+1DaO8SYzv/A0/NzqkK8XWcBZyKJzyf6tEvDMWCqxkK5Q+KsU8xipKcCKRxI5Degx9Y94QRvldhuAVfU33Q/1p+mqsAlnNHOZwld4MIQvnHpNH37bsBaRkYrxDtlQfXNfzxetjtRucCGgEofYyT2JQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282684; c=relaxed/simple;
	bh=IwAJni5htv0cSBYrhLvV9ojo59McoMiMmnMQgYoPT98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgcStjL36/9ydxc44cgc3lajeOzngB15tmC8+1WmhoCeD7LIDYT68zQKhOoYEwRc8KytAW6NUV6JKTe+5ZjBff1xblpr+UQYVTEEPu7FPPuvRQOMT65NHjcBHHZynBsE2kXabqToecb34E5ZulzCO6IjSCNDmXQFoK23Q79zA8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au+mkPjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au+mkPjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CF7C2BBFC;
	Thu, 13 Jun 2024 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282684;
	bh=IwAJni5htv0cSBYrhLvV9ojo59McoMiMmnMQgYoPT98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au+mkPjqi7phKCj5xkHJWds3bJbZLHMC+Be2gLx4sW46s9qMX1S+Bf17fPdQXAdyA
	 0pxkf0WFYmJbBLUi27NrYkzhJr8hOBDDK/n53nFZ9q8kNpYQjph++iuCc36bSMJx29
	 OPmDPKLsh0eL+r0i76/eHZ2sCdbBQPlMFL3QVVwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 361/402] arm64: dts: qcom: qcs404: fix bluetooth device address
Date: Thu, 13 Jun 2024 13:35:18 +0200
Message-ID: <20240613113316.218256189@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


