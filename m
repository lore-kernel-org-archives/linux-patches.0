Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031071;
	b=tJgZ9+MA8GQvwjEx4/zsDgqMg0DhJCMeGlPDaNtJi7500jqwQpQOe8naysNx/XID72xs
	 p0xuqUe+Qk7Qxy4Zt6YMHfQio3UpGvm/dRdaoQ7fbpnn3nqOOYGYSEDz1cUyOrkK2XJWz
	 3ZOQYbHJydfH9Wkid4Lho99SCwAFC30TyMkPYOGuUPr7DjAVhUnhmigxC/NbfENm3TpUO
	 tHDKT4hSmmx5S/udyls7VCUIH+XMSfoh818V0aaJRkSduAZUaxQs46VnMNK+ukZH6ZQh3
	 FJKBPvX8heRG5hohzcSXdVW+NnebFifx57/LdV1uKzSNeTFixp1Vy1f7L1xWlSBfKoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aby4c3l62de/gOArX0oWhMXJUXTfnBlh4c7tr8g04vk=;
	b=NV8oHjXCLK3j96Gf7420fBu/KfdHfrutQVUk7iU8E80Zgu+nolJ0Wg7Qqqxv4oMTHFfe
	 lZ/nkuQ/HZlspzvlQL3+kBzRlKxzMpEpU4CGCh95iQmIr1dvJN+Dz20/XtEuOos725z8i
	 ZTcfpgS7i+fsj62gRjAMQlcBc5JWQsi9WQaNu+iTFjVy/JHeMOmMajqYUPzjtsfe7hUqQ
	 nWRFb+Ayd3blsTMTj3m/RyOs9I+u9kXWNdPMaKF3Ju0zuAgr79HNJ9vSyJ482oIOAbi55
	 L9+pJqvDgw1njRv6qeZ6CiHzj9PeJLAvYMHwf8qx6eNcWJ7hFrv8eTW/M11KXxfFCLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/QUPeKw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015B8606A31C;
	Wed, 18 Nov 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/QUPeKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB951F000C4;
	Wed, 18 Nov 2026 19:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031070;
	bh=Aby4c3l62de/gOArX0oWhMXJUXTfnBlh4c7tr8g04vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/QUPeKwWM0gZn9RyQ9ezWRTuB7WPNJVgjLwGwDdxhUJXkzzayKSS1y+YhnRisajJ
	 I/3aOKnUQaS7RZvDrlfJhwFJ3ttqNDXs8Kx/vBjML76xRhuPkWvm3pQDImPhex3Fbq
	 gYKngFJq5c1EjXZfNVBmuQz8D8GjLnj+cbqqOrrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jiale Yao <yaojiale02@163.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0876/1756] wifi: ath12k: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118150044.263645709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 13b15eabe2c541b80406166964cdc8ccb5e9c32a ]

ath12k_write_htt_stats_type() accepts count == size, which fills the
zero-initialized buffer without a terminating NUL. sscanf() then reads
beyond the buffer.

Reject input that leaves no room for the trailing NUL.

Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261003095913.575108-1-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index 6f2e7ecc66af7..df95a4ebace84 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -1646,7 +1646,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
 	const int size = 32;
 	int num_args;
 
-	if (count > size)
+	if (count >= size)
 		return -EINVAL;
 
 	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



