Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030146;
	b=zKG1/zPJU9do2dAn7y6jBNRwX6MFhkaQinMjXLfBPZ/U/aMYWgRyC77MjNue6TS+wx7G
	 oLQkuAQmHqmW/Jr2uIGHvGmDFlhzj5ItXNC+732G9gcbJ1MaQRtNPEAxk2OqdgJxS+CXl
	 smD5YleWmvLnG/LMKl1g6heW+/CjfJyrPv1ygnZRAMVfpRvNFYsnSMmB0ee6hGvQ0ofH6
	 /pq2tUbpYADlnn6sRfQ458UsKobiT7L81tRiyh8X/WxmA+/uze2/JbHLdkOZJcXA3QeW8
	 98rKoNwKUkXSiVa20J2FcPDFw6LmluMG3GTNpDFYJuboAYPCc1ezTMGRWOAIjQid5+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1tYPNkylOYvy/OPh2mpO22oRN1pdatsTPUF289YLls=;
	b=lranyfCzuQQqJnPKGEeRobSwcGftYOWtN+CIhlrNFF0RduTsT2WyHdw4j/utkEDoSUnU
	 ad03QLeQKq1184KVU6GzFZIaopfBEaL+g+p2xk/XymKC4JODuW9CQV8pcoPN4mQulKH12
	 TBlrvKeAWYNNkkmB0LJ3sQ4Yw9/gqso9T5ubZedNi6eVANrEidzBX0j/D1qn3FiFtBcoE
	 EKoq88gwcH9cVucDrP5M1ovlhe8vPqwIHMd+vNaca7Q45s7Pbpt7s3mS0rzTNE9NeibJI
	 JuKxOY0QWpMiKKd1+8yUrSaHYxglRp2eRD81u8OJjM39UbDcs0myoo7NPOvmX0nhzOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/EV8trx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3321E6077DCA;
	Wed, 18 Nov 2026 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/EV8trx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808951F000C6;
	Wed, 18 Nov 2026 19:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030146;
	bh=r1tYPNkylOYvy/OPh2mpO22oRN1pdatsTPUF289YLls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/EV8trxI7n0crskIkKYBNFKNyNVIjEsO/JMEx6tB6eqcsPz74DdyLot3byCSIdv9
	 wIys8tmZkEZUsGEpRCCzJ4+SDwEupqHepvr49L5yRjogwkHmveuYukXaHhKDzVSBFP
	 m7E0XOx+dnLjFjmZ8XQpd+g21YtleuTqwr21AZ+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0599/1756] dt-bindings: vendor-prefixes: Add Chip Wealth Technology
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118150032.820359510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 058ee00216a1356e710446b59a800065d2abbd80 ]

Add an entry for Chip Wealth Technology (https://www.chipwealth.com/)

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260727-ayn-qcs8550-v9-1-e3db456e10e5@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 442eb7e493088..3db3503567422 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -282,6 +282,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chipwealth,.*":
+    description: Chip Wealth Technology
   "^chongzhou,.*":
     description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
-- 
2.53.0



