Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0321DE2A9;
	Wed,  5 Feb 2025 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767195; cv=none; b=GT4Q54vI1aeK2N6Xz7a7Oh0njxLHTPxn9I1bojRDDcBxA/AukuyOJDpKuJF9FnH04imnRjhDcS0Th/laPzzd2xCSDKpkYD6ea0DPAwpDDVW6efTe5g3OF8lBMwxFHTab2uHxwA95kF4/X33+jjPmF8IiLNziLeJmHr8rIuuoHEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767195; c=relaxed/simple;
	bh=K/vy2Y8vI1RGoYgydXUwhNN4axr50nLgFQ5o2rGpI+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAa5PrA7tQfcaviKQWgUdcGHQi2QUGrC2DvLWI7Jirfrl4zltseS+3mEVcNZuuXuIDrskvfyOwDhoZjB7arGsePeibbMkLhnHTO5uj6LLMrhxZ2BBpz9Hh33o0nLDGuDM19UxFOsR092fDXJJ/DD2Shd864GEvlZ/iyanC2ksaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqT666/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqT666/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7DEC4CED1;
	Wed,  5 Feb 2025 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767194;
	bh=K/vy2Y8vI1RGoYgydXUwhNN4axr50nLgFQ5o2rGpI+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqT666/hIqhyWZny1RKmg+lGxusdPS75VreIlIxo0TsDPgrlJXZcGkulJmuZsUlpQ
	 qGrct3RCf/ybQQ1MM4eQbG8vyI0UyZEgGGbbjMksSYP4k+cRqi0yXGCyZ2m6ndNC80
	 mISftnU/9E4lEJUC/Tv0wQ/wUfn8qcCM0rrEwdFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 396/590] of: property: Avoiding using uninitialized variable @imaplen in parse_interrupt_map()
Date: Wed,  5 Feb 2025 14:42:31 +0100
Message-ID: <20250205134510.415794632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit f73780e772c06901e99b2ad114b7f0f3fbe73ad4 ]

parse_interrupt_map() will use uninitialized variable @imaplen if fails
to get property 'interrupt-map'.

Fix by using the variable after successfully getting the property.

Fixes: e7985f43609c ("of: property: Fix fw_devlink handling of interrupt-map")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-6-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 7bd8390f2fba5..906a33ae717f7 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1317,9 +1317,9 @@ static struct device_node *parse_interrupt_map(struct device_node *np,
 	addrcells = of_bus_n_addr_cells(np);
 
 	imap = of_get_property(np, "interrupt-map", &imaplen);
-	imaplen /= sizeof(*imap);
 	if (!imap)
 		return NULL;
+	imaplen /= sizeof(*imap);
 
 	imap_end = imap + imaplen;
 
-- 
2.39.5



