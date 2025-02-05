Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D41519AA;
	Wed,  5 Feb 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764529; cv=none; b=Neo5JssGQLLt19YlBfP6r2xSqOjUtMdqeDOO4XPxrJcNb8NxraNld0avjA8tbvaeEzHib/yJtyHW+7uwV6lFv80pKIR7It3upi+/4JRuN89Zc9rSVBJgJiOyAwUMLM5EbTCcZhxDskvUcgRUh81vud474elrm1IW/lOToh+UOYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764529; c=relaxed/simple;
	bh=TDANKLy7BsG5MNa47ggkRlUFzlwKWhnIOesbgAgxaxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE5eGb1JxWmAchBrM/jpeU+HAAnQAG3Bd+k5/c8ZIYQNevTHDq4vyA+SgAzWzIsyOetxoT8xYkUi82Oyt6tqged9CfHLP0elBBjC/sjzQKfPETVSq3ZVjDCxqVUj2eO8PdMK0970rhVvLkcesbC4pKD/3mhfAYFWJQzDtnVdzO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcViaN22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcViaN22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C73C4CED1;
	Wed,  5 Feb 2025 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764529;
	bh=TDANKLy7BsG5MNa47ggkRlUFzlwKWhnIOesbgAgxaxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcViaN22u3kfTjoUJUEQ4hIzGvxv7Zxjn7cDnEGxaXcF4Zb14GnIg7thpP7m5lF76
	 NWBAyCVEsS3c+cPpC2FUnhCmNQaai0WJpWrx0GiEc3RjXpcnsK4c+9NLAYyF9C9AdJ
	 LmhffSIimlCi0Ijcx5imkzhKCFteX7tGcSXrFRDM=
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
Subject: [PATCH 6.12 135/590] net/mlx5: HWS, fix definers HWS_SET32 macro for negative offset
Date: Wed,  5 Feb 2025 14:38:10 +0100
Message-ID: <20250205134500.433360404@linuxfoundation.org>
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
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
index 3f4c58bada374..ab5f8f07f1f7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.c
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



