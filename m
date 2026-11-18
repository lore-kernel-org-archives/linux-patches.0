Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016701;
	b=BTLbGZIRV0KVnkGbIkkwQScku6ftKaLhyo6JbokEZYKUG7DhXGX/SV053uvYw5aVXgNC
	 iI0kIzINXwAjXXTN38S1MTcXhLKiZBeqRh45obq0/hLcWk5VTyCdk1Bu8TsV6Ctlp6qs8
	 X3W3RQG7DfDPJPZAjmVPdMRiNA2n4XbrrC1/Mb/Ci+fWC9Ut3nlEDnAEX8blzAPnES/St
	 EXrAUH+ZkGUyDeS0LHLOmHKXbgibf/I3i/Ge9LxaiWyTmrc4h3tx9eo+WKvryaMOKGLUA
	 RMcLcK8xzZb+tmvcf6qI2peowIgZubx+h4iYq7WaYrZwCfrdFzOLtkPVFf1e6hnzI4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9G+fx+UgvoGxMqaRVf97v/0EEVPIVjWr5onW5zeTqA=;
	b=zQzP2hLtanLDtuUKSTDyz1bIx3KoTV8Xf2beWBUfzQ2g68+Vf+3Ninn1Njh+M2Ngl3XF
	 lZCwsXJAo0OFsWA0jdZ9Ulzp+csV3Xe/gZVYosrHKTf6VMihUsWyuRjCPH1UJqSC+8jU4
	 LFetO2LGnziB4yNC7Q0tTXm2rzAZilIIhKPLYgpSzY0VqTfjue0ZTG1Q69p9DMy3gvel1
	 +dCPgQWUnehnsyE/sammcO/ngbcCcMlS/Wd+O5qB1rbnlZNibrQWE1YOrjAo280RZPS/q
	 PqX3LWVotPzYPHW0noq5KaPYce076LTW7GZecMU4X2vMU6P9XHw/D2gj9STLV1+GNeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTWpq3sN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83FC606A333;
	Wed, 18 Nov 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTWpq3sN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068ED1F000C6;
	Wed, 18 Nov 2026 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016701;
	bh=g9G+fx+UgvoGxMqaRVf97v/0EEVPIVjWr5onW5zeTqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTWpq3sNWalo5uIne2d+fFnKj8ur2WvvP+2xlZgISt2fFyg+FeB037ItkSfZXtUom
	 UlJ/b9R/jh6gRn17U0Ghb0qxcWQTCD+SaxZX5rpjGVuVL2wE5lUis1SKhN0YGN5zJ5
	 BLYr92p/QKZ9/LLcyUYsUjW5jb/IpplSCZjYLWsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0605/2651] ASoC: SDCA: Check return value on a missing FDL_Set_Index Range
Date: Wed, 18 Nov 2026 15:30:45 +0100
Message-ID: <20261118150309.501439345@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit dfd8940277c9a07193c2d168760e19d054f5047c ]

In case of a missing FDL_Set_Index control the return value can be NULL,
ensure the functions returns before passing it on to range search.

Fixes: 71f7990a34cd ("ASoC: SDCA: Add FDL library for XU entities")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917103400.2032913-2-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_fdl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdca/sdca_fdl.c b/sound/soc/sdca/sdca_fdl.c
index e08a553e0eab0..7fc809707944d 100644
--- a/sound/soc/sdca/sdca_fdl.c
+++ b/sound/soc/sdca/sdca_fdl.c
@@ -301,6 +301,8 @@ static struct sdca_fdl_set *fdl_get_set(struct sdca_interrupt *interrupt)
 
 	range = sdca_selector_find_range(dev, xu, SDCA_CTL_XU_FDL_SET_INDEX,
 					 SDCA_FDL_SET_INDEX_NCOLS, 0);
+	if (!range)
+		return NULL;
 
 	val = sdca_range_search(range, SDCA_FDL_SET_INDEX_SET_NUMBER,
 				val, SDCA_FDL_SET_INDEX_FILE_SET_ID);
-- 
2.53.0



