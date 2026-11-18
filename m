Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051550;
	b=EfOGAfIgEKwMQqfxsrD/YOPxqArYIUgU+IbIbDgXOtVytjKuL2Nw4kSBffhgTuf0W6RE
	 QULFBGARB8Q5bD57BpQspV6lEs8Fzdg9WGN2sCAFrQ8L54uj+yXfTNew2wRgHQx/Si4XD
	 A7ij7UQGbQZUENw7XgMdegpcvs8QRfFHoYY1M1tYorf+vpbsHDoBUQK1FLEplKB9iyimG
	 8JOUsBqupFfhF4pqPcrwl7G4eeScU2S+paRQ7+osZRvNnEz02u40Th2aapijEmEB2dYaX
	 tJamOLfIL5WUHds6O0zyFZRbzbYBt6rfsCfsBVjX2uTi3BxHOF/t/1tRCM3rIIRd/yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mC56BecN97DZKDvhniQ632y4oucwgDcqL+F6cE5h0Ls=;
	b=MQPzuXQe4gk7eolDSxe1wv8au37keuTYi00RylM9etg00QJ6qQtuNNaVA6N6jYVWtiBf
	 hNsmtzryrNFzfaBFxqDxYu/Vy0Zwroz+bCufvZHpjVkPZmFRiuD40u1p2TG/Gsdo++bpm
	 f9VWkF0DFBTNTNEXGighmqNEKOqszVgUW9mfgZBjmPKdBxrZDqbIBhlgX32yyiNd3ZY3R
	 de42TfDaVQTiR7++5KLFA8Tv4SWxgInVPtTERYJihasGFVajMsmGrHMQnKEu4X1iVm2JM
	 e7xPsMLUoGeMXD/FizIvbWk3UtvUbzl0BkUw84WCH+ux/qsXDhX3zBXmjHNcMD/WMDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfswVbDW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0DB606A31C;
	Thu, 19 Nov 2026 01:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AfswVbDW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50AE1F000C4;
	Thu, 19 Nov 2026 01:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051550;
	bh=mC56BecN97DZKDvhniQ632y4oucwgDcqL+F6cE5h0Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfswVbDW6pPr2RHI/0iNMI4z9uDRALKM7vvqbJxsEqOX0J4Jx/Ddy5nMyqxNSXr7Q
	 WZRhcBCqKc/BUPz86BGDtS/0U2YAxm1xcZoIbITDEpmPhxRFXiDLYOHJQ0RtnwGHs1
	 AtSLSAFoD9tpay8RNvX6qtGbkhHtBdg2NevQ03zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0211/2214] ksmbd: allow FSCTL_SET_SPARSE without input buffer
Date: Wed, 18 Nov 2026 15:31:27 +0100
Message-ID: <20261118150018.623305486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 86c84cc760080929b7be44bceebe5854957b99da ]

FSCTL_SET_SPARSE without an input buffer sets a file sparse.  Treat a
zero-length input buffer as SetSparse=true and keep rejecting truncated
non-empty buffers.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 66f3bc4ddd2bf..53be62debf2d4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7928,15 +7928,21 @@ int smb2_ioctl(struct ksmbd_work *work)
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



