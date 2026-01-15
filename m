Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6581C5D59;
	Thu, 15 Jan 2026 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496049; cv=none; b=TeQ5XLfr2KSIztSViy7QgR53Dlcmo3NpBG1PLihV1py911P7Jn37oJxnflYRyzt4c/Y3QD3By1Cdu63s/KYOQp1Y0CDpRrahR5NVjZc8hYTJeJdg/lS4kkPQyVOc6BnVXPE/kb9I3OYmU6A9S9Zy8GP08OstMGjJ1kHtP1W2KWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496049; c=relaxed/simple;
	bh=LljWX9WI/78fZQz5OU0VSTjp2q9Jd8XEI185i+RJGgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO6Cuii8nt6wGUA/obKGPj6wzIqcE0zJtSQrnizRRahAKi+kLsAO5JzF8I8y2QGC059NvEKBXvEvkGWug3Zrg8kikRQrBfBXGP2rahvf7iV4wteOnMtiBabMF/qoPLGFvInTHlAxZxjGjv7sWA28qFyOFhcotX7JkGLA50Q+DLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6b3Y7ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6b3Y7ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE268C116D0;
	Thu, 15 Jan 2026 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496049;
	bh=LljWX9WI/78fZQz5OU0VSTjp2q9Jd8XEI185i+RJGgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6b3Y7ZVUfDCfvhRCMglpt6qdURFWXRV+o8BVsUmfI/NTSfoZQZur8FbFUVIFOqvg
	 vQgsTLGkcAjgpp3YZGheZpH4jFbNttN7iXCYQesSmZE/V2LCUelgi5Uivm4z7U0YwP
	 TJOWaDRran6IL8r4m/xJpWz9S1P/5okwRdNsW2Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/181] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
Date: Thu, 15 Jan 2026 17:46:36 +0100
Message-ID: <20260115164204.457850507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b3516c71cff77..09263c91d07a4 100644
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



