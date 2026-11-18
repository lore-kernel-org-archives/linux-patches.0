Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015342;
	b=rXhOw4X+xTB0JwVQuEASEA0y05pqvleDEATZ+EqcPOEMZ84vF7PN9BLgHMGAjPffDET1
	 dmEtnia387c6wDFjuBgDSdR6AI0V3dNCZf0Qopuv8rqs0bOQTvlKQP9xkAnhQH7JcjdNL
	 g3XXsg9InjRGTRUg3PVGpa52f15crLMIVWdbbjkmevek8uqJ4WiKEnQtsMUcFXt9sUadu
	 hbsVv0MyXa01qz0t8/JQl2GpQjInsFK9MGkveWmyQ6W4eTmg+ezR7lBC29dJJSR8AVy0V
	 BcjBcVpPmOa5gtbxXjO6DZA8e0ZR9e5aRMbY0utI0A25LxH9EStCkTsGJWQwsuRl4zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6wKw6ZLUjWImlqCMjwfA7PulPSjWUO1SAlykQjPwF4o=;
	b=rsyJR0IoWnpdhwh6RAVsE52l1PQgnrrD31b3a7I1LZcULSf0COFpCM0/avMohqw+6Co9
	 jRK3AGnMRQ1LmkgHKlRwyVSqUKtfqZiQvm9PArBcnK/rUcbql9s/FOeC1yjkOZiMsJ7cL
	 WVIw4DjXLKI10vEs75BZ6rPYY3isi9wnxR9xkgMTDQrGCfBy6Q4lSRoiUL1+NOtOSNQC7
	 zRDg4o7Cc8WY3ifa0tXcKosC+hdbwAdeAOfbaC20iNf/ZzepeGg/2f1y7hU6lhmLchD8R
	 gDZGOqw6w7m5m2Kn0q/RXwKv3yn6yByuy+JTqSOwU1EL6S1nrzzXylUc2ZzaUPcoWZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMCmnFvf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41311606A330;
	Wed, 18 Nov 2026 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMCmnFvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995001F000D0;
	Wed, 18 Nov 2026 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015342;
	bh=6wKw6ZLUjWImlqCMjwfA7PulPSjWUO1SAlykQjPwF4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMCmnFvfn6I1rLxhGLVZxwjuXWG3oWRokEC7dJwDzzk3GhsZ+5yy6Jx39dm3wLcfM
	 X+tu/pTB9UWfi1CX+GePBaD7aaGOxJuRAUhMXXN5+D3dI05a162pLvS9x09QB/wkel
	 unQSPort8WEmsMAS/nGzq61IFxcEinP94y4uTmjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0139/2651] soc: qcom: smem: Fix signedness bug in smem_dram_parse()
Date: Wed, 18 Nov 2026 15:22:59 +0100
Message-ID: <20261118150252.852883510@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 22f129fedb153a17d80b1d883a7c4dd2417cf38e ]

The "ver" variable is type "enum ddr_info_version".  Enum types are
dependent on the compiler but in practical terms here, "ver" is
basically an unsigned int.  It needs to be signed for the -EINVAL
to be handled correctly.

Fixes: 1d234eeafc56 ("soc: qcom: smem: Expose DDR data from SMEM")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/an1toQ-acGR0kOWj@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem_dramc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem_dramc.c b/drivers/soc/qcom/smem_dramc.c
index cba5376ec80d3..19a831ab59079 100644
--- a/drivers/soc/qcom/smem_dramc.c
+++ b/drivers/soc/qcom/smem_dramc.c
@@ -385,7 +385,7 @@ struct dentry *smem_dram_parse(struct qcom_smem *smem, struct device *dev)
 		return ERR_PTR(-ENODATA);
 
 	ver = smem_dram_infer_struct_version(actual_size);
-	if (ver < 0) {
+	if ((int)ver < 0) {
 		/* Some SoCs don't provide data that's useful for us */
 		return ERR_PTR(-ENODATA);
 	} else if (ver == INFO_UNKNOWN) {
-- 
2.53.0



