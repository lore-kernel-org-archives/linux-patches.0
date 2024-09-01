Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4941DFD1;
	Sun,  1 Sep 2024 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209680; cv=none; b=I89m/WNsZ63IC5thH14vG8Heac2V3dQ8DUkZcLC3w+qBzts+WkqO3Kwcpr2/jy6ucos+kfILqB2buiJgGxFpOX195j15jQslZQpL/l02d3A36IaCbojz3kPPD5jp7PrRJhB7Phm7JYmsnylnVds7nkdRIFLMrg1rMYoYgH6/IGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209680; c=relaxed/simple;
	bh=Md7k0Sy7dtz6562kKg1D3Z8d4ESrw1++HvIUDJTgnpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmgFj6UpPfMvEqTBuJT7P8Q7V3crbZoJyvcj3ScFyZumHGpxdpHkWs0zCulEtPt5qJoNjPYosNjnmlMuYEnm81k1b7QrQ+Imh0pfhtqELG+09OWwRufl4tGuFnLoM3iNsD1DYyPG9zUclaHcL9TkxT6yuuInbO1XaNyjJ/hkq9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVP0iwM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVP0iwM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA7C4CEC3;
	Sun,  1 Sep 2024 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209680;
	bh=Md7k0Sy7dtz6562kKg1D3Z8d4ESrw1++HvIUDJTgnpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVP0iwM57BQ/XBgt0Nd1wEJJcas+RkbXbQl3TGfMRm1RaZYBqEz5MHmqaSaYaWiuC
	 g91TIb0UCukbJ86fvDN97iF/1GUTB+CMB8zHfuhZCrHkc9G3O6UX6FtFPcVtGDNpO8
	 qpsshX3L41ISrvbAsbhvxUvyEEiLnvvEbG6H2f/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 112/151] cxgb4: add forgotten u64 ivlan cast before shift
Date: Sun,  1 Sep 2024 18:17:52 +0200
Message-ID: <20240901160818.322235854@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 80a1e7b83bb1834b5568a3872e64c05795d88f31 upstream.

It is done everywhere in cxgb4 code, e.g. in is_filter_exact_match()
There is no reason it should not be done here

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: stable@vger.kernel.org
Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240819075408.92378-1-kniv@yandex-team.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1244,7 +1244,8 @@ static u64 hash_filter_ntuple(struct ch_
 	 * in the Compressed Filter Tuple.
 	 */
 	if (tp->vlan_shift >= 0 && fs->mask.ivlan)
-		ntuple |= (FT_VLAN_VLD_F | fs->val.ivlan) << tp->vlan_shift;
+		ntuple |= (u64)(FT_VLAN_VLD_F |
+				fs->val.ivlan) << tp->vlan_shift;
 
 	if (tp->port_shift >= 0 && fs->mask.iport)
 		ntuple |= (u64)fs->val.iport << tp->port_shift;


