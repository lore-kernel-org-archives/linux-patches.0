Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF02194137;
	Wed,  5 Feb 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767603; cv=none; b=dA3NkWjW0g7M75tajQ/nVWUf9ALSCpxGMnwDcy5/s/sdsZWAEKCoNlcuolvaG/nit6OU9nDN2g8QQc5CwHuSze6FQCP86V+T7YAt0Q5ef8IKeJTwfrEugTPG10vK4QBHgcNfdF9b93pjWawIkC68D3E08XmBQz+VD+cSOhQcZu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767603; c=relaxed/simple;
	bh=0UcKgr6DlLY11l1p6y4tOY29D1hNhYPpMJh38Q61EQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1TLUqA0rVN2ZcKO9olZp+Zkqza/V6VD2FrQN5ZbRBqoWPa9zxbi+x54tb4beH8HM6s6xbg/Cjy6S+WgccfZb8Pw6YFOSy2Shx0NjC0WSpgWmLPbNuNXt0hFfQFB8VFcIM6rcDpiaYg1i4B9/2rJE6G7muiBsNYHW5iy2inGyxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/HoHg+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/HoHg+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F1AC4CED6;
	Wed,  5 Feb 2025 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767603;
	bh=0UcKgr6DlLY11l1p6y4tOY29D1hNhYPpMJh38Q61EQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/HoHg+zotclTztMuGbbDk155Dhq/zfAbPgSMjaZfui+VhE5UPmWAwbCytpicRDp3
	 V0cbqwaqFMTLFsShcgX77N9iTZ4wU4YjhAHOjcVIcA+GEdaZTjCrdohqTrnUu+SkEb
	 kFgdbqfYiztple0wrseRzA+ZO8xvPXssi3onQ60Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 427/623] arm64: dts: qcom: x1e80100-romulus: Update firmware nodes
Date: Wed,  5 Feb 2025 14:42:49 +0100
Message-ID: <20250205134512.558018216@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 983833061d9599a534e44fd6d335080d1a0ba985 ]

Other x1e machines use _dtbs.elf for these firmwares, which matches the
filenames shipped by Windows.

Fixes: 09d77be56093 ("arm64: dts: qcom: Add support for X1-based Surface Laptop 7 devices")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250108124500.44011-1-joel@jms.id.au
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
index 6835fdeef3aec..8761874dc2f06 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-microsoft-romulus.dtsi
@@ -706,14 +706,14 @@
 
 &remoteproc_adsp {
 	firmware-name = "qcom/x1e80100/microsoft/Romulus/qcadsp8380.mbn",
-			"qcom/x1e80100/microsoft/Romulus/adsp_dtb.mbn";
+			"qcom/x1e80100/microsoft/Romulus/adsp_dtbs.elf";
 
 	status = "okay";
 };
 
 &remoteproc_cdsp {
 	firmware-name = "qcom/x1e80100/microsoft/Romulus/qccdsp8380.mbn",
-			"qcom/x1e80100/microsoft/Romulus/cdsp_dtb.mbn";
+			"qcom/x1e80100/microsoft/Romulus/cdsp_dtbs.elf";
 
 	status = "okay";
 };
-- 
2.39.5



