Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6337248881;
	Wed, 28 Jan 2026 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614330; cv=none; b=rpcuVLIUzGfIzXwLUQlEXwAFlXmAXqvWZNpbKEbnVq48cW5NG6pK0dQbawCzvpM7dlD/Ukpvn1vibw4GoPStwhXj2zhgw5j0KdbRftvKl060M4T6aS+iby2TpNuHQkh9RIBdAlZPAV0uK+G6U2VqJRYl7RcDbUoxcsKguRFdYQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614330; c=relaxed/simple;
	bh=5XmjHCHhT9NfxF4JUoLGSPk4qsziD1Z3V/797iBXH6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSygNC+iUE6JyxbQ0m9b89+oqA/+a/sQ/EbRWb/d3hwdSpZ8/G/ZC0q6Xr2JUAI2j19uZ1+80TEzuVCLtes6lJO/nQsRGLQUg/5M662MitJq06z/RLvzU8DgDWhVmUZPTV5m4KeqJCU7a9+m6GUn6ihh8ZsAoQ+CrACKhuuEIpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA/oAdRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA/oAdRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA44FC4CEF1;
	Wed, 28 Jan 2026 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614330;
	bh=5XmjHCHhT9NfxF4JUoLGSPk4qsziD1Z3V/797iBXH6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA/oAdRF48dqNgwlAe71QvMgBUNvRZChNK5VljgywhN9eu0942kB819vj3yRz8gsZ
	 OgriKcP+MmVdRNBncJdn22i4bVYBPR1htq+dpVYvUz5EtaFPfYh9uOd4xdeXa/H+1H
	 LzKrildV+0I6khjDvV30zuKiAlvHJV7yPYXfEZHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Tikhonov <danila@jiaxyga.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/254] dt-bindings: power: qcom,rpmpd: Add SM7150
Date: Wed, 28 Jan 2026 16:21:18 +0100
Message-ID: <20260128145348.494703808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Tikhonov <danila@jiaxyga.com>

[ Upstream commit 0cd3f86ad558d3f585634e211c6fccbe786cbc28 ]

Add a compatible for SM7150 platforms.

Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230916175952.178611-2-danila@jiaxyga.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 9b03c41d3604e..53886f02d98a9 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -46,6 +46,7 @@ properties:
       - qcom,sm6125-rpmpd
       - qcom,sm6350-rpmhpd
       - qcom,sm6375-rpmpd
+      - qcom,sm7150-rpmhpd
       - qcom,sm8150-rpmhpd
       - qcom,sm8250-rpmhpd
       - qcom,sm8350-rpmhpd
-- 
2.51.0



