Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735F33BF2E4;
	Thu, 15 Jan 2026 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497066; cv=none; b=amLh3vkbiLADsX+mckcUUmLWZg/z2+Qj6hHRdajbkOZOToT+9yD1o3jZWoRuC7MCHJaK6pQxDDUYTHCWYxfIKUEgNgymHsB6iCrcV4FJXzqPa549/4FzQjcPQPgKaw/aufx6/3QS3l/m8WXeTSQn2U3l9DD4xVSOzVVqcWKL1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497066; c=relaxed/simple;
	bh=tGHc/ccpkFdl5RzBZnQI9pK9G2xLDnaxjGHEEce8vbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIJYP+5skLAa8tEIspayKBiGqXLH0I3RC/YyM5rvT0Uxpd6h2p8/94n2x69acX+ZfD6fop0Q4fQ+qY0TQV5X3Lz7oxSd/5qzICJgyYvKYSC+1s1t1BTXhQjB2xPDCK4fZuwWdH5k8N5tHsJcKirzhotowSjrRJiowe5hjHYAMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/BbNXAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/BbNXAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E7C116D0;
	Thu, 15 Jan 2026 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497066;
	bh=tGHc/ccpkFdl5RzBZnQI9pK9G2xLDnaxjGHEEce8vbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/BbNXAEmv6PyBUGquJjoExG25m4Nbei9VUFE5wy1BRKye/Plp1+FkiQp70PFCqs2
	 0B25e92bASQ4p4yPvr6vuBDPoemc4/cWPnaSKsFO7x/QxSST6s8Kmqf19Lr9dprEGh
	 z75jc3HwSMXqcdYXZJB8qPiC/6zYuhvc6So0x+kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/72] smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164144.407796988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit b2b50fca34da5ec231008edba798ddf92986bd7f ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_DEVICE_DOOR_OPEN. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 7ce063a1dc3f6..d46d42559eea2 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -44,7 +44,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_DATA_DETECTED 0x8000001c
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
 #define NT_STATUS_UNSUCCESSFUL 0xC0000000 | 0x0001
 #define NT_STATUS_NOT_IMPLEMENTED 0xC0000000 | 0x0002
 #define NT_STATUS_INVALID_INFO_CLASS 0xC0000000 | 0x0003
-- 
2.51.0



