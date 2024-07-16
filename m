Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C812F1DDCE;
	Tue, 16 Jul 2024 15:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145259; cv=none; b=NmAqBeGYBQeYPspfRUV0LySC1IVhE5XPxrHtnjSDSJjlPnSWvMj6pcXcbIyNCMXaYbSBxkk4VHgtdmyouF2HzMBC2yY5o5+/35m9Wxa3TBTgLDYjRZfbsveYthrDvLN20lwgwGt46c8V6G5t32mCFheokGPnlKHNYLkKJkFlfDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145259; c=relaxed/simple;
	bh=TuNS8Frcuw6KV79fdNjs9r9Mp0z22Ueg4ZoDmvrcBy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W50E94pvISUtQcGmu+SJOpM9ua2p2P8knmpVWAB4n/BkKqUM0oW4wt6Ev1j7dEkTiW1hWmh5k/RG6Rm5CI6tNt+Uwk9PuIXkuSQm1x9Z5HTOMOPaq0SbPMj4Ura49bz/87z+YMtc49Qw9VemZipyzKaeqbqwhEdO0+7NaGYujCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6ohuJTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6ohuJTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAFBC116B1;
	Tue, 16 Jul 2024 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145259;
	bh=TuNS8Frcuw6KV79fdNjs9r9Mp0z22Ueg4ZoDmvrcBy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6ohuJTmCP+SlYfQ0pgo7xzWYmaNiGEhR+pECi6kFl9s6XmCWcoMpnevn5HEnN4A7
	 KTJyp53WqBotSg/bR6DAvBG3UksOrMzBFEJdLSI5sVnC86lqIxfAxTc1P36DcpLf7W
	 xAgGeCAnUhlEnMzxXuUxWS2oF8NkAuoKwtjEp2ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 133/143] Revert "dt-bindings: cache: qcom,llcc: correct QDU1000 reg entries"
Date: Tue, 16 Jul 2024 17:32:09 +0200
Message-ID: <20240716152801.109108201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Komal Bajaj <quic_kbajaj@quicinc.com>

commit e227c11179dfb6970360c95a8d7b007eb3b223d6 upstream.

This reverts commit f0f99f371822c48847e02e56d6e7de507e18f186.

QDU1000 has 7 register regions. The earlier commit 8e2506d01231
("dt-bindings: cache: qcom,llcc: Add LLCC compatible for QDU1000/QRU1000")
to add llcc compatible was reflecting the same, but dtsi change for
QDU1000 was not aligning with its binding. Later, commit f0f99f371822
("dt-bindings: cache: qcom,llcc: correct QDU1000 reg entries") was merged
intended to fix this misalignment.

After the LLCC driver refactor, each LLCC bank/channel need to be
represented as one register space to avoid mapping to the region where
access is not there. Hence, revert the commit f0f99f371822 ("dt-bindings:
cache: qcom,llcc: correct QDU1000 reg entries") to align QDU1000 llcc
binding with its dtsi node.

Signed-off-by: Komal Bajaj <quic_kbajaj@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240619061641.5261-3-quic_kbajaj@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/cache/qcom,llcc.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/cache/qcom,llcc.yaml b/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
index 07ccbda4a0ab..b9a9f2cf32a1 100644
--- a/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
+++ b/Documentation/devicetree/bindings/cache/qcom,llcc.yaml
@@ -66,7 +66,6 @@ allOf:
         compatible:
           contains:
             enum:
-              - qcom,qdu1000-llcc
               - qcom,sc7180-llcc
               - qcom,sm6350-llcc
     then:
@@ -104,6 +103,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,qdu1000-llcc
               - qcom,sc8180x-llcc
               - qcom,sc8280xp-llcc
               - qcom,x1e80100-llcc
-- 
2.45.2



