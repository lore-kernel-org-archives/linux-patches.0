Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA0F519;
	Thu, 25 Jul 2024 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919039; cv=none; b=eL4VM+SGGqTAAPF1f+gjXihJXckVq5Ke2vHtJNj2dS3NFO9ti7JWkxTxk6nI/R3NSvxtWKtISSTRFxohGktvbu9sylc34HIjvt8/AmMUJejSNha8YYCTuTHWh7k/dRzJQWjfFzCsmBzoRwSdQazBM8idWXohmSsbra0hExQKlYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919039; c=relaxed/simple;
	bh=oal0zMwF/3MZ6HgWQpyLcJwdtaP4L+0F+XLugiOaGkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWjUIl/hu6XlkugX5OpSdSkGLQMKJ2FhmRChVbnRLuJr42klObIGfBjovI2BeMjkbsnH5b7IGjbsS/TMmutgWdGM2QskqcP85TIKm1WKGG55yB4q+XL9AyKDBomNqBhFOctC3aFaxWZ3SwkUhJ+GagkVWCDvfbgUIRZQETdf0Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Azc/i3Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Azc/i3Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A4C116B1;
	Thu, 25 Jul 2024 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919038;
	bh=oal0zMwF/3MZ6HgWQpyLcJwdtaP4L+0F+XLugiOaGkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Azc/i3QnQikD4oDO9sIiAG9sm7YzUgZWol5ocS5yZEwXHEUXsLCz0EQIS2zNzjo02
	 fbsfapVjWsUSUc3WSyrHyv07wAwC2JSkbGlVpgw9wJ0/bSTQ1Z/EpyOPGSL0ATtaxh
	 3d9lgm/uyvfMmJpVIbSwCSE+WrchhjwWAZ0EcJ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 57/59] arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:47 +0200
Message-ID: <20240725142735.409997420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 44ea1ae3cf95db97e10d6ce17527948121f1dd4b upstream.

For Gen-1 targets like MSM8996, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for MSM8996 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 1e39255ed29d ("arm64: dts: msm8996: Add device node for qcom,dwc3")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-8-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1796,6 +1796,7 @@
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
 				snps,is-utmi-l1-suspend;
+				snps,parkmode-disable-ss-quirk;
 				tx-fifo-resize;
 			};
 		};


