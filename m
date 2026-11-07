Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062738;
	b=m7tmDBpmg2fAcFHcio4mqcZgMr73G8MKZ6gpLM92OThigr+b7eUUGnazq6Bz84MZlzaL
	 rEemMenWo3zbW3rjyf4hYom15Mg2Cvzg7LkucawyfbmcDVxilYvM5FJvtrKN29jq/3Es1
	 yolKCIwR6sexheY+m7SEsgSsNoXIKXpxOPBff2ziyEGNrdtL9OOZoyocNWplSS4DehzuT
	 itn21xY6lUwqdGr0SDYiK7qg5OW5dFQah7HXRwIwJGZkBfHDykMt+njkSSaso0jKdT/Od
	 tirPFadN4zS/BHRsq154VJwrfZTqmf25iyd2Hr4TgmbRGV5Lstmq4k+09ZbVNUqrvGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g2a0ethIFDGRU6qFWb6E8PEVZFWIr+NXFv9PfcXbhxo=;
	b=nwpEE3XPN9JYjxDGCnuR1mg+1O9oKK4qkJwNOdYyfwrOMUiwj/KiiVxGoMt0xVDvaQBp
	 haVTvusQArdz5LWdMVGmAz2sQ9Im0G+CRhEBNwrinqThoX1UyaRhvymoj5XNO6vOovq+u
	 R1Cj9NuZTSWhs24lHyQ9gNbdFJ/WNl3yrs1NLhnHjr2iUh44dWhhbP50Fg3CPeQgv7poc
	 1ITfPN7y9O9NwgRbjc3n29SuP4CbusCpd2Wxu1fpzgxm+iBZvl/FXE3Zo63x9R3mtdHfJ
	 oE7DTaro9pzoCQv+sAO14IOvZ9YyN9QglF5e6vyvANSOw8+3lPn4gbtqisDFL/SZekA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhPDS2PW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C46606A32C;
	Sat,  7 Nov 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BhPDS2PW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44001F0089F;
	Sat,  7 Nov 2026 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062737;
	bh=g2a0ethIFDGRU6qFWb6E8PEVZFWIr+NXFv9PfcXbhxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhPDS2PW4WGynWGaDpIJKcZTipSnuyq/+QYwFgvSb9foJ02dgYm5YFh5/1xtce9V+
	 uh7m8Rh/kh60lCSVhmvPY1F8j2Chv6Lz/mR55BChgpm9L97TkWZa2fW9yzycu3VHRG
	 veZheclU4sbB+8Bu6JAgC2x5BoTrobcF++zRN9vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/869] memory: renesas-rpc-if: Mark XSPI_CDD1BUF0 as volatile
Date: Sat,  7 Nov 2026 08:45:37 -0500
Message-ID: <20261107134853.951072312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 3db1fb5e1bb4c9eefc554f985f6f3316fa1292e5 ]

Add XSPI_CDD1BUF0 to the xSPI regmap volatile register table.

XSPI_CDD1BUF0 is a data buffer register used during manual transfers and,
like XSPI_CDD0BUF0, its contents are transient and should not be cached
by regmap. Mark it as volatile so reads always access the hardware
register.

Fixes: 687cac9559d8 ("memory: renesas-rpc-if: Add RZ/G3E xSPI support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20260727103449.3188105-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 4a417b6930805..7f75052b6ae34 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -34,6 +34,7 @@ static const struct regmap_access_table rpcif_volatile_table = {
 
 static const struct regmap_range xspi_volatile_ranges[] = {
 	regmap_reg_range(XSPI_CDD0BUF0, XSPI_CDD0BUF0),
+	regmap_reg_range(XSPI_CDD1BUF0, XSPI_CDD1BUF0),
 };
 
 static const struct regmap_access_table xspi_volatile_table = {
-- 
2.53.0



