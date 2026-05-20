Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BCB33AD9D;
	Wed, 20 May 2026 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295680; cv=none; b=ldEQ4rKM1zZjwu30KXTlWT3zT2YyW8bXAaTXoubTmUh/3GecPmnXV5CBt0lPLTsw400a3TjTlleDaqeYq5eHkJ0Hd8QC6uo+c1lzjVC/7HzyR7ez4LGbTwTU0UmS0QsiMQlYqGQahM6IfcPa4JyC+2OCMRwei84mW4MlFQ+2N5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295680; c=relaxed/simple;
	bh=4vclIiERaYaBX+JerPAoImHgeWCR4mztMKJhXPglm9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvMlscywl9pM9Qh1xK/OHKjNqtS/mLeLPqAHzry6iZFSyNrda5xafevvcMgsM3dlUHBcnmzMzHapHSH1eYkel3hiZa1NfFsDKbL6rE4VdGrSNuhvAhjSDzA1obmx0UE8Pg2QvpqVr/m7F0Fbf/J1xVL8OpSk3RHEv6IYDRfzP6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzRO74mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzRO74mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39621F000E9;
	Wed, 20 May 2026 16:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295679;
	bh=wuvLG8WPnpJ4Iv7vI+PlM6P/xJmmYe0u9YThyeEUeA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzRO74mLsbKOiA7o2sWHDhs2xlNUD6Dz6t38u+UsFw+BmgI6uZVBTapr/ThDyCPFc
	 bAE3F2K9evbZr1jMouTYBUtiFayd12utl2CT81aPHTrrC7LbeKQySYW9AVJHG47CVZ
	 vajmQJjh8sQrlSJdktJgqseDiTv103hBQfikstfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Heider <tobias.heider@canonical.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0510/1146] arm64: dts: qcom: add missing denali-oled.dtb to Makefile
Date: Wed, 20 May 2026 18:12:40 +0200
Message-ID: <20260520162159.727366790@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Heider <tobias.heider@canonical.com>

[ Upstream commit 9ffb2dfcc955faa5072cf8de547ae5909544fdad ]

The DeviceTree for the OLED variant of the Microsoft Surface Pro 11th
Edition was originally added in commit '0d72ccaa1e84 ("arm64: dts: qcom:
Add support for X1-based Surface Pro 11")'. The original patch on the
mailing list also added the new device tree to the Makefile but that
part seems to have been dropped (by accident) when it got merged.

Signed-off-by: Tobias Heider <tobias.heider@canonical.com>
Fixes: 0d72ccaa1e84 ("arm64: dts: qcom: Add support for X1-based Surface Pro 11")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260226140429.232544-3-tobias.heider@canonical.com
[bjorn: Rewrote commit message reference to offending commit]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/Makefile b/arch/arm64/boot/dts/qcom/Makefile
index f80b5d9cf1e80..b05e8adc02f65 100644
--- a/arch/arm64/boot/dts/qcom/Makefile
+++ b/arch/arm64/boot/dts/qcom/Makefile
@@ -374,6 +374,8 @@ x1e80100-lenovo-yoga-slim7x-el2-dtbs	:= x1e80100-lenovo-yoga-slim7x.dtb x1-el2.d
 dtb-$(CONFIG_ARCH_QCOM)	+= x1e80100-lenovo-yoga-slim7x.dtb x1e80100-lenovo-yoga-slim7x-el2.dtb
 x1e80100-medion-sprchrgd-14-s1-el2-dtbs	:= x1e80100-medion-sprchrgd-14-s1.dtb x1-el2.dtbo
 dtb-$(CONFIG_ARCH_QCOM)	+= x1e80100-medion-sprchrgd-14-s1.dtb x1e80100-medion-sprchrgd-14-s1-el2.dtb
+x1e80100-microsoft-denali-oled-el2-dtbs	:= x1e80100-microsoft-denali-oled.dtb x1-el2.dtbo
+dtb-$(CONFIG_ARCH_QCOM)	+= x1e80100-microsoft-denali-oled.dtb x1e80100-microsoft-denali-oled-el2.dtb
 x1e80100-microsoft-romulus13-el2-dtbs	:= x1e80100-microsoft-romulus13.dtb x1-el2.dtbo
 dtb-$(CONFIG_ARCH_QCOM)	+= x1e80100-microsoft-romulus13.dtb x1e80100-microsoft-romulus13-el2.dtb
 x1e80100-microsoft-romulus15-el2-dtbs	:= x1e80100-microsoft-romulus15.dtb x1-el2.dtbo
-- 
2.53.0



