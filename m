Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044771;
	b=A+4ll7idTtmgaGg1wxb6kIUvnZKBNc+WnkRXVnpz/x3n6iTHkAgHfBw4uIHkq4305SZZ
	 rVJdh0SClOSf/pTJ0jvdscRV5L3zNu3uyw0KLvn8MZU5LFFbNp5/CUzGsOTjgRok3rcz3
	 EDEOSRcanh5GaNMnGxYP7Sa2LhysbbprH49IwK4qBtfO3zzqvJW3JhiegDk6vMHDPVm4a
	 52lrFVk2DRKj8WfYpasCr1Sfi+m52Vw61EPBd27I8cHwoctRsIM/Gp/AT4vQcLKahwNQN
	 FTihqhWbhAkROOwG3RKqSI7wq3TJoWPPuVQoTh6VO393MuhlUkVB88j4P9JgpSGK42A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBPQ/ozLP9ZYzpvIczOZnBkJEXwhtwgXCJq0V2gkzEM=;
	b=rdhttdfO1A/XbViGsSX25S5W667JZGNU3nd+EEbr/J1SRidi8GvAwZ1T+D6TnvTJ7/Ru
	 Xqlbv5sHmmosC3LZQSIgxGzzLOzMMacskGv1G1LDbrW98LG6eP6e8HKM2dy2RWee93Bss
	 Gg8RLzh7ocSUQjUdHIB31ZqGtIKOlCSX59PatzfJVcE7SaBIgPDG7Uoa/5FYoJUkrOn2t
	 e2UZDsIHHAxJcBU+RGr0KkkNAookc57/m9V2+GSBxTRqF2Y3B4Da/r+JLHESdB7Rkr4uW
	 PHYO1w9sRoLqfr+nErrgrl8HsSJsYQIa4U9Kiwlcu5bkX8iHJ6zfvjJ5w2U+IVYZjXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI9LpN+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D08E606B993;
	Wed, 18 Nov 2026 23:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI9LpN+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826C11F000D1;
	Wed, 18 Nov 2026 23:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044771;
	bh=vBPQ/ozLP9ZYzpvIczOZnBkJEXwhtwgXCJq0V2gkzEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI9LpN+daeeMl4wVfqz01kTW2t89qbD1atvhhyuuA7m3F4r/OmHHHfgV3jQq7cP/4
	 jXiC+3OXspUt+cg//jkMMiS0Q2Et2mgsV1uRRBCp9TS2ljMj7DTyxDm9WNKR1k64nC
	 iYf+kjVLbMgRJtYng7LSfiK6w9VEIDFf+k6Kh09A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 0687/2857] smb: smbdirect: fix buffer length underflow in RDMA transfers
Date: Wed, 18 Nov 2026 15:28:41 +0100
Message-ID: <20261118150226.294511689@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 7193241a49c958782ba4b8df06da3734d1e317d2 ]

When a remote buffer descriptor is larger than the remaining local
buffer, smbdirect_connection_rdma_xmit() clamps its length and sets
buf_len to zero. The common accounting code then subtracts the clamped
length from buf_len, causing it to underflow. If another descriptor
follows, the loop processes it with a wrapped remaining length and
includes memory beyond the local buffer in the RDMA transfer.

A client can trigger an out-of-bounds kernel write with an SMB WRITE
request, or an out-of-bounds kernel read with an SMB READ request, by
supplying multiple RDMA buffer descriptors with an oversized descriptor
before the last one.

Remove the premature assignment to buf_len. Subtracting the clamped length
already consumes the remaining buffer, so the next iteration stops and
only descriptors within the local buffer are used to build work requests.

Fixes: e628bf939aaf ("ksmbd: reduce descriptor size if remaining bytes is less than request size")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-33549
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ metze: in 6.1 the code is smb_direct_rdma_xmit() in
  fs/smb/server/transport_rdma.c ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index bcf0631ce10a6..cc9409bb5404c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1378,7 +1378,6 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 		if (desc_buf_len > buf_len) {
 			desc_buf_len = buf_len;
 			desc[i].length = cpu_to_le32(desc_buf_len);
-			buf_len = 0;
 		}
 
 		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
-- 
2.53.0



