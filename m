Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018092;
	b=2cu+RA7PE4ypnJeCzASvsOVSlpitKY3HSm4p8a+Jxq4i8/czPKDpb2Za5kw3dzWYe/NC
	 l7fmlvkSa4F5OC8goRTRL+oO6nKUIdoBkkUNTw4IOZteAxAZcn644nItRSL9j+S6Ose5v
	 z7abFxCzOvB20AnBrUV1+wVsQ4sDziacQoH/t14yTdJQxNREnzJJx0iqrnjMwyOu0kzs2
	 V8sW3rgrnG1G+WWLQIXG6FOUCgXw2pBVFz5rd6dP4CFZX0E3ze9JEY3G3bwvfVyJ8fd7J
	 DBDsGJxw5h1AlYnm23O0JIHaALVWOy5UwfecNLxd2ipCTwyDPjH2iUY3ifQbpmhO+pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0Dq+S7/VscHlT+ghzOhwjU1FFgQ/oz0HRuOHXzqpK0=;
	b=zjRwwdRjwh65cSggkKDcYEw6Q5AWVYvH07bsdqMzRhn4fCCbG13ZiwFYH8VQfsgLKs9a
	 6Rx6W8OsUDGPsnL7a5fcQgCn6iTxs83FxNbp9x/nSxgxLPOvhRcYrc0lI6gkxPG6QZTzn
	 89n+O7AR00rFgu+FXeWw1zzSUXs5E1WAN62R1FsHmhHmaMWM06cplN27T8fRUwesRBLhG
	 CXuqSa92FJed8XXDl1XH/U8osIBKMXbWAa1imSOFOVvmgzD2IJg+6KlPAb44k+H7S8F8/
	 YW0LZrrZsi+gMKLzwcFWHZzO87SoSP0fn56wShjanFiPWflQruphjwA+R0dkrqWFUgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVn+rCUa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E54606A32F;
	Wed, 18 Nov 2026 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVn+rCUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B731F000C4;
	Wed, 18 Nov 2026 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018092;
	bh=X0Dq+S7/VscHlT+ghzOhwjU1FFgQ/oz0HRuOHXzqpK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVn+rCUaDdc/zNRbUzdKMN1VUzzvm9WAnwB8Yp6oQ9VBlwTpyu+JI/xbDgJlyf5NJ
	 qdGIDjB0N9G8D4aNJtZGIRJmAkf9agpvq/Sj1dbhm+cPhn2flGsDq/qPv85XKk0Jz4
	 Qhqhr2lYspdZ4HVAGoMaJh9RnhvjaAyK7XlzutQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1093/2651] dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
Date: Wed, 18 Nov 2026 15:38:53 +0100
Message-ID: <20261118150327.350736523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 3309f5c888602c647f50c1921c9b60759fa86c21 ]

There are no properties in DTS or Linux drivers called
"core-vcc-supplies" or "hdmi-mux-supplies", so the binding probably
wanted "-supply" properties instead (which are defined in the top-level
properties of the binding).

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 2f14bc38d88a ("dt-bindings: display/msm: hdmi: split and convert to yaml")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752661/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-7-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/hdmi.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/hdmi.yaml b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
index dfec6c3480f3f..02d27ccad0247 100644
--- a/Documentation/devicetree/bindings/display/msm/hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
@@ -113,7 +113,7 @@ allOf:
             - const: core
             - const: master_iface
             - const: slave_iface
-        core-vcc-supplies: false
+        core-vcc-supply: false
 
   - if:
       properties:
@@ -136,7 +136,7 @@ allOf:
             - const: core
             - const: alt_iface
             - const: extp
-        hdmi-mux-supplies: false
+        hdmi-mux-supply: false
 
   - if:
       properties:
-- 
2.53.0



