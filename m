Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A4260569;
	Thu, 15 Jan 2026 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496844; cv=none; b=cawH4RtdPftoBJA8aY2fPF+yMz9qsu/oj69X9ZKCrUXUUzwzjtaSnKB492Cv++TvxG6qRBR77Wi7iED+NQAl4nUwoyAVa2Kn+al9lBBZjVaBBUuFt+biBtaNIfdIVXQ3Oes1cwGHoj5jL6Z0c00xLJGdlRP89lIygjR5PElZy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496844; c=relaxed/simple;
	bh=a2uUX9fpoHQrh33KHfjAw6bnMy2wzu+DOaI0d4A29Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGF2bABDI8w7M4ZLz1Wx1QNSTMN5dmXSOYsIOMJEIR0S8ofYUZjBXsS7b0iESJBx9jNan5wdUtM3m08Y/7mH9sFJPKNy2l3zlxvEC0lfX9OKhipjMMC/BCtvv8wp4ki6e9cWxW8kRx+IQfV3j348npEfL2nev4IJpriWXV+c5K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeQL4oLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeQL4oLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE79C116D0;
	Thu, 15 Jan 2026 17:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496844;
	bh=a2uUX9fpoHQrh33KHfjAw6bnMy2wzu+DOaI0d4A29Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeQL4oLWDF9YamX0vfjaAD6HTQP+rJElKufLoqGeDUZ4g0ZB8NvDCzQ5Sfq7YkJl7
	 K/yFPySj+iS9hsKRFQPxhki8VoXEaNILRC1Bc48AL9P6N5BsnAlI5q48ypNgVSFfcl
	 D+tP6ibZAFGoUY9n2HQfg04BcyXRWHXyAdHVBwbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/88] smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
Date: Thu, 15 Jan 2026 17:48:17 +0100
Message-ID: <20260115164147.547052014@linuxfoundation.org>
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

[ Upstream commit 9f99caa8950a76f560a90074e3a4b93cfa8b3d84 ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_UNABLE_TO_FREE_VM. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index edd4741cab0a1..7ce063a1dc3f6 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -70,7 +70,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_MEMORY 0xC0000000 | 0x0017
 #define NT_STATUS_CONFLICTING_ADDRESSES 0xC0000000 | 0x0018
 #define NT_STATUS_NOT_MAPPED_VIEW 0xC0000000 | 0x0019
-#define NT_STATUS_UNABLE_TO_FREE_VM 0x80000000 | 0x001a
+#define NT_STATUS_UNABLE_TO_FREE_VM 0xC0000000 | 0x001a
 #define NT_STATUS_UNABLE_TO_DELETE_SECTION 0xC0000000 | 0x001b
 #define NT_STATUS_INVALID_SYSTEM_SERVICE 0xC0000000 | 0x001c
 #define NT_STATUS_ILLEGAL_INSTRUCTION 0xC0000000 | 0x001d
-- 
2.51.0



