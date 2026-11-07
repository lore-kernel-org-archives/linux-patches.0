Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064597;
	b=upoRXvlVHeHH+aqELnLHu+7VL2ji7KBF2UxI3o7dtfb6fNnNXKuVeNxnsBCskXTERV8L
	 EgD7SW85hbo/M2wtG0R1rrWuCiY9C5s9hF0hJoVZ1UB/AhGLr/vFkNiuHBMW8M5+zfv7P
	 crH803KoEbImfyaipL1M8d+6As/nYy+R+CfsHDO0HKXK1sAfatj1KXdoTcVPrIaEBEfP7
	 ARci9UAhMTdzzbreQF8ywCKFG8dk8zJ8IIREjzVG6E5/QRODX31h+gTimMXzwX2W3OKOI
	 ViFqMyTfIVerfgWEKBYynMKT2qKTWieLqoRB4f6XbVpAAh5svJ0Xir3/YpnEbNGk3VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3J40IiDO1KU1BkV7QdMhXMOh6lCgFV3hi8fnChHdTjo=;
	b=N49UCvU2UHo0GwTrG/QTeKglXBBezzgYcNnuY9m3PdoP4yBwfMQM8/BD/eexRf3ZHZQl
	 G62RUIwAsfOkeZjd7pk6Bm4AvjEHBu0uEOAzxdAHZaqDxl+czDRYernUgm2CBDp/440zD
	 b+hS+rtaG1iqN8xMUbgWrnsRCqo1rWUNZTQeCqpUP3tx1XUfdHZkBHCBEZd+VADNnkUl6
	 ggcAF0r0HtATYxM90SETsW9jOzoAYXuga7l6hs2F7q/gHBQVXVPr/AvqbhsxJq+ZC/zNw
	 ridssOywQwf5Flla+hM0S4vxEgQi0E8Ecyz3nH0Zd344weHSaTzEz+UF1gxARINHN/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6YeVsRK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038C606A9CD;
	Sat,  7 Nov 2026 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6YeVsRK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6CF1F008A1;
	Sat,  7 Nov 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064596;
	bh=3J40IiDO1KU1BkV7QdMhXMOh6lCgFV3hi8fnChHdTjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6YeVsRKSk6EYuU9+raoPh8UPXAbDq1ixFYqWmOrP91/XM7wkzWf4dhQQ2eLcSeSH
	 1URk89olsG40uDFHgCLGHhnCoIK6AfvA7ZQZLB+lbfdAsMseIeRajRyWOklDRDr0Yi
	 TteeMaTN+q4/5ySTyLBqxeHkkEBMs9BntE/UzZ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0611/1257] vfio/mlx5: Fix boundary check in set_report_output()
Date: Sat,  7 Nov 2026 08:48:27 -0500
Message-ID: <20261107134956.182941962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 5fe0621b5fbd8..04180035a7fea 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1644,7 +1644,7 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 	int i;
 
 	buf_offset = index * qp->max_msg_size;
-	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
+	if (WARN_ON(buf_offset + size > qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-- 
2.53.0



