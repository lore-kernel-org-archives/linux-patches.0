Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061388;
	b=Uh1q5Zp2aOyhE139MdXKFCsa1t0Cfrw14uQq3EjdOE1nMasZFdFhSmK8Bh8+1H3A1I2t
	 j/jLcDRD+f0TnwCMNH277xBFL6krBlqfZPh/nrmmja++8U19575Tsz8yTb03CNQsmHREX
	 h72RKyxKYtzCqz6GX+3nhfj2maNviRX1863ofIO6eTQQojaqNZjxkpL/WJqkE6+aTUX2a
	 w2SvDPgNecNqpCRLqp7hvtrsd49Yv0BkSUTC9shRAtDien7ixIyc2k/2tsklqiQ5vKRY9
	 YOB1jpkv0jKT+CwIPGBcTwOfwjQOnS8h0AbK99Q6auGRxSKUxjwyucO0+uruj/h3jkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AWaga5fpUDsK/sLqGsxCIbWaQ2rEDF3u9iMWogJ/N7k=;
	b=CVeRWkyqSLyTJQskZJCxEuMuPpuFsX9H3+tE1fYlx/47xotOAIiaRquFrCH/b1virp2T
	 /RBku8G8q/x2Ae+9AmkmaxtCRS5OzgLokQT1AyEiDU6Adn6Da2o1DFT7NEWQeCvWOgMp8
	 AcpJutDPnthKdVmIqjlMecd17IZRqwMxgGyJ22pq8eDlXI6AVisEAsfStl34+pzrX79Sa
	 2kvHzmyX+dD/ThgbUfrdJe2lXgkeRujR3GeaUJAgiqk4RWRaAC8gZPfUCiZbzZVdHJd+U
	 /ARrk4wepkAEtNesnQZ32akksBZs6JqMHiIXeubTVSjUwXFu7U0P/lWqK46apq8IO6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5P4FaLG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA88D606A33A;
	Sat,  7 Nov 2026 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p5P4FaLG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A251F0089F;
	Sat,  7 Nov 2026 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061387;
	bh=AWaga5fpUDsK/sLqGsxCIbWaQ2rEDF3u9iMWogJ/N7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p5P4FaLG7p8IUR188UBHe+SSI3SgB8uvvZaq161c14aS16vwn2g1bxeu4BOBGI0kE
	 A+g+MmD2Q0A3OrEO3WMnlOUPyR5EsvkMTHVmRBwOGAlfcRMaXe0o4N68dVWkBuwTff
	 Lyd5y5UJbhjxjDND5T6mBMtIHRej7QM/uLOiwxd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0509/1536] cifs: Remove duplicate struct reparse_symlink_data and SYMLINK_FLAG_RELATIVE
Date: Sat,  7 Nov 2026 08:42:05 -0500
Message-ID: <20261107135011.736087291@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2948f0d4db40d839db2c1d141121c2e4e12a6faa ]

In file common/smb2pdu.h is defined struct reparse_symlink_data_buffer
which is same as struct reparse_symlink_data and is used in the whole code.
So remove duplicate struct reparse_symlink_data from client/cifspdu.h.

In file common/smb2pdu.h is defined also SYMLINK_FLAG_RELATIVE constant, so
remove duplication from client/cifspdu.h.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65d5dbdc089b ("smb: client: fix file type corruption in posix_reparse_to_fattr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 579addfb85476..30bdb424c81f2 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1475,22 +1475,6 @@ struct file_notify_information {
 	__u8  FileName[];
 } __attribute__((packed));
 
-/* For IO_REPARSE_TAG_SYMLINK */
-struct reparse_symlink_data {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__le32	Flags;
-	char	PathBuffer[];
-} __attribute__((packed));
-
-/* Flag above */
-#define SYMLINK_FLAG_RELATIVE 0x00000001
-
 /* For IO_REPARSE_TAG_NFS */
 #define NFS_SPECFILE_LNK	0x00000000014B4E4C
 #define NFS_SPECFILE_CHR	0x0000000000524843
-- 
2.53.0



