Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285A221703;
	Mon,  2 Jun 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872127; cv=none; b=rI2OY3thsE6+w7vzN9nfegLvZVstwu+AXfREyOKDpxiO3agEcJYfsaQMC+cEgZxiBPZUPI8sLWKoYEptQUnRX1wZbqUqAr2uS5rvM5adThSHMND7L/U0Dg86JOYSbI3QntqL/FULSEwSPXKLtyNrV04GlEP/NmS75248VBckQF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872127; c=relaxed/simple;
	bh=o1aWCSxxDrzdAywVUrXi65tHr6mVpzs0fozshchRvoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqaQEQhF/M4P3xS5BiRUp6S8ZtnR6jz4JhweEi9bfgPa6G/x0X7zMh8Nsa0DnxKvIUJPaKWBPq2zgBVUV35ZAK0T//6mYJBe82uQHX2o5gJGc5onO9xTik9kvk0cwUqjKELf+nUxBksQ3F7OvorI8u0pdq2voEUZOEHVAA+dOWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnk9Ucpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnk9Ucpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C518C4CEEB;
	Mon,  2 Jun 2025 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872126;
	bh=o1aWCSxxDrzdAywVUrXi65tHr6mVpzs0fozshchRvoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnk9Ucpw/obLN25VCEfgqEZ0IqDNlQDwqKLW4SyIffxSr9jVEhEEDG8IH9QO9SznP
	 N23vjSe+Cw8fTuRcJuurI8JVikG4vFIe8SMc/5u0tQXO4Uhr8dlNPlNoUO5NhkrJ0f
	 TlMGrBOrezewG1LtZdQbhs6GCMyenKCJ8VX2fT7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 26/49] arm64: dts: qcom: x1e80100: Fix PCIe 3rd controller DBI size
Date: Mon,  2 Jun 2025 15:47:18 +0200
Message-ID: <20250602134238.973217047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 181faec4cc9d90dad0ec7f7c8124269c0ba2e107 upstream.

According to documentation, the DBI range size is 0xf20. So fix it.

Cc: stable@vger.kernel.org # 6.14
Fixes: f8af195beeb0 ("arm64: dts: qcom: x1e80100: Add support for PCIe3 on x1e80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250422-x1e80100-dts-fix-pcie3-dbi-size-v1-1-c197701fd7e4@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -3126,7 +3126,7 @@
 			device_type = "pci";
 			compatible = "qcom,pcie-x1e80100";
 			reg = <0x0 0x01bd0000 0x0 0x3000>,
-			      <0x0 0x78000000 0x0 0xf1d>,
+			      <0x0 0x78000000 0x0 0xf20>,
 			      <0x0 0x78000f40 0x0 0xa8>,
 			      <0x0 0x78001000 0x0 0x1000>,
 			      <0x0 0x78100000 0x0 0x100000>,


