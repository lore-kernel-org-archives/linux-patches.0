Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAEB522A;
	Wed,  5 Feb 2025 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765073; cv=none; b=FDsFuysgWTOiv5QSCC+Gr6K73sDrq6xbVAcAoZjxaz0orYkQNDjsXyto8HL7qaGFi48t4w0KluFncYh9LkLxy9BanOaUU/MRK00CGaWiJoIXBLnPWIqhH0XwT3nGlLnHRNDjEngUbhSRtCU4ODRotk+HJUCA/w/2D4FwnGuJ7NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765073; c=relaxed/simple;
	bh=W54yb6/P++E3B/wOw/RTRU/Ko3R3P1h9vGwwD5Ol4Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMGuYlt10CIgYHD2bFzMLuTeO/1c5/4O/1WryvQN9mro2hGzudrOK4+dTFGfYOpeSKVaHqxRzi3UQFSlfkUDz9We4pdAJ27E7N7DKUNrwyFZGXZsx44GMrB7aB0fslvkZXhkQThmr54bMKiRNueQzccqXMFlrtqN6JZVYVzqed0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsYrbmuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsYrbmuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D5DC4CEDD;
	Wed,  5 Feb 2025 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765072;
	bh=W54yb6/P++E3B/wOw/RTRU/Ko3R3P1h9vGwwD5Ol4Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsYrbmuoPuC8b3IWKZsLy+qd5DBylejkxk8NoOFbQb3zhVs79GPG0fVVSjyjZvP2q
	 eAYCMQ1ZIEdL9CUgEv+SvWO1JUPHt8LG3VXkkIevQQ1CjCQS3/4yGp4vNwMsaPqaEp
	 5NE6TizD3IksWDSJc90FtSeIRljElzq0PdgGBxt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 141/623] net/mlx5: HWS, fix definers HWS_SET32 macro for negative offset
Date: Wed,  5 Feb 2025 14:38:03 +0100
Message-ID: <20250205134501.628083766@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit be482f1d10da781db9445d2753c1e3f1fd82babf ]

When bit offset for HWS_SET32 macro is negative,
UBSAN complains about the shift-out-of-bounds:

  UBSAN: shift-out-of-bounds in
  drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c:177:2
  shift exponent -8 is negative

Fixes: 74a778b4a63f ("net/mlx5: HWS, added definers handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250102181415.1477316-12-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
index 8fe96eb76baff..10ece7df1cfaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/definer.c
@@ -70,7 +70,7 @@
 			u32 second_dw_mask = (mask) & ((1 << _bit_off) - 1); \
 			_HWS_SET32(p, (v) >> _bit_off, byte_off, 0, (mask) >> _bit_off); \
 			_HWS_SET32(p, (v) & second_dw_mask, (byte_off) + DW_SIZE, \
-				    (bit_off) % BITS_IN_DW, second_dw_mask); \
+				    (bit_off + BITS_IN_DW) % BITS_IN_DW, second_dw_mask); \
 		} else { \
 			_HWS_SET32(p, v, byte_off, (bit_off), (mask)); \
 		} \
-- 
2.39.5



