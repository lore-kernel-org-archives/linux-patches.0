Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064438;
	b=3bNFDzjucOaji/yTR2fV5xzXlzK6D+wg3DulWpCMAfikq6wGYdnCF2MD1VY5rRAYLyIx
	 zfTbraoCqSSUdneW4OZQubOHfZNMcrbS3b1JkGypz/Oq5fPBizdlr7w0fAMqtnGL2aXBb
	 g8iZI7Miy7c8yn4oWtepikrN6ZKUYjXG0jvwMjY78DKrqXvLee5fCxpY1qLRhqmsGays3
	 lOxGvuH/IDIM5npOfIPgmeYEkvHE3rQ77yCyX+ty1R52wB+xh67sXqJaM5AmE9U/DuSB9
	 IKvimMDZEMEjMzFJjBRbUQegnLLtMP1QWxicKSAppsQOIAXiEXuvfUpIp+9SakDFWUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1tLVI5vki76L0wjpuLO9kY/Eh2SeXBEysHC4WvyEKE=;
	b=ZDd5Nrx0cVH3TB0UWCXcbRBat3XFmKjeCsWbEl6cBzVVjw5qeH9gk94sP21wAWvd9ZQF
	 zpts5PzlMdAqV4u1tmutgTq5cOD1bNUkhhg0dvgbjanPkr/LPN5jOXt1+AnM3KS6J9PpJ
	 bCkgL1/Gag1prUzaLlTlXvWHifyOrvLYCiYqVfAQ9oa8nDfIzvNzlxbYWPYEcit/1LiLa
	 ULxsGqNANFVoYte/xr9v1sX15qdY+lOapVztQpRzxEnLAEIcLiR9UotwGS3sTiOQe/BJh
	 XUDFnfvXvyahLV9qwwDHQgPt699UVefcFS6QDWRCMS3T+slIQXdIHUXly74IUIPL9OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngvRYKkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA5D606A9DB;
	Sat,  7 Nov 2026 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngvRYKkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893701F0089F;
	Sat,  7 Nov 2026 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064437;
	bh=N1tLVI5vki76L0wjpuLO9kY/Eh2SeXBEysHC4WvyEKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngvRYKkGNNqG+utL7qYiXNo6TX6FMyFOqHGhd9C/dnwXjpQz52SnOLJAUdIUG6VCc
	 CUG7DdvnPcqnuxAlQo4P1jabfCuv7jZl4X1b18CksKwKkeJ7ITFnn0fj7/pHxt+fxq
	 FSlY3ZmyY79MPnJ+AhRc9HhPAAxiYc5OhOo7bnYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0484/1257] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Sat,  7 Nov 2026 08:46:20 -0500
Message-ID: <20261107134952.813810302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit bb38473f1bcb287567f2fa7980e483a778092504 ]

compat_getdrvstat() copies every field of the drive state to a 32-bit
caller except ->flags, which stays zero. 32-bit FDGETDRVSTAT and
FDPOLLDRVSTAT therefore never report FD_DISK_WRITABLE, FD_DISK_CHANGED
or FD_VERIFY: i386 fdutils (floppycontrol -P, fdmount), and other
32-bit users see every disk as write-protected and never see a disk
change. The compat code in block/compat_ioctl.c copied the field;
it was lost when that code moved into floppy.c

Also declare the field as compat_ulong_t: the 32-bit struct
floppy_drive_struct starts with an unsigned long, and a signed char at
offset 0 only lines up with its low byte on little-endian machines. The
size and offsets of the compat structure, and so FDGETDRVSTAT32, do not
change.

Cc: stable@vger.kernel.org
Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
Link: https://patch.msgid.link/20260924112825.3525931-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 02a34de691025..7465e10f36d46 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3600,7 +3600,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3784,6 +3784,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



