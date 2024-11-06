Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0121DFD9D;
	Wed,  6 Nov 2024 12:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896483; cv=none; b=lcYtjbsA9khAk3WF4hXLgCemDrwfUVZCNy74unfmPtltfs+JNNSgPLaHSqnJUwwGPe94woAV70Ia2PuFJh931nJxPSbNoQ4mTl6BE51nsbv/G6cdQkdaeMj3ogiOmEL5I1xiWhnipgE99glSVYFwk6gnoEmZ1LSENXrW3X3cHS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896483; c=relaxed/simple;
	bh=RVaVfb/SJpjdmCKrsFJu6zrTGBWgW9UL7AMJrvF0jxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErWYDkMAIzQWywFVf9BIGPl6UFPMO81olaokp8woumVsUf4KXn+QaLLxCJdIJHBQo9yTebbswiviZU7wsS5Hybi1hLN+mQgal/aFryXuh68XgVDIKhMUj8UgOTMAZjTtiH1eBlwxTyrpwDfFUxq/EY92C7kCvkWBjwBMh8a1l8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cD1Ipra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cD1Ipra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245C6C4CED5;
	Wed,  6 Nov 2024 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896483;
	bh=RVaVfb/SJpjdmCKrsFJu6zrTGBWgW9UL7AMJrvF0jxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cD1Ipra7d7TGcE3fyD3dMuAot4wn2RAkWvUkykGxFfXVq6gNEV7tZQfalcjDxjIC
	 L6xs8gUuO97F1TJAiK0rHA3t0Q4KEjzJunhcIR775TkZM0Jz4OhOh80BBZzRCp5sFQ
	 mISHDCnfL7O9u/wDLY4Qc04/Bayza+rHhwtTpBfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 217/245] arm64: dts: qcom: x1e80100-crd: fix nvme regulator boot glitch
Date: Wed,  6 Nov 2024 13:04:30 +0100
Message-ID: <20241106120324.596592350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 37f9477ce9d07ed87f6efe9b99de580bc9d27df5 upstream.

The NVMe regulator has been left enabled by the boot firmware. Mark it
as such to avoid disabling the regulator temporarily during boot.

Fixes: eb57cbe730d1 ("arm64: dts: qcom: x1e80100: Describe the PCIe 6a resources")
Cc: stable@vger.kernel.org	# 6.11
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016145112.24785-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -283,6 +283,8 @@
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&nvme_reg_en>;
+
+		regulator-boot-on;
 	};
 };
 


