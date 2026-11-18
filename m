Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058442;
	b=HmUuZ77240kYGSXIDFPFKaWtclXcxvDYikxh0Uggj+gArRw2H4+JeaNBC36z3w0BIniv
	 pzPHsjbSpNqjqJG4X0SE1bhCCDOhR+xE9XXgp+lo4xZLf2TI2H4QsNXFtoPknyL0Or1S0
	 cj9ZXRkYxnB/f2GrkRwtx2jshWmLvwkkjbAdhFPSwRXJwCbwc1EWNEMdoawvCFjyz6dcM
	 hY4hp84jUkE66HJWQ3lgXt/NsJ5FpQF97/SwfDjnBI4UWaCSVNVuK4nWaoXZJCS8DjTcg
	 eMcpCQgBMEiEyLbsoezzJcJdX0JA0irXlYHMaP8LY00/75XQXImXZJpj8jKis33+U4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyxcBTexnKW+v/E9fZ3pNzVOLTxzns8/yoIBWl7hGKk=;
	b=lfcf6UTFxSGdtNdDeGiYsaIyn7gOi7of3uTUCLwZL3Uu8noWriEPWrA1HhrcIS/9t5vS
	 QISOTWszZbBq2BlDh92LWErZOJ+84FmK/NsvVcpHMYKmZvO9Jd/BvnHsFQm7w/9LFPbQu
	 Imcvhk5QePPEslrVdXhlGDN4H0anQitHEpGNp9oLkzgyD/8ryOfTDs0ByojE5D0NPpqrZ
	 HjXcBxtZDDZHCWns6f1mm9N5kyi9+JkGumwAFmS4EOk3VpUthnUTsvbemcwUNObbBGbsc
	 U4UY+fXvKeRafnsnbqWovdSvkRfYV0B0a3nr1/tjzyNrsdY15juiFq14FOp9jxpX9tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgZJ6giy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B210F606A32F;
	Thu, 19 Nov 2026 03:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgZJ6giy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA2A1F000C5;
	Thu, 19 Nov 2026 03:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058442;
	bh=xyxcBTexnKW+v/E9fZ3pNzVOLTxzns8/yoIBWl7hGKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgZJ6giyVb2Kc/cm+cbr2xwZwxuhn+pw22MSW1ibv/Cl7Hm//o2WswI/DsyNEP6YB
	 iN8GCG/XfWiUlx/Aiw3ukf9SLxUbsUsQBoDp8bjqn5sAJc+WjUSTHC+0ZXVSky3RMe
	 xFWgCsmhY4MiGtFxQ2yh4GH1YHNEKKUoeJNDx+Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0445/1848] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:41:23 +0100
Message-ID: <20261118145932.910304373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index b38b3bcdf429e..204d293d3c3b4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -23,6 +23,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Pocophone F1";
@@ -52,6 +53,11 @@ vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



