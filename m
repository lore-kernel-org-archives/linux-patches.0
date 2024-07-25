Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003EE19D074;
	Thu, 25 Jul 2024 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918349; cv=none; b=NERlCdFxJtLrI88k+gUp5q4RhBW+mHV37tHmyExZHJA3OVZsEMFiHXGo9+FnN/2YvkbA+ekoK2w1I5J4VMJXlgRK9dpy7P5tH6LOEkdFi8M+WOwYlVBP3+LQCd6xMA/77Rs/RasYFipf5WeK8uFqANIf3/1NOeLEG48FvwXQuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918349; c=relaxed/simple;
	bh=WqBhsSJ6/TUzuSFEQYVtMziW2Mrr3H3Pjki7uhIn53k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGac1Hh5QRqmu89EtF13ZpDISDsSaCECkZ5yNVzswjAYcDZmju/4ROhsF7OZrhIpviF7i6cLqSTTyj9KyStw4HWv3vRXdHk7Bh2+oerhW4OWtjm5e72SqdTn5nfU99s6l7EFoDxuhK6NEsPodXpSop54Rec/KDFKAMSc1z362K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRdUV+sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRdUV+sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2BCC116B1;
	Thu, 25 Jul 2024 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918348;
	bh=WqBhsSJ6/TUzuSFEQYVtMziW2Mrr3H3Pjki7uhIn53k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRdUV+sf1P53cmAYvUfU14TnZv8UX5juI01Q5CtqNkIKUMFnLVW080WXVfJ77vQXp
	 HhXT+V/cLwokF8zMiQbPXxPPaq6Dx00v5w2H3sPh99VCHmTeqC0HsAIO52CSpdxaPH
	 u8k0cTSu08M0qr3vGjraQHQaVfMrxvxZ4F2BDU9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 22/29] arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB
Date: Thu, 25 Jul 2024 16:36:38 +0200
Message-ID: <20240725142732.651958450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,6 +685,7 @@
 				clocks = <&xo>;
 				clock-names = "ref";
 				tx-fifo-resize;
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;


