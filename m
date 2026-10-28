Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213855;
	b=uEQhmQR1pfj/pLARs06ubKC5255y7BmUSOU31eJz3JC2FOmkGgy65F5aJpQCbnrUnnbb
	 g2ZFwOFXbYhT3I9FIXgRadZRqYgbgwQQ/zQjyeDFi90Ktyn9Xxzubg5F9vTYzRMIcXl/n
	 svVAb/S8BMka902rxfLvFgVXwzAJtlFW1XkZWv8zXdx4mc2DVjmnrQKR0A9ZfQVhL5+XO
	 T32/nCiltCBurkC3c91mgwT9vxf7ZofIqXqcxt9X1srEDDNasVqaI46Woktb/2SwceSdx
	 C+aevcKrTAo2CkKHg6lJ6NIq+sphEF2BefrzehXJ04cY7C9qnBDp2Ai8OOUlfdxvgOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdgt/TpVSAsuaUMqswGz0ArOLb4WPHQxfWEuJSbqPgw=;
	b=HO+Hxzl7a90yMNFD1FL/kJdzFXlv9ABZYusUBL1kKkmeXUjxhrt5UBM82tuiCZ/ENltJ
	 CK/mf0eoVXTarKTXs7H3JFlskFsOcPi5ftMRou9dwrG3iV0GhVFL5xK+2JBz6x8MCMOfY
	 PMC+ReNu1Ls1dbu+q5aN/DtSSkYjSS0St1yDhaG3bHZUIJBzgwJGSM13QY+bdKy6s+9ck
	 s9/9opDHdmix0ZrAm1kqfiFqQNB6nJGKgwbbKjPqWnk6SzQH5SJHANf+n5mbZiqpWMkoI
	 QuChSo6oK4xrVq5nrNMvyQER/9bK9Ut/odfOTkeQ1pXuthoWXHckjih99amK0fcXfxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vx8T1gGI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7D5606A31C;
	Wed, 28 Oct 2026 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vx8T1gGI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D371F01829;
	Wed, 28 Oct 2026 18:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213855;
	bh=qdgt/TpVSAsuaUMqswGz0ArOLb4WPHQxfWEuJSbqPgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vx8T1gGIUk3UV9Wm28y8jkaRnW3fSY7ZfdNo4k67LsxmYx2PUO4WnEfeChU37mnb+
	 bz/AnNuL4I68Oz68CnMa81RH1WpnByK1iF/kpT7/cJrHMeXDCU+2bVB5W9fGfJQ205
	 srYvbX9ex7XNGkiKapV2+1A6KWr4g4z0z1eA572s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Lenko Donchev <lenko.donchev@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0652/1887] drm/amd/display: Use kcalloc() instead of kzalloc()
Date: Wed, 28 Oct 2026 17:45:48 +0100
Message-ID: <20261028170514.248329485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lenko Donchev <lenko.donchev@gmail.com>

[ Upstream commit f634ee1737e7b856bd4c3f040af867007d1cb7b8 ]

We are trying to get rid of all multiplications from allocation
functions to prevent integer overflows. Here the multiplication is
obviously safe, but using kcalloc() is more appropriate and improves
readability. This patch has no effect on runtime behavior.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Lenko Donchev <lenko.donchev@gmail.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5524fa301ba6 ("drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
index aefca9756dbe8..5ec6f079b08c4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dpcd.c
@@ -161,7 +161,7 @@ static void dpcd_extend_address_range(
 	if (new_addr_range.start != in_address || new_addr_range.end != end_address) {
 		*out_address = new_addr_range.start;
 		*out_size = ADDRESS_RANGE_SIZE(new_addr_range.start, new_addr_range.end);
-		*out_data = kzalloc(*out_size * sizeof(**out_data), GFP_KERNEL);
+		*out_data = kcalloc(*out_size, sizeof(**out_data), GFP_KERNEL);
 	}
 }
 
-- 
2.53.0



