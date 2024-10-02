Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D071C9B91;
	Wed,  2 Oct 2024 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876727; cv=none; b=Q6tU/KbvjjMKIU9VC2ncYN/3qaCbarekXhnXauPfQ2zY85PxIra4gVcRWZoJZxpCdSc8qiVflt/N1XxiUgwt98cKVdXMZ6308igwz8bMj61ZRp1Ndxu59amcuStayydI74s6bm/T/jhwLvycHQMhN1CGp/hloOutDPhoZ8q+LRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876727; c=relaxed/simple;
	bh=Lzl5KWL1OO31ROKNIbaozRq7HtPm6JP2iSOlCXnPS2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naIhbnRtaXQqhEuBirFzMyKYHe9Mt8HnduxcRbWBBPNYztahSXZyiLbzG5zWK4jOawJaDGJDtcsIbCy2zPxiVSIDO8DK40xua/igOzP2tfD7wWFvRpS758dqBy228tFJlZ+j+3hs5AL0DXGsb4GefSzBOktjRnHy41BnCgx+rqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAw8aU4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAw8aU4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0F6C4CEC5;
	Wed,  2 Oct 2024 13:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876727;
	bh=Lzl5KWL1OO31ROKNIbaozRq7HtPm6JP2iSOlCXnPS2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAw8aU4g+yw1kuTDPo4BMXyULI/tTsroMxt7Bu6v/+fCKXB1YWQwoxu57zZEjrT/Q
	 cz40Z3SZrXHY2WqKNsLtiEN6cO2vr2e32ZZkdcPiSraXp14DQO1BWGUxmHQ/6UD+np
	 zjLvlMP7tE9RzFgIASKw9MgJ561gS4T0sUX1l7n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.11 525/695] soc: fsl: cpm1: tsa: Fix tsa_write8()
Date: Wed,  2 Oct 2024 14:58:43 +0200
Message-ID: <20241002125843.443298634@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 47a347bae9a491b467ab3543e4725a3e4fbe30f5 upstream.

The tsa_write8() parameter is an u32 value. This is not consistent with
the function itself. Indeed, tsa_write8() writes an 8bits value.

Be consistent and use an u8 parameter value.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-4-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/tsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -140,7 +140,7 @@ static inline void tsa_write32(void __io
 	iowrite32be(val, addr);
 }
 
-static inline void tsa_write8(void __iomem *addr, u32 val)
+static inline void tsa_write8(void __iomem *addr, u8 val)
 {
 	iowrite8(val, addr);
 }


