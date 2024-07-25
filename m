Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB7319B5AA;
	Thu, 25 Jul 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918686; cv=none; b=Cuy9EkGuNei6GCfoSthRsCsdL04ihTUehk+hyjAXDQ74a20EYdBUd2l1qi3SK4l4vBQPrimV2TDphnmRpaqh+1iMAXakcCWfTystRBksGO/MLisL7yghhOMSjUkspcQHHKYR9xr1sIp+K3BXFlEoHF2YzGv6rEAeSYLlYImrDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918686; c=relaxed/simple;
	bh=xFBXnuRL0cRkumiQQ5IutBzXld4/ZphVEE1kyUwn9xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDY2YF3f62BbmCKAeaiq0wvBqMiHX/I4NyFayheDSprOp4zaKIiG5ARdAJtvvLdr1s8bXjDQj6WHDMXx/RM9LKLQdPJdMeSJhLkNVoRJspSnj28m1KNjeDPgwv1acL6JfpkwG1rTvHCNUb0dgxkPdTfR3Y6tKiqR+L0D8jhlkFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYvmRDq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYvmRDq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40664C116B1;
	Thu, 25 Jul 2024 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918686;
	bh=xFBXnuRL0cRkumiQQ5IutBzXld4/ZphVEE1kyUwn9xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYvmRDq9Bqma2vInBgQgEURnMEaZh0iYgBqg0YgAYmUPQ+R+o4zlOsumdkm3TGq2j
	 ajCRMHtibAIyv3WyaZCsUTL9w5O4RagRWgROLb58jzC/9KVoyZwYQ9MDKnPkPgB1wR
	 e8vKDvogFYsWTcu5fDgGS8coN/x/Umy7dcL/BQfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 09/13] arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:18 +0200
Message-ID: <20240725142728.391246071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 4ae4837871ee8c8b055cf8131f65d31ee4208fa0 upstream.

For Gen-1 targets like IPQ6018, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for IPQ6018 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 20bb9e3dd2e4 ("arm64: dts: qcom: ipq6018: add usb3 DT description")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-2-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -760,6 +760,7 @@
 				clocks = <&xo>;
 				clock-names = "ref";
 				tx-fifo-resize;
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;


