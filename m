Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C03221299;
	Mon,  2 Jun 2025 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872090; cv=none; b=OknZZWzE41zgHG8Sye57FGzKYYNi8Fzdd070OIcievYnv793BNH/SEDoOf/KeJcC7ace83c6pPOiw8h45W5lXaXYoZixNR1hJo2Gwj6S7NUweRnF+wwP9GniwlwXXFi5XSHH2ICAgJbsHmMP+Q7pkozbWvuy4v57zJPFii3Kh7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872090; c=relaxed/simple;
	bh=FJ4ma42pt3PqDZX2mj7HKngjWt1XaP6B44eZ9Sm8n38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqDIYjXf1zc1nfJi0DEkb0HzafvDy1UBsy97zu3NQ/k1UPDUyvnn4dB+ArN1AX0T4fwR9je4iJgxEtA2NkDTjUN39KerJVgk9+DCLPXl5ZNsI/++MIrginSHDhsf6rQ6kXbRmug36Rqi3GnkyqfUxZXiGxoRa8H1rBC9BOjvwSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgJFPNqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgJFPNqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59739C4CEEB;
	Mon,  2 Jun 2025 13:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872089;
	bh=FJ4ma42pt3PqDZX2mj7HKngjWt1XaP6B44eZ9Sm8n38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgJFPNqgVW7oh+NkU0LOiv1EjJKZE3FWa8E6AzXaY6jXETE+X84SlNwseJcn+g3WN
	 40Qe1PCFcDz8tCmA9jb+7LbW4a/XqVa5E4uWD6Sb22GlDFVHGGQIQtuCHP9NKs+HdT
	 W19IgNXM250RtDCqlCZyAm9RXAsPi2axevYtzSF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 15/49] arm64: dts: qcom: x1e80100-dell-xps13-9345: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:07 +0200
Message-ID: <20250602134238.546056391@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 63169c07d74031c5e10a9f91229dabade880cf0f upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Note that these supplies currently have no consumers described in
mainline.

Fixes: f5b788d0e8cd ("arm64: dts: qcom: Add support for X1-based Dell XPS 13 9345")
Cc: stable@vger.kernel.org	# 6.13
Reviewed-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Tested-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
@@ -359,6 +359,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -380,6 +381,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l17b_2p5: ldo17 {


