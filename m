Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E099510A3C
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWniUabW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547A7C433C7;
	Mon,  9 Oct 2023 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858458;
	bh=DYaBPwszaMYrQnjsCNojL4mMwO3pI2xmzSm711bPYTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWniUabW5IeorCrODwEhSkz/zitkTxzW1PmytwLfENou0HL8+HUFuqHyggK5rgOR+
	 QLDV5+pvHj2mdis7Tccr6lNmYIzCCiXFRYMp1DeiWVX91cM28LggzVoPUAl7H0RGb8
	 MbFHo8A/OMJjQJLbOPqCI1nej5wSeqhGHH/6BIoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.4 128/131] RDMA/mlx5: Fix NULL string error
Date: Mon,  9 Oct 2023 15:02:48 +0200
Message-ID: <20231009130120.335723658@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

commit dab994bcc609a172bfdab15a0d4cb7e50e8b5458 upstream.

checkpath is complaining about NULL string, change it to 'Unknown'.

Fixes: 37aa5c36aa70 ("IB/mlx5: Add UARs write-combining and non-cached mapping")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Link: https://lore.kernel.org/r/8638e5c14fadbde5fa9961874feae917073af920.1695203958.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2053,7 +2053,7 @@ static inline char *mmap_cmd2str(enum ml
 	case MLX5_IB_MMAP_DEVICE_MEM:
 		return "Device Memory";
 	default:
-		return NULL;
+		return "Unknown";
 	}
 }
 


