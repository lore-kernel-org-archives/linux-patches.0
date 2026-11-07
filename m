Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063248;
	b=wZVNhbhm4MyiR67qVHa5VXvtUVdNA5SEdRpovtCIlxywp2W5cdCPM299xPiLK9zCDGwR
	 PKlDYxj839gDaMu0M4YL7mZNCLudtVpIwWQ/dZZ6x8lsqXbnVqh6GxONSOW4o9Iz5I6xt
	 dXHm0Adosc/AaddEO3Ju1Z2sBOteXHo3j2llGhkzF99RXUcGYWbh647C7omUZPxssT7Fp
	 4BAh+Y8lYU60MWo54ozlU4XR4eCL6QRxp7L7oUaIrtOVpwtY21m4zcyFdUMge29fPLtGa
	 8YIg6fcWuhn2Q5Xv+sS0XVONoGJ8/a/HCmN4zpX6SS2Utw+4H4PovcRxFWV/Q1gOK5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qEcYdKkxRygVALu6IvHOe6gEwpH96UFzqePRRFmQ4H0=;
	b=f/+DIUgzaIkPyNJa7v0STb7V18Nf/uxWNsLTb4zSogsNZ0lp7LJHRcU28LVjGHte6zaD
	 NqMpf4tSifw/duNOvNZ6Y2ZuhTpQC4mSXPmZD9Z/E+qM/qKpfOZDhyDqflP2C29SK80IR
	 HLWH4+vzMTOF6FbrTnPpcJHJqszfFXLjlEXPliURHRG59n0foyPett86X80GZosBhzcOV
	 lmsKjeDWR8tS/jyTkaHZ7t9LB+jjm6s1oJtL7jLjUJKKhND8x8Ha5+2Uw/t0LoxdwJjNt
	 KkCAZAemkMQjPfbg53BJ0XBWs7KOu9C5uAJkDA7lC4da4yDDnccJE5JUUi3NdtIx9fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnWg9sIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73974606A32E;
	Sat,  7 Nov 2026 14:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnWg9sIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4CF1F0089F;
	Sat,  7 Nov 2026 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063248;
	bh=qEcYdKkxRygVALu6IvHOe6gEwpH96UFzqePRRFmQ4H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnWg9sIr1BMMYlO3MO2cR74xSyAaRK2HE5v423F/qy5BYTagsHg3t94yqatp1zkfK
	 nOX8ixoDXzsjrsLrGpRlSbAth86JXaZvdSbEKXZ6XXDfQ1JBjdICwGzBJvp3/F3BmP
	 IYrxNjLcKK3omOfhLIRG4G1xg0ZVEUfJQIQIbjAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/869] vfio/mlx5: Fix boundary check in set_report_output()
Date: Sat,  7 Nov 2026 08:52:14 -0500
Message-ID: <20261107134909.044790624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seongjun Hong <hsj0512@snu.ac.kr>

[ Upstream commit 37b2ee6747b7857920ebc71eabc25208a39164a4 ]

Use > instead of >= on boundary check of recv_buf to avoid the bug which
the full message in the last slot of recv_buf is ignored even though the
received data size does not overflow the recv_buf.

Fixes: 9c7c5430bca3 ("vfio/mlx5: Align the page tracking max message size with the device capability")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
Link: https://lore.kernel.org/r/20261005-vfio-mlx5-fix-boundary-check-v2-1-75599d2f4497@snu.ac.kr
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index a92b095b90f6a..a870ea1c0e9d3 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1627,7 +1627,7 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 	int i;
 
 	buf_offset = index * qp->max_msg_size;
-	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
+	if (WARN_ON(buf_offset + size > qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-- 
2.53.0



