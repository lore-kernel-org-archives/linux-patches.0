Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064388;
	b=bx9HlYg//toqZ+ULJorB8XqplHvvkaBEHrEu9jiBfuRJvsD8g/AT+DM/IRR/+DcVLhYQ
	 6oQlo2kqlh/mMwWeQOCPyFXN0lcKuYri3EbPOkcZVTvuxI1oC3dWSg3Z3wPTrSKtB5ori
	 M26iDDYRFJ8NguyGEMFosdVYFrLQFwCrwMOR6gDV1M7pM8seFyIxmpW+Hi8QG/rDP3Rgw
	 GzShzDW2tfYBgRYtTl0zZDa6X8aN+9hc8uFMlkZr3RuY4LHCXx0tZLhD4J/jMwwwUmL5k
	 Kbb5C6xi7hc17H/X787+1vKoSu436cHcTSEmJt2aQJXirc7tDdEIM0frNdJhkGCnoRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uzsOzNxgz1AT2QOz6/BjOp2Rm5BTT4QCjr8LsCbNpU=;
	b=I/xS0ga+YqP3BzVSnxslavn0gfTigxx8MDlNPpx256zWxVTfCuc/SWP+uu5Lncey1ENF
	 2VQu+Utd1uTVjb4UoyIrp7evVIu2NngIfqx60M3cTrkjvcNzDAOL8omiyLmqPiQwDvcJc
	 pks3qKu4CfO6zX393RXxpOv9RXOYXy3biyBxQ+s/2cBRsTw9jwJw/3rr48K47J7EjzgYN
	 23pMtnchePHp+4DnNrkZN82wxe3K4Lj84N33PJtf+wumAcgqJApZMJpkwMAocXB2bf9Et
	 rHdHIoluC1KahCG01eulDCkJtTWN02Y7+IbBL7Y42xs6qJDQQ85NcYi+BjpFK75BAQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHnkDMNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B1E606E8DD;
	Sat,  7 Nov 2026 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHnkDMNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2841F008A3;
	Sat,  7 Nov 2026 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064388;
	bh=0uzsOzNxgz1AT2QOz6/BjOp2Rm5BTT4QCjr8LsCbNpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHnkDMNEYs6qevNFhRBxuyG4ouiT9zMft4HfYxhObp1fXm/kJKskOeOTBUn6zrCO/
	 nB9VlTzIIXoTfQTK1Zduohkt++FG9WrmDi4343+yJwLIBx3SHhd1cgAkXHzJK7/B9z
	 uYBZ398utvXC8GNVB2XeFGOoBwqYC8D5RZUBd4gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <anandu.e@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0426/1257] arm64: dts: qcom: shikra: Remove cdsp compute-cb@9
Date: Sat,  7 Nov 2026 08:45:22 -0500
Message-ID: <20261107134951.257836176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anandu Krishnan E <anandu.e@oss.qualcomm.com>

[ Upstream commit 90ae3eb55ad64dc05ab7ad4a667c921d0504ccc4 ]

Remove the context bank compute-cb@9 as it is a secure context bank
used for secure use cases. Secure use case support is not currently
implemented upstream, and allowing other use cases to be offloaded
onto this context bank results in an SMMU fault.

Fixes: 8b6f81f7801a ("arm64: dts: qcom: shikra: Add CDSP, LPAICP, MPSS remoteproc PAS nodes")

Cc: stable@kernel.org
Signed-off-by: Anandu Krishnan E <anandu.e@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260929-shikra-dts-cdsp-compute-cb-fix-v1-1-90e4abb873d6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 92d22e3b6931c..65cc94b9a624b 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -1948,12 +1948,6 @@ compute-cb@6 {
 						reg = <6>;
 						iommus = <&apps_smmu 0x0206 0x0000>;
 					};
-
-					compute-cb@9 {
-						compatible = "qcom,fastrpc-compute-cb";
-						reg = <9>;
-						iommus = <&apps_smmu 0x0209 0x0000>;
-					};
 				};
 			};
 		};
-- 
2.53.0



