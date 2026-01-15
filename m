Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757273195F9;
	Thu, 15 Jan 2026 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496850; cv=none; b=QWeVNLrR1Xmtto/dsqPJWvndbvr1BSC8RvdPK7/UXzYTg89BmLIg492KiUfAczvEnS0gPMQQEzCZcKAjG7pxts3P9FnQtfNEMxPjiq4wHxtjBXdPhO/7QBrzeGBPKPKg1MUxu096NdFHVvYtdCe7QryK4CD+TJ5Xf2xps2RZU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496850; c=relaxed/simple;
	bh=UMWbYdf50iLYJ1rWaXB0c9/PmA/NzENYMOQdRi6asHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMG0AgoiHis9zp/Ym7J51srrC/Mlcw5A/kshoTt8wq2IoLTnpxLjRUpwTT4y/jK/fYe0vPjMQk9FkKoOgRRd4mgp1pEZQ4opA9o6izAA5oRXjsYDHnxaqIzSV1FnZXpNhzpn6eEF+gquZVdXqusoHLAtDfsbTrFn19UxF44Ppog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrSu3QUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrSu3QUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF284C116D0;
	Thu, 15 Jan 2026 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496850;
	bh=UMWbYdf50iLYJ1rWaXB0c9/PmA/NzENYMOQdRi6asHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrSu3QUU5uyDjUXvylbI/Vh7yqNam5Va3LjHbwNqfrRwli0Yf8x4SEZbSKWM/Agjj
	 Q8s1aR1xTfC4NdrIZ9dtn8wVn91RVU8Y/T2+KdySSP/xkh4nNnvk+NFo6K5RAa8OMy
	 1sPT9cgSnD4hS9MS7v5fUYmasNU5YsaYjNLCwL/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/88] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
Date: Thu, 15 Jan 2026 17:48:19 +0100
Message-ID: <20260115164147.618607979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



