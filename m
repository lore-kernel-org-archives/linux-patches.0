Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C36929C338;
	Thu, 15 Jan 2026 17:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496518; cv=none; b=WatfK4f3BveeoRp0phh65PddYxhHkFu+UQJr/2rggGATPSscO2FNpIIq1fFqvVQhXLDUyzwR5JSq0bNR9xYv4Uv9Nlm8RiwVpYMLZ1EA6mbBK94Xr/tZRbAZ5LPqXs+JaAuC6NEipNtPPDPUcnQcSFojcv/XdslX3ucmNcyNc5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496518; c=relaxed/simple;
	bh=v+pluQGsk5dzG5dkoovIZfWOXdOfzInoUfd/bphRNVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQ1s9qrzuDmIVaUW96hBg3X1YqaSar9IYum6H/KFE88XcQB1UM9nHsO3FVHhre2uxDpUTEuzgf2ipP1rA20kelvDDN6oR9tx/jJwplpD0y7KCSwt90LEwjnJuu75dFVPqm5J+nqLBx0u3WONRQ99x2A20gyv2rkDyrxzula6Nd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW3eg0kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW3eg0kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A27EC16AAE;
	Thu, 15 Jan 2026 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496518;
	bh=v+pluQGsk5dzG5dkoovIZfWOXdOfzInoUfd/bphRNVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW3eg0kUbvcgOKI5kAxcOb9lQjlVCvglm+4wA+CI4sI1zfi444GCy3TVOdpz0JWzX
	 c0QwHx4QLMh+zZRHpvj9blCI2kf/NCd2//9hMTIU6hbtqgimlMhvho7FKEs+0PQcvk
	 ytU03WLlXIxRnRv2mIhk/J2HS9GoH76zhZeOqiIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/119] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
Date: Thu, 15 Jan 2026 17:47:36 +0100
Message-ID: <20260115164153.442888611@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit a1237c203f1757480dc2f3b930608ee00072d3cc ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_NO_DATA_DETECTED. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index d46d42559eea2..e3a341316a711 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -41,7 +41,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_MEDIA_CHANGED    0x8000001c
 #define NT_STATUS_END_OF_MEDIA     0x8000001e
 #define NT_STATUS_MEDIA_CHECK      0x80000020
-#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
+#define NT_STATUS_NO_DATA_DETECTED 0x80000022
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
 #define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
-- 
2.51.0



