Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034702;
	b=aOX6Plzs3BI0hbR0B3fvIK1XlKHGeydAe3/Disz23bD8Ndg4Qr0e36wbFzQFBeTmkE9n
	 PUigYudVJePStFMDC/D8zFzICiV4e4o5YqDpRFfx770O9iGKXi2plbMH/4bX8Bvsz+EIZ
	 Nxv2eVn34zVPJjk4cksXzQuMAIEpU4OiMl/CBqDi080wDM29glK1irqFJrviSLQrLG6W9
	 jq93QBLCUPlrzRdlCz86aR5wq0kQ1gprpqqvDI0UZcxoeMctYdXlRGL/vIwO2iHhDZtFD
	 j1VHxWMmJhvrEqhJKgRlN3pW58yVFNasVMcKjL2GX5O8FYYbEtlyQCFoa24vxxebvMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0X5MROJPsVgXwJalDitWpmZYBprENqwHb0GDJHUK6s=;
	b=mSTX97GTsZQ0MpyU1Cl74fF6KK04x+kZNqfFL87zqulpeYusyV+dkP2jIY7UJobGkrxl
	 k4pv4Z/7bxAJCq2tg6hp0ZsWXaLnNWA7cGc+yC/Hj5B62tToa5wLhl7wHfHXU21f1/tbG
	 OMihnKoUezGYEduyuXsp/nmWP6hoI0T6/UQ+4I73ENHquVtsgbfSRCDid/BOz8VQNHyDn
	 FzbtDgPr6MwYReuPgLp1B02cfrlZLM0XFXb0QLoYyJTk5QthU54aDyQeMZP5xVtwjhkDx
	 ZU+KqeRqSjmxR5e8/WDGxaRHMuUFQmuXhmbsCnZwOoocRUhvYS5tqol4CTSLApyW49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSydT6i4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA00606A330;
	Wed, 18 Nov 2026 20:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSydT6i4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0191F000C4;
	Wed, 18 Nov 2026 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034702;
	bh=r0X5MROJPsVgXwJalDitWpmZYBprENqwHb0GDJHUK6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSydT6i4FU/FBeTW/7slvuG2nsGRMDX/UIKI8JF+hBztdSJ6U1o86psWJgmUqI0g3
	 10WLGaXHHDOm2iFis7/Gh3WpVq+hBvNj2l869YhnlnHhfFYWkeZAP37DibHBZxtp9b
	 6P36VxuaeMzNduWMY32QMAE9Y21LbZAnx/T3iTuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0462/3318] smb: client: fix file type corruption in posix_reparse_to_fattr()
Date: Wed, 18 Nov 2026 15:18:04 +0100
Message-ID: <20261118150330.695377986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 65d5dbdc089be42fc48a6f77bc6b648307f34b17 ]

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Use a local ftype variable to collect the new file type and apply it
after validation succeeds, clearing S_IFMT and setting the new type in
a single assignment.  This avoids stripping cf_mode on malformed
reparse points where the function returns false early.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 733f475f07ce3..010d12b557160 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -754,6 +754,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_open_info_data *data)
 {
 	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
+	umode_t ftype;
 
 	if (buf == NULL)
 		return true;
@@ -769,7 +770,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFCHR;
+		ftype = S_IFCHR;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
@@ -777,22 +778,23 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFBLK;
+		ftype = S_IFBLK;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		ftype = S_IFIFO;
 		break;
 	case NFS_SPECFILE_SOCK:
-		fattr->cf_mode |= S_IFSOCK;
+		ftype = S_IFSOCK;
 		break;
 	case NFS_SPECFILE_LNK:
-		fattr->cf_mode |= S_IFLNK;
+		ftype = S_IFLNK;
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
 	}
+	fattr->cf_mode = (fattr->cf_mode & ~S_IFMT) | ftype;
 	return true;
 }
 
-- 
2.53.0



