Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027595;
	b=hHtjnGQHDp//ffrdZzUFVAusCUreRbF9yUWzcHeP7YTkvqqVEFvT2O108sOpAYlNfAas
	 dPj2UpmYbx/dqGBAWqPKa+ZcwHXoUFPG1pmBEvN0zUSHHBDqLhGoQHtFPfz0bqjlya2dQ
	 KllJ0QkNPdl9NMtAWqlht1nFMP9u6JA/lNwFkLWLXTanrJMVxJnw5t96odcrSFLp5fO7R
	 xhZ59KOggy96X8Z7+hahWSkSr0j4V7gIwEHALBwsD8e3z9ryWYg+brtXFwIx5n8YT6lFD
	 Cik7vwXn/QkKGiF6a6dj64VwBhArkqcy1kXogefxmm8XX7f5wBd5w0OBDFbrJV/zfoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZPf18lGQCeJ1zG1cQa8ENQ7ggOZRo/u11Q8CLxzvqw=;
	b=ezwKG+K2GxiCht8zF1cLTCWSlEwb4/BgbRWlBuqdoIYxW+RO5qBXcenS7ZirY8lu4iw3
	 di/DI3gAovC+UVKjfOGarSM1nArca5zsZZLQI4hyfAkCTqjhzFDKEVYhwdQExcwYNEV5C
	 M8EdFxYGL2E6uk7ESIgk5fAecbV+MlMnOoILqj2NtwT9FR1Fj3MKCzdfn2SgIF+bFYyf4
	 0SnK0hhgM9kU6THyAV7vvgppvBXEzIdfv1cqSHkIWQPCvvbnKFRuG7A95w1RoE8X66G3i
	 H4gw2mEZ+uOHFYgzpH3gRduml+ARmJOUbh8d1MHh5wYG+SurZZFbHKT8DgcFVS2jCvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkjV8g7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E060A2606;
	Wed, 18 Nov 2026 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkjV8g7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277DB1F000C4;
	Wed, 18 Nov 2026 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027595;
	bh=NZPf18lGQCeJ1zG1cQa8ENQ7ggOZRo/u11Q8CLxzvqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkjV8g7Db5sj0YFjXeXnVIk432T1lgC11reKHlsqAMPSThJfDsiFdqtlStqgP0DM7
	 ZFnz4CcW/IUu2BbpvJax1rkdPCStZEYB3lFoyaLQ5BYWxcxT3qnCQntag1sFU0wHvL
	 TfYD3GP/3xhKBr1x6gSn9uSn8mnX6L8Nw2+68qQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1845/2151] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150229.005139885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 2c50a4a5e75db55880eca43c035649cb51fcb52a ]

fsctl_query_iface_info_ioctl() assigns nii_rsp to the next output
slot before checking whether the interface has an in_device or
inet6_dev. If either lookup returns NULL, the loop continues without
advancing nbytes, leaving nii_rsp pointing at an uncommitted slot. If
no later entry is committed, clearing nii_rsp->Next updates that slot
instead of the last returned entry, leaving the latter with a nonzero
Next offset.

Fix this by using nbytes to locate the last committed entry and clear
its Next field, but only when the response contains at least one entry.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 51218b3c7e8f5..c31b5277ddbd8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8336,9 +8336,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	}
 	rtnl_unlock();
 
-	/* zero if this is last one */
-	if (nii_rsp)
+	/*
+	 * nii_rsp may point to an entry not included in nbytes if the IPv4
+	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
+	 */
+	if (nbytes > 0) {
+		nii_rsp = (struct network_interface_info_ioctl_rsp *)
+			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
 		nii_rsp->Next = 0;
+	}
 
 	rsp->PersistentFileId = SMB2_NO_FID;
 	rsp->VolatileFileId = SMB2_NO_FID;
-- 
2.53.0



