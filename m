Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045421;
	b=yDyTbQOZP4Qmfm40N5V+y/XnSoPkf11R5zFuO5DfS+YV9Az/ctwMQOmFXYJjEoNm/LjJ
	 qOmiM6RBvDSjxlWI+b2M4b33qIKZsD0WCfEga7DYrBlm0TcxFA3mvmSqgYY1WaLcfTZqR
	 8ZJi4XF0ort7OVCtOCoqefFDJS65l9roP3I1t0Gi4eSWnHjLEED3Ng9iDx98rf0klbu8y
	 b+tmeKlX+mn56CeOT7RTebrnpSACADbhmaxS1FcaLYs0E4N7PwbZvy9+oJ3/UQ7DoPe4L
	 /FC7NtSxcMjslyDUGxSKfCcY7QsHJVox1tmh0CteLL+rSx+DJWFYmdXw1nYEFwn4q6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dqu9CO4RbATdvr40PvIHQtiHzYZOnQNHSPXnk6Y/ckA=;
	b=u7Q0bPBA82Ew2RNHIwssjcwEOwtIDUixByPc7dcfi8ppRqC3ZIefWdCuQCVd5SCrouf8
	 MaLTgA4TVS3r23jY9xqyIrCvDuZc2lZzSZvjefqofwSQ1lUw894yNX3sRNcYWfwiN1biZ
	 POz4QbPiKAWULoHw4VHpCKXsjsvRSYwmHx+wV45z3/+FWjWNM6ALllKTHMdamiOpGtAER
	 jSEEy9fIdWsEpkUiN/iIL1Ux+5ZmTCqUR9ALPso4WGbePfYYoqZ2SuYD4E+J2utpYj0DF
	 8ih/oNKkUJfKnUgVVjBuoK+ekB1vDQR+3WiZwp0y5Q28fmdIRSGbfMXoDRWdSntXtJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=on9dDJi7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E831A606A320;
	Wed, 18 Nov 2026 23:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=on9dDJi7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC611F000C4;
	Wed, 18 Nov 2026 23:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045420;
	bh=dqu9CO4RbATdvr40PvIHQtiHzYZOnQNHSPXnk6Y/ckA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=on9dDJi7PuWDFk9+1fINHwVCkGSy5Ov0RYPpRYWO+E+YTDFoEZaR+ULwnN1u+bL7+
	 gOAQO+ujv+sKY+/kxqtetsGaX62WYMHOwz+pw46LKgJQeH1R1IxbDgi1FTTE2/jVIv
	 QKWvw49xkIvUacrHRNxMrgMHxhIuBi6zHzFRkOWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Seongjun Hong <hsj0512@snu.ac.kr>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0917/2857] vfio/mlx5: Fix boundary check in set_report_output()
Date: Wed, 18 Nov 2026 15:32:31 +0100
Message-ID: <20261118150234.599421817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 06794c48170c0..87eeea68592e2 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1231,7 +1231,7 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 	int i;
 
 	buf_offset = index * qp->max_msg_size;
-	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
+	if (WARN_ON(buf_offset + size > qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-- 
2.53.0



