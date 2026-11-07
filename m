Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061000;
	b=BDcgGFNPUDfQXrjCZ/sKPHInHcBfa7eUPAzVbfUSukjyrWbCi0luLMrCCsf2DQNBUpK5
	 Enupwx/0MsbRAzA33sSu7rzJcqX22/N5sonu98OqExqmtdSXiQ6geu1Oj01CT0RVx9C8Z
	 N8RhDcIaXEqsN1Vs5pmjNsp3I0P5fEEa+nQeqEv7r53zQVQoAxmMEaBdRs/hwbhwvtHSF
	 sq3Kz0Nh77C1vBK821PfIdgmrz5Lk3NFtr09heWW9Srd2qLLWMWRJ3hZrjRjR8hov2vlQ
	 pn2cQ3Qan2fD3LtspX9IOsEYkwR3+oamH8m2EQtBYO66GQu0C27rwOs34w3MRh5u3HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6JImH7DzNuGsxtMJ8UM/Vc9kpkbaqtZV5+HBVCYfU8=;
	b=AyjegTkT379vr67x4IufJJsp2cK15CV72+HDC4UOaoafeaAn3QF7kUzKwvMjhmN25E6Q
	 B0/i28b6/eo00LQ2DqFrMwrKVPJ+OLSgFElu8Q/BP4Kq67i+xuLULbvFGg/DEF+eg44A+
	 jWU5JAPmjT1OO9whYU52B/80DgDdEL5vz0x1l0DZm6SoDGGw5HQTnoQLMkYBe6+MiRiKx
	 d+HwylDbTEDikWTpkaOqm6MpCaMlh8QK6gi/+/y2nngeLESShiDZs9SKdqEbOgZ7NgiWj
	 ySiwZwUqMNUced0trYqCPNhAKp3uviY4vwH0L488kCVmZhmCAqA5vpiVnFiczp4AqlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXLJwU4G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13880606A33B;
	Sat,  7 Nov 2026 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXLJwU4G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FF91F008A2;
	Sat,  7 Nov 2026 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060999;
	bh=B6JImH7DzNuGsxtMJ8UM/Vc9kpkbaqtZV5+HBVCYfU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXLJwU4GxTfrM+W8sFkyZ6x3dL41QOQySBTSK1eB/5By9SxGHdS5h2pqqSJHbJPv0
	 zc0Tn3Co1tUryVZ+brA1KWEY9l/jmWkacJjmo804XnXzko/a81tkSst0us6QaUnhUj
	 HDLS/u5J7Pg4wMGV1ovKhfGDu92ksdcYro71/Aqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0346/1536] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Sat,  7 Nov 2026 08:39:22 -0500
Message-ID: <20261107135007.396545776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 86c84cc760080929b7be44bceebe5854957b99da ]

FSCTL_SET_SPARSE without an input buffer sets a file sparse.  Treat a
zero-length input buffer as SetSparse=true and keep rejecting truncated
non-empty buffers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f95487b25b664..e0accc8565f70 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8568,15 +8568,21 @@ int smb2_ioctl(struct ksmbd_work *work)
 				rsp);
 		break;
 	case FSCTL_SET_SPARSE:
-		if (in_buf_len < sizeof(struct file_sparse)) {
+	{
+		struct file_sparse sparse = {0};
+
+		if (in_buf_len && in_buf_len < sizeof(struct file_sparse)) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = fsctl_set_sparse(work, id, (struct file_sparse *)buffer);
+		*(u8 *)&sparse = 1;
+		ret = fsctl_set_sparse(work, id, in_buf_len ?
+				       (struct file_sparse *)buffer : &sparse);
 		if (ret < 0)
 			goto out;
 		break;
+	}
 	case FSCTL_SET_ZERO_DATA:
 	{
 		struct file_zero_data_information *zero_data;
-- 
2.53.0



