Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059667;
	b=T8DhYostzoleqgtiuQS9nXY1rdsgCP6xUepFhhD5X53x57jxgWC1Tswqx12poi4YgKN4
	 gaVc2M7XrKSTrOsXLlUWcKFF7EYoxD2lTwb90ZSwlL8pJzLHKwIez5mKOfnI6PMShR/4b
	 cPjXLLKpxPuQLqzQLAjqtwiPvDyPCD1Cy1jgNqrf4oC5j27ucx/NdbrQjKOQiLcPEoEJ7
	 d+/BUpvaKKMfnnpQFzCl72/whfw6/OKfCbkwWTsSjLaarR65YVxtxFqyp1bx894tmJAkD
	 NbR7HyOR2hWAkzZH12D2OybvayK637m0Tt5V8lTlFyCZw5geTo4/6ZNttbup5t901GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/UKxq6RHgeXmhebciKdsQwX62ZyI62sbKMLOEn0YjQ=;
	b=SGUHreDzi0feVePokDQD7ycjv3hQgzj3MYrCd6cFxPHjBWMuKmti2o5C7oFHI0MHwDfE
	 9t+sWTUIEnEge1iKE6sK+7EMVh94CYuxbJo44CFPM/HyyWDfHAdTpkPuUK9nEhTdR3Jnw
	 RQfRdMguhq8HTMcTXOniMJ00B9uLmbQME59XdJ8Tpo2ZtcOkEnLGEnbU078PoWu/ybCoh
	 SSi9YqNfJePC5Q4Ta3wBnOY2tBZR0b2ivjITqjfvsl9c0NWCHwlv90Gi073UQ0LUFc4+y
	 LsISCXkJjyp/STOvQFRa5eJqhzPsaFQMA9q3sXBoO/SMaAfdL9gSchtprE4JLnxQYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyp10pRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F63A606A325;
	Thu, 19 Nov 2026 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyp10pRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591681F000C4;
	Thu, 19 Nov 2026 03:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059666;
	bh=w/UKxq6RHgeXmhebciKdsQwX62ZyI62sbKMLOEn0YjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyp10pRsKocRSwjC8uMcWoqQfLQEJ1Z0XuQD1OG9/RmdygzGwZ2BdvXr8/OsyqFoD
	 hdnWgNTAMmIy4//1VfOA6JEi3oKyOVV8I2FZ28dNUaPOJ8ZMQtwmoEwSW82DKoPSO4
	 SMYESOqNLX+BzW2bzNUv8SkMGLBMVewbG/qi+DLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keita Morisaki <kmta1236@gmail.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0922/1848] drm/amd/display: Fix swap in median3() for DSC rate control
Date: Wed, 18 Nov 2026 15:49:20 +0100
Message-ID: <20261118145955.413835744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keita Morisaki <kmta1236@gmail.com>

[ Upstream commit 7b23bf82ccbdb4cf0752f2b8686e7319a7ce497f ]

median3() is meant to return the median of three values, but its last
compare-and-swap step swaps b and c instead of a and b. When c is
smaller than both a and b, it returns max(a, b) instead of min(a, b).
For example, median3(2, 3, 1) returns 3 instead of 2.

_do_calc_rc_params() always passes 0 as the first argument, and the
second argument is never below 12. So whenever the third argument is
negative, first_line_bpg_offset (and second_line_bpg_offset for 4:2:0)
is set to the second argument instead of 0.

Fix this by swapping a and b in the last step, as intended.

Note that this change does not affect valid DSC configurations. The
third argument is negative only when bits per pixel exceeds the
uncompressed rate of the colour format:

 - 3 * bpc for 4:4:4, 3 * bpc + 2 for RGB

 - 2 * bpc for 4:2:2

 - 1.5 * bpc for 4:2:0

Fixes: 97bda0322b8a ("drm/amd/display: Add DSC support for Navi (v2)")
Signed-off-by: Keita Morisaki <kmta1236@gmail.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1ddc4bc97a62fc89d9d3681413d9f977e1fa1a83)
Cc: stable@vger.kernel.org
[ sashal: Adjusted the target source location because median3() has not been relocated. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
index 4da21966ddcec..c860e536e98e2 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
@@ -169,7 +169,7 @@ static int median3(int a, int b, int c)
 	if (b > c)
 		swap(b, c);
 	if (a > b)
-		swap(b, c);
+		swap(a, b);
 
 	return b;
 }
-- 
2.53.0



