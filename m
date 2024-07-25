Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7368468;
	Thu, 25 Jul 2024 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918747; cv=none; b=ltQ8qRUk6uWFzalWQURx63CZrhKbFgFV5cUeGqZDiPgkUsQKvCLSfenw1YO91Qvvc7+mHl2PpAdlGhF9L5SbGVQ99o3Uu0KVQARMNd0FzRN1kXsnsm7Rnfo0FNYK21euMzMUnGmNm8N26G5HLEkwE2OY9BXHSPq1bwMD/jgI5hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918747; c=relaxed/simple;
	bh=lnguMXchgzAt07WoGtEhMN0vhfHIK3jWwkl0wvinrWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxYwP7YB8wp+3N0k5JLmW6n1wfNeuFPtlPBN8+XofnadVB3vChO1PttQ+pwdKUaeTUfjQcHJE9EwJrQuj/uEJ26M9egBckfVMJCYVExfh2KteoPeyOEK89bxoRCvcjJUWdICN2K+IQnSxTkbiRmrI+P+ECs/IZMiOTSkb5MD5VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9z+4taE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9z+4taE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F94C116B1;
	Thu, 25 Jul 2024 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918747;
	bh=lnguMXchgzAt07WoGtEhMN0vhfHIK3jWwkl0wvinrWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9z+4taEAd9nPRueiaTk46NcSRpa16PpRJDM6XVWm99dJils+eWQW4z9WU1BzPrJX
	 hdzISyhSh2QcDjcKtxE4smgQJdxv0OLv95JAeMcayqxx1GzU+3Fz/cYS0MxwsnrhHn
	 7IaeQBXFVGySnPcTj73uWa5AjwVgdw1Xec6pFnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 10/16] arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:37:23 +0200
Message-ID: <20240725142729.292177176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
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
@@ -3082,6 +3082,7 @@
 				snps,dis_u2_susphy_quirk;
 				snps,dis_enblslpm_quirk;
 				snps,is-utmi-l1-suspend;
+				snps,parkmode-disable-ss-quirk;
 				tx-fifo-resize;
 			};
 		};


